# --- Configuration ---

# 1. Check for command-line argument for the input file name
if ($args.Count -gt 0) {
    $InputFile = $args[0]
} else {
    $InputFile = "urls.txt"
}

$OutputDirectory = "html_output"
$LogFile = "Detailed_Accessibility_Log.csv"
$DelaySeconds = 0.5           # Wait half a second between requests
$TimeoutSec = 15              # Maximum time to wait for a response

# --- UI Configuration ---
$MaxUrlDisplayLength = 60     # Max length for URL display to keep UI tidy

# --- Setup ---
if (-not (Test-Path -Path $OutputDirectory -PathType Container)) {
    New-Item -Path $OutputDirectory -ItemType Directory | Out-Null
}

# Check if the input file exists before proceeding
if (-not (Test-Path -Path $InputFile)) {
    Write-Host "ERROR: Input file '$InputFile' not found." -ForegroundColor Red
    exit 1
}

$Urls = Get-Content -Path $InputFile | Where-Object { $_ -ne "" }
$TotalUrls = $Urls.Count
$AccessibleCount = 0
$ResultCollection = @()
$ErrorCounters = @{} 

# --- Function to Draw the Static Dashboard ---
function Update-Dashboard {
    param(
        $CurrentUrl,
        $CurrentCounter,
        $TotalUrls,
        $LastResultText,
        $LastResultColor,
        $Counters
    )
    
    Clear-Host
    
    # 1. Header
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "             ACCESSIBILITY TEST DASHBOARD                   " -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    
    # 2. Progress Bar (Visual approximation)
    $PercentDone = [math]::Round(($CurrentCounter / $TotalUrls) * 100, 1)
    Write-Host " Progress:  [${CurrentCounter} / ${TotalUrls}]  ${PercentDone}% Complete" -ForegroundColor White
    
    # 3. Current Activity Area
    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
    
    # Truncate URL for display
    $DisplayUrl = $CurrentUrl
    if ($DisplayUrl.Length -gt $MaxUrlDisplayLength) {
        $DisplayUrl = $DisplayUrl.Substring(0, $MaxUrlDisplayLength - 3) + "..."
    }
    
    Write-Host " Testing:   " -NoNewline
    Write-Host "$DisplayUrl" -ForegroundColor Yellow
    
    if ($LastResultText) {
        Write-Host " Status:    " -NoNewline
        Write-Host "$LastResultText" -ForegroundColor $LastResultColor
    } else {
        Write-Host " Status:    Waiting..." -ForegroundColor DarkGray
    }
    
    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray

    # 4. Live Statistics
    Write-Host " LIVE STATISTICS:" -ForegroundColor White
    
    if ($Counters.Count -gt 0) {
        foreach ($Key in $Counters.Keys) {
            $Count = $Counters[$Key]
            $Pct = [math]::Round(($Count / $CurrentCounter) * 100, 2)
            
            # Dynamic coloring for stats
            $StatColor = "White"
            if ($Key -like "HTTP_2*") { $StatColor = "Green" }
            elseif ($Key -like "NET_*") { $StatColor = "Red" }
            elseif ($Key -like "HTTP_4*" -or $Key -like "HTTP_5*") { $StatColor = "Yellow" }

            # Format:  HTTP_200:       45   (20.5%)
            Write-Host "   - ${Key}: " -NoNewline
            Write-Host "${Count}" -NoNewline -ForegroundColor $StatColor
            Write-Host "  (${Pct}%)"
        }
    } else {
        Write-Host "   (No data yet)" -ForegroundColor DarkGray
    }
    Write-Host "============================================================" -ForegroundColor Cyan
}

# --- Main Loop ---
for ($i = 0; $i -lt $TotalUrls; $i++) {
    $Url = $Urls[$i]
    $Counter = $i + 1
    
    # Initial Dashboard Draw (Before Test)
    Update-Dashboard -CurrentUrl $Url -CurrentCounter $Counter -TotalUrls $TotalUrls -LastResultText "Testing..." -LastResultColor "Gray" -Counters $ErrorCounters
    
    $Status = "FAILURE"
    $StatusCode = "N/A"
    $ResultKey = ""
    $Reason = ""
    $ResultText = ""
    $ResultColor = "White"

    try {
        # Perform Request
        $Response = Invoke-WebRequest -Uri $Url -Method Get -TimeoutSec $TimeoutSec -MaximumRedirection 5 -ErrorAction SilentlyContinue

        if ($null -ne $Response) {
            $StatusCode = [int]$Response.StatusCode
            $ResultKey = "HTTP_$StatusCode"
            
            if ($StatusCode -ge 200 -and $StatusCode -lt 400) {
                $Status = "SUCCESS"
                $Reason = "Download OK"
                $ResultText = "ACCESSIBLE (Code: ${StatusCode})"
                $ResultColor = "Green"
                
                # Save Content
                $FileName = $Url -replace 'https://|http://' -replace '[/:]','_'
                $OutputPath = Join-Path -Path $OutputDirectory -ChildPath "$($FileName).html"
                $Response.Content | Out-File -FilePath $OutputPath -Encoding UTF8
            }
            else {
                $Status = "SERVER_ERROR"
                $Reason = "Server Error"
                $ResultText = "SERVER ERROR (Code: ${StatusCode})"
                $ResultColor = "Yellow"
            }
        }
        else {
            $ResultKey = "NETWORK_NO_RESPONSE"
            $Status = "NETWORK_BLOCK"
            $Reason = "No Response"
            $ResultText = "BLOCKED/RESET (No Response)"
            $ResultColor = "Red"
        }
    }
    catch {
        $Status = "NETWORK_FAILURE"
        if ($null -ne $_.Exception.InnerException) {
            $NetworkErrorType = $_.Exception.InnerException.GetType().Name
        } else {
            $NetworkErrorType = $_.Exception.GetType().Name
        }
        $ResultKey = "NET_$NetworkErrorType"
        $Reason = $NetworkErrorType
        $ResultText = "NETWORK FAIL (${NetworkErrorType})"
        $ResultColor = "Red"
    }
    
    # Update Counters
    if ($ErrorCounters.ContainsKey($ResultKey)) {
        $ErrorCounters[$ResultKey]++
    } else {
        $ErrorCounters[$ResultKey] = 1
    }

    # Record Result
    $ResultCollection += [PSCustomObject]@{
        URL = $Url
        Status = $Status
        ResultKey = $ResultKey
        StatusCode = $StatusCode
        Reason = $Reason
    }

    # Final Dashboard Draw (After Test - Shows Result)
    Update-Dashboard -CurrentUrl $Url -CurrentCounter $Counter -TotalUrls $TotalUrls -LastResultText $ResultText -LastResultColor $ResultColor -Counters $ErrorCounters

    # Wait
    Start-Sleep -Seconds $DelaySeconds
}

# --- Final Output ---
Write-Host "`n======================================" -ForegroundColor Green
Write-Host "           TEST COMPLETED             " -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
$ResultCollection | Export-Csv -Path $LogFile -NoTypeInformation
Write-Host "Results saved to: $LogFile"