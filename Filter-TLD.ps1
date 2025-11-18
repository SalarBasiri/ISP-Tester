# --- TLD Filter and Extractor Script (Revised with explicit counter) ---

# Configuration
$InputFile = "million_urls.txt"  # Your file containing 1 million websites
$OutputFile = "urls2.txt"        # The file to store the extracted TLDs
$TargetTLD = ".ir"               # *** EDIT THIS: Change to the TLD you want to extract (e.g., ".com", ".ir", ".org") ***

# --- Script Logic ---

Write-Host "--- Starting TLD Extraction ---"
Write-Host "Input File: $InputFile"
Write-Host "Output File: $OutputFile"
Write-Host "Target TLD: $TargetTLD"
Write-Host "-------------------------------"

try {
    # 1. Read all content into an array. 
    # For very large files, this might use significant memory, but it allows for indexed iteration.
    $Urls = Get-Content -Path $InputFile -ReadCount 0

    $TotalUrls = $Urls.Count
    Write-Host "Total URLs loaded: $TotalUrls"
    
    # Array to hold matching URLs found inside the loop
    $FilteredUrls = @()
    $TargetTLDLower = $TargetTLD.ToLower()
    
    # 2. Loop through the URLs using an explicit counter (the requested structure)
    for ($i = 0; $i -lt $TotalUrls; $i++) {
        $UrlLine = $Urls[$i]
        $Counter = $i + 1
        
        # Display progress
        Write-Host "[$Counter/$TotalUrls] Checking: $UrlLine" -NoNewline
        
        $Url = $UrlLine.ToLower().Trim()
        
        # Simple check for TLD at the end of the string (case-insensitive)
        # We replace leading http(s):// to simplify the TLD match check at the end of the string.
        $CleanUrl = $Url -replace "^https?://", ""
        
        # Check if the URL ends exactly with the TLD, or if it is followed by a slash (e.g., .ir or .ir/)
        if ($CleanUrl.EndsWith($TargetTLDLower) -or $CleanUrl.EndsWith("$($TargetTLDLower)/")) {
            # Add the original URL line (preserving original case and formatting)
            $FilteredUrls += $UrlLine 
            Write-Host " --> MATCH" -ForegroundColor Green
        } else {
            Write-Host " --> SKIP"
        }
    }

    # 3. Save the results to the output file
    $FilteredUrls | Out-File -FilePath $OutputFile -Encoding UTF8 -Force
    
    $FilteredCount = $FilteredUrls.Count
    Write-Host "-------------------------------"
    Write-Host "Successfully extracted $FilteredCount URLs with TLD '$TargetTLD'." -ForegroundColor Green
    Write-Host "Results saved to: $OutputFile"
    
}
catch {
    Write-Host "An error occurred during file processing:" -ForegroundColor Red
    Write-Host $_.Exception.Message
}

Write-Host "--- TLD Extraction Complete ---"