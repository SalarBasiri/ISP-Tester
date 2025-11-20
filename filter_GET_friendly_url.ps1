# --- Configuration ---
if ($args.Count -gt 0) { $InputFile = $args[0] } else { $InputFile = "urls.txt" }
$OutputFile = "urls_normal.txt"
$TargetValidCount = 1000  # *** NEW: Stop after finding this many valid URLs ***
$TimeoutSec = 10
$DelaySeconds = 0.1 

# --- Setup ---
if (-not (Test-Path -Path $InputFile)) {
    Write-Host "ERROR: Input file '$InputFile' not found." -ForegroundColor Red
    exit 1
}

# Clear/Create output file
"" | Out-File -FilePath $OutputFile -Encoding UTF8 -Force

Write-Host "Reading input file... (This may take a moment for large lists)" -ForegroundColor Yellow
$Urls = Get-Content -Path $InputFile | Where-Object { $_ -ne "" }
$TotalUrls = $Urls.Count
$FoundCount = 0

# --- Dashboard Function ---
function Update-FilterDashboard {
    param($Current, $Total, $Found, $Target, $Url, $StatusColor)
    Clear-Host
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "          DATASET MINING (FINDING 'NORMAL' SITES)           " -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    
    # Calculate progress towards the TARGET (1000), not the end of the file
    $PercentDone = [math]::Round(($Found / $Target) * 100, 1)
    
    Write-Host " Progress (File):   [$Current / $Total] scanned"
    Write-Host " TARGET PROGRESS:   [$Found / $Target] Valid URLs found ($PercentDone%)" -ForegroundColor Yellow
    Write-Host "------------------------------------------------------------" -ForegroundColor Gray
    Write-Host " Checking:      $Url"
    Write-Host " Last Result:   " -NoNewline
    if ($StatusColor -eq "Green") { Write-Host "KEPT (HTTP 200)" -ForegroundColor Green }
    else { Write-Host "DISCARDED (Not Browser-Accessible)" -ForegroundColor Red }
    Write-Host "------------------------------------------------------------" -ForegroundColor Gray
    Write-Host " Saving valid URLs to: $OutputFile"
    Write-Host "============================================================" -ForegroundColor Cyan
}

# --- Main Loop ---
for ($i = 0; $i -lt $TotalUrls; $i++) {
    $Url = $Urls[$i]
    $Counter = $i + 1
    $Keep = $false
    
    try {
        # We use GET to ensure it's truly browsable
        $Response = Invoke-WebRequest -Uri $Url -Method Get -TimeoutSec $TimeoutSec -MaximumRedirection 5 -ErrorAction SilentlyContinue
        
        if ($null -ne $Response -and [int]$Response.StatusCode -eq 200) {
            $Keep = $true
            $FoundCount++
            # Append immediately to file so we don't lose data
            $Url | Out-File -FilePath $OutputFile -Append -Encoding UTF8
        }
    }
    catch {
        $Keep = $false
    }

    # Update UI
    $Color = if ($Keep) { "Green" } else { "Red" }
    Update-FilterDashboard -Current $Counter -Total $TotalUrls -Found $FoundCount -Target $TargetValidCount -Url $Url -StatusColor $Color
    
    # *** STOP CONDITION ***
    if ($FoundCount -ge $TargetValidCount) {
        Clear-Host
        Write-Host "`n============================================================" -ForegroundColor Green
        Write-Host "               TARGET REACHED SUCCESSFULLY!                 " -ForegroundColor Green
        Write-Host "============================================================" -ForegroundColor Green
        Write-Host " Scanned: $Counter URLs"
        Write-Host " Found:   $FoundCount Valid 'Browser-Friendly' URLs"
        Write-Host " Saved:   $OutputFile"
        Write-Host "============================================================" -ForegroundColor Green
        break
    }
    
    Start-Sleep -Seconds $DelaySeconds
}

if ($FoundCount -lt $TargetValidCount) {
    Write-Host "`nEnd of file reached. Found $FoundCount valid URLs (Target was $TargetValidCount)." -ForegroundColor Yellow
}