param([string]$ApiKey)

if (-not $ApiKey) {
    Write-Error "Please provide your API Key. Example: .\FixAndPublish.ps1 -ApiKey 'your-key-here'"
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

# Part 2: Publish everything to the Gallery
foreach ($mod in $Modules) {
    Write-Host ">>> Uploading $($mod.Name) to the PowerShell Gallery..." -ForegroundColor Cyan
    Publish-Module -Path $mod.FullName -NuGetApiKey $ApiKey -Verbose -Force
}
