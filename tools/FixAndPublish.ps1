$ApiKey = $env:PSGALLERY_API_KEY

if (-not $ApiKey) {
    Write-Error "Please set the PSGALLERY_API_KEY environment variable."
    return
}

# Part 1: Fix the Serial Numbers (GUIDs)
$Modules = Get-ChildItem -Directory | Where-Object Name -match '^(AnyStack|VCF)\.'
foreach ($mod in $Modules) {
    $psd1 = Join-Path $mod.FullName "$($mod.Name).psd1"
    if (Test-Path $psd1) {
        $text = Get-Content $psd1 -Raw
        if ($text -notmatch 'GUID\s*=') {
            $guid = [guid]::NewGuid().ToString()
            # Add the GUID after the ModuleVersion line
            $text = $text -replace "ModuleVersion\s*=\s*'.*?'", "`$0`n    GUID = '$guid'"
            Set-Content $psd1 $text
            Write-Host "Added Serial Number to $($mod.Name)" -ForegroundColor Green
        }
    }
}

# Part 2: Validate and Publish everything to the Gallery
foreach ($mod in $Modules) {
    Write-Host ">>> Validating $($mod.Name)..." -ForegroundColor Cyan
    $manifestPath = Join-Path $mod.FullName "$($mod.Name).psd1"

    # Run manifest test
    $manifestTest = Test-ModuleManifest -Path $manifestPath -ErrorAction SilentlyContinue
    if (-not $manifestTest) {
        Write-Error "Module manifest validation failed for $($mod.Name). Skipping publish."
        continue
    }

    # Run Pester tests if they exist
    $testFolder = Join-Path $mod.FullName "Tests"
    if (Test-Path $testFolder) {
        $pesterResult = Invoke-Pester -Path $testFolder -PassThru -ErrorAction SilentlyContinue
        if ($pesterResult.FailedCount -gt 0) {
            Write-Error "Pester tests failed for $($mod.Name). Skipping publish."
            continue
        }
    }

    Write-Host ">>> Uploading $($mod.Name) to the PowerShell Gallery..." -ForegroundColor Cyan
    Publish-Module -Path $mod.FullName -NuGetApiKey $ApiKey -Verbose -Force
}
