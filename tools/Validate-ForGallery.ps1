[CmdletBinding()]
param(
    [string]$ExpectedVersion
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$metaManifestPath = Join-Path $repoRoot 'AnyStack\AnyStack.psd1'
$env:PSModulePath = "$repoRoot$([System.IO.Path]::PathSeparator)$env:PSModulePath"

if (-not (Test-Path $metaManifestPath)) {
    throw "Could not find the AnyStack meta-module manifest at $metaManifestPath."
}

if (-not $ExpectedVersion) {
    $ExpectedVersion = [string](Import-PowerShellDataFile -Path $metaManifestPath).ModuleVersion
}

$modules = Get-ChildItem -Directory -Path $repoRoot | Where-Object {
    $_.Name -eq 'AnyStack' -or $_.Name -match '^(AnyStack|VCF)\.'
} | Sort-Object Name

try {
    Import-Module PSScriptAnalyzer -MinimumVersion 1.21.0 -ErrorAction Stop
}
catch {
    throw 'PSScriptAnalyzer is required for gallery validation. Install it with Install-Module PSScriptAnalyzer -Scope CurrentUser.'
}

$settingsPath = Join-Path $repoRoot 'PSScriptAnalyzerSettings.psd1'
$failed = $false

Write-Host '========================================' -ForegroundColor Cyan
Write-Host 'Starting Pre-Publish Gallery Validation' -ForegroundColor Cyan
Write-Host "Expected version: $ExpectedVersion" -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan

foreach ($module in $modules) {
    Write-Host "`nValidating $($module.Name)..." -ForegroundColor Cyan

    $manifestPath = Join-Path $module.FullName "$($module.Name).psd1"
    if (-not (Test-Path $manifestPath)) {
        Write-Error "Missing manifest for $($module.Name)."
        $failed = $true
        continue
    }

    try {
        $manifest = Import-PowerShellDataFile -Path $manifestPath
        Test-ModuleManifest -Path $manifestPath | Out-Null
        Write-Host '  [OK] Test-ModuleManifest passed.' -ForegroundColor Green
    }
    catch {
        Write-Error "Test-ModuleManifest failed for $($module.Name): $($_.Exception.Message)"
        $failed = $true
        continue
    }

    $metadataIssues = New-Object System.Collections.Generic.List[string]

    if ([string]$manifest.ModuleVersion -ne $ExpectedVersion) {
        $metadataIssues.Add("ModuleVersion '$($manifest.ModuleVersion)' does not match expected version '$ExpectedVersion'.")
    }

    if ([string]::IsNullOrWhiteSpace([string]$manifest.Author)) {
        $metadataIssues.Add('Author is missing.')
    }

    $psData = $manifest.PrivateData.PSData

    if (-not $psData.Tags -or $psData.Tags.Count -eq 0) {
        $metadataIssues.Add('Tags are missing.')
    }

    if ([string]::IsNullOrWhiteSpace([string]$psData.ProjectUri)) {
        $metadataIssues.Add('ProjectUri is missing.')
    }

    if ([string]::IsNullOrWhiteSpace([string]$psData.LicenseUri)) {
        $metadataIssues.Add('LicenseUri is missing.')
    }

    if ([string]::IsNullOrWhiteSpace([string]$manifest.Description)) {
        $metadataIssues.Add('Description is missing.')
    }

    $functionsToExport = @($manifest.FunctionsToExport)
    if ($functionsToExport.Count -eq 1 -and $functionsToExport[0] -eq '*') {
        $metadataIssues.Add("FunctionsToExport uses wildcard '*'.")
    }

    if ($metadataIssues.Count -gt 0) {
        foreach ($issue in $metadataIssues) {
            Write-Error "  $issue"
        }
        $failed = $true
    } else {
        Write-Host '  [OK] Metadata fields are populated and version-aligned.' -ForegroundColor Green
    }

    $codeFiles = Get-ChildItem -Path $module.FullName -Recurse -File | Where-Object {
        $_.Extension -in '.ps1', '.psm1'
    }

    $stubs = Select-String -Path $codeFiles.FullName -Pattern 'NotImplementedException' -SimpleMatch -ErrorAction SilentlyContinue
    if ($stubs) {
        Write-Error '  Found NotImplementedException in source files.'
        $failed = $true
    } else {
        Write-Host '  [OK] No NotImplementedException stubs found.' -ForegroundColor Green
    }

    $analysisResults = Invoke-ScriptAnalyzer -Path $module.FullName -Recurse -Settings $settingsPath -Severity Error -ErrorAction Stop
    if ($analysisResults) {
        Write-Error "  PSScriptAnalyzer found $($analysisResults.Count) issues."
        foreach ($result in $analysisResults) {
            Write-Error "  - [$($result.RuleName)] $($result.ScriptName):$($result.Line) $($result.Message)"
        }
        $failed = $true
    } else {
        Write-Host '  [OK] PSScriptAnalyzer passed with 0 issues.' -ForegroundColor Green
    }
}

Write-Host '========================================' -ForegroundColor Cyan
if ($failed) {
    Write-Error 'Validation FAILED. Resolve the issues above before publishing.'
    exit 1
}

Write-Host "Validation PASSED. All $($modules.Count) modules are ready for publication." -ForegroundColor Green
exit 0
