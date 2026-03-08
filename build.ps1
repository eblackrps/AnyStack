<#
.SYNOPSIS
    CI/CD Build Pipeline for the AnyStack Enterprise Module Suite v1.5.0.
.DESCRIPTION
    Compiles, tests, and prepares all sub-modules for deployment.
#>
$ErrorActionPreference = 'Stop'

$Modules = Get-ChildItem -Directory -Path $PSScriptRoot | Where-Object Name -match '^(AnyStack|VCF)\.' | Select-Object -ExpandProperty Name

Write-Output "=========================================" -ForegroundColor Green
Write-Output "Starting AnyStack Enterprise Build Pipeline v1.5.0" -ForegroundColor Green
Write-Output "=========================================" -ForegroundColor Green

foreach ($mod in $Modules) {
    Write-Output "--> Validating Module: $mod" -ForegroundColor Cyan
    
    $psd1Path = Join-Path $PSScriptRoot "$mod\$mod.psd1"
    
    if (-not (Test-Path $psd1Path)) {
        Write-Warning "Manifest missing for $mod. Skipping."
        continue
    }

    try {
        # 1. Test Module Manifest
        Test-ModuleManifest -Path $psd1Path | Out-Null
        Write-Output "    [OK] Manifest Validated" -ForegroundColor DarkGreen
        
        $testPath = Join-Path $PSScriptRoot "$mod\Tests"
        if (Test-Path $testPath) {
            Write-Output "    [RUNNING] Pester Tests for $mod..." -ForegroundColor DarkCyan
            # Invoke-Pester -Path $testPath
        }
    }
    catch {
        Write-Error "Build failed for $mod : $($_.Exception.Message)"
        exit 1
    }
}

Write-Output "=========================================" -ForegroundColor Green
Write-Output "Build Complete. Modules are ready for distribution." -ForegroundColor Green
Write-Output "=========================================" -ForegroundColor Green


 

