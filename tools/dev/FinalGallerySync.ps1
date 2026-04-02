param([string]$ApiKey)

if (-not $ApiKey) {
    Write-Error "Please provide your API Key. Example: .\FinalGallerySync.ps1 -ApiKey 'your-key-here'"
    return
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$currentVersion = [string](Import-PowerShellDataFile -Path (Join-Path $repoRoot 'AnyStack\AnyStack.psd1')).ModuleVersion
$GitHubUrl = "https://github.com/eblackrps/AnyStack"
$LicenseUrl = "https://github.com/eblackrps/AnyStack/blob/main/LICENSE"

$Modules = Get-ChildItem -Directory | Where-Object Name -match '^(AnyStack|VCF)\.'

foreach ($mod in $Modules) {
    $psd1Path = Join-Path $mod.FullName "$($mod.Name).psd1"
    if (Test-Path $psd1Path) {
        Write-Output "Updating metadata for $($mod.Name)..." -ForegroundColor Cyan
        $content = Get-Content $psd1Path -Raw
        
        # 1. Align the module version with the suite manifest
        $content = $content -replace "ModuleVersion\s*=\s*'.*?'", "ModuleVersion = '$currentVersion'"
        
        # 2. Update ProjectUri
        $content = $content -replace "ProjectUri\s*=\s*'.*?'", "ProjectUri = '$GitHubUrl'"
        
        # 3. Add LicenseUri if it doesn't exist in PSData
        if ($content -notmatch "LicenseUri") {
            $content = $content -replace "(ProjectUri\s*=\s*'.*?')", "`$1`n            LicenseUri = '$LicenseUrl'"
        }

        Set-Content -Path $psd1Path -Value $content
    }
}

Write-Output "Metadata update complete. Starting Gallery push..." -ForegroundColor Green

foreach ($mod in $Modules) {
    Write-Output ">>> Uploading $($mod.Name) v$currentVersion..." -ForegroundColor Cyan
    Publish-Module -Path $mod.FullName -NuGetApiKey $ApiKey -Verbose -Force
}

Write-Output "Final Gallery Sync Complete! Your modules now point to your GitHub repository." -ForegroundColor Green


 
