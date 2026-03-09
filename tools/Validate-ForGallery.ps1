<#
.SYNOPSIS
    Validates all AnyStack modules prior to PSGallery publication.
#>

$Modules = Get-ChildItem -Directory -Path "$PSScriptRoot\.." | Where-Object Name -match '^(AnyStack|VCF)'
$failed = $false

Write-Host "========================================"
Write-Host "Starting Pre-Publish Gallery Validation"
Write-Host "========================================"

foreach ($mod in $Modules) {
    Write-Host "`nValidating $($mod.Name)..." -ForegroundColor Cyan
    $psd1 = Join-Path $mod.FullName "$($mod.Name).psd1"

    if (-not (Test-Path $psd1)) {
        Write-Error "Missing manifest for $($mod.Name)"
        $failed = $true
        continue
    }

    # 1. Test-ModuleManifest
    $test = Test-ModuleManifest -Path $psd1 -ErrorAction SilentlyContinue
    if (-not $test) {
        Write-Error "Test-ModuleManifest failed."
        $failed = $true
    } else {
        Write-Host "  [OK] Test-ModuleManifest passed." -ForegroundColor Green
    }

    # 2. Check FunctionsToExport
    $manifestContent = Get-Content $psd1 -Raw
    if ($manifestContent -match "FunctionsToExport\s*=\s*'\*'") {
        Write-Error "FunctionsToExport uses wildcard '*'. Needs explicit array."
        $failed = $true
    } else {
        Write-Host "  [OK] FunctionsToExport is explicit." -ForegroundColor Green
    }

    # 3. Check metadata
    $missingMeta = $false
    if ($manifestContent -notmatch "ModuleVersion\s*=\s*'1\.7\.1'") { $missingMeta = $true; Write-Error "ModuleVersion not 1.7.1" }
    if ($manifestContent -notmatch "Author\s*=\s*'The AnyStack Architect'") { $missingMeta = $true; Write-Error "Author incorrect" }
    if ($manifestContent -notmatch "Tags\s*=\s*@\(") { $missingMeta = $true; Write-Error "Tags missing" }
    if ($manifestContent -notmatch "ProjectUri") { $missingMeta = $true; Write-Error "ProjectUri missing" }
    if ($manifestContent -notmatch "LicenseUri") { $missingMeta = $true; Write-Error "LicenseUri missing" }

    if ($missingMeta) {
        $failed = $true
    } else {
        Write-Host "  [OK] Metadata fields populated." -ForegroundColor Green
    }

    # 4. Check for NotImplementedException
    $codeFiles = Get-ChildItem -Path $mod.FullName -Recurse -Include *.psm1, *.ps1 -File
    $stubs = $codeFiles | Select-String "NotImplementedException"
    if ($stubs) {
        Write-Error "Found NotImplementedException in source files."
        $failed = $true
    } else {
        Write-Host "  [OK] No NotImplementedException stubs found." -ForegroundColor Green
    }

    # 5. Invoke-ScriptAnalyzer
    $sa = Invoke-ScriptAnalyzer -Path $mod.FullName -Recurse -Severity Error -ErrorAction SilentlyContinue
    if ($sa) {
        Write-Error "PSScriptAnalyzer found $($sa.Count) issues."
        $sa | ForEach-Object { Write-Error "  - $($_.RuleName): $($_.Message)" }
        $failed = $true
    } else {
        Write-Host "  [OK] PSScriptAnalyzer passed with 0 warnings/errors." -ForegroundColor Green
    }
}

Write-Host "========================================"
if ($failed) {
    Write-Error "Validation FAILED. Please fix the above issues."
    exit 1
} else {
    Write-Host "Validation PASSED. All 28 modules are ready for publication." -ForegroundColor Green
    exit 0
}
 














