param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^\d+\.\d+\.\d+$')]
    [string]$Version,

    [switch]$SkipValidation
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$metaManifestPath = Join-Path $repoRoot 'AnyStack\AnyStack.psd1'

if (-not (Test-Path $metaManifestPath)) {
    throw "Could not find the AnyStack meta-module manifest at $metaManifestPath."
}

$manifest = Import-PowerShellDataFile -Path $metaManifestPath
$currentVersion = [string]$manifest.ModuleVersion

Write-Host "Current version: $currentVersion" -ForegroundColor Cyan
Write-Host "Target version : $Version" -ForegroundColor Cyan

$versionPatterns = @(
    @{
        Name        = 'semantic version'
        Pattern     = [regex]::Escape($currentVersion)
        Replacement = $Version
    },
    @{
        Name        = 'prefixed version'
        Pattern     = [regex]::Escape("v$currentVersion")
        Replacement = "v$Version"
    }
)

$targetFiles = Get-ChildItem -Path $repoRoot -Recurse -File | Where-Object {
    $_.FullName -notmatch '[\\\/]\.git[\\\/]' -and
    $_.Extension -in '.ps1', '.psd1', '.psm1', '.md', '.yml', '.yaml', '.txt'
}

$updatedFiles = New-Object System.Collections.Generic.List[string]

foreach ($file in $targetFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    $updatedContent = $content

    foreach ($pattern in $versionPatterns) {
        $updatedContent = $updatedContent -replace $pattern.Pattern, $pattern.Replacement
    }

    if ($updatedContent -ne $content) {
        Set-Content -Path $file.FullName -Value $updatedContent -Encoding UTF8
        $updatedFiles.Add($file.FullName)
        Write-Host "Updated $($file.FullName)" -ForegroundColor Yellow
    }
}

if (-not $SkipValidation) {
    Write-Host 'Running repository validation...' -ForegroundColor Yellow
    & (Join-Path $repoRoot 'test-syntax.ps1')
    & (Join-Path $PSScriptRoot 'Validate-ForGallery.ps1') -ExpectedVersion $Version
}

if ($updatedFiles.Count -eq 0) {
    Write-Host 'No files needed version updates.' -ForegroundColor Green
} else {
    Write-Host "Updated $($updatedFiles.Count) files." -ForegroundColor Green
}
