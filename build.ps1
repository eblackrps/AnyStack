<#
.SYNOPSIS
    CI/CD Build Pipeline for the AnyStack Enterprise Module Suite v1.7.6.
.DESCRIPTION
    Compiles, tests, and prepares all sub-modules for deployment.
#>
$ErrorActionPreference = 'Stop'

$Modules = Get-ChildItem -Directory -Path $PSScriptRoot | Where-Object Name -match '^(AnyStack|VCF)\.' | Select-Object -ExpandProperty Name

Write-Host "=========================================" -ForegroundColor Green
Write-Host "Starting AnyStack Enterprise Build Pipeline v1.7.6" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

foreach ($mod in $Modules) {
    Write-Host "--> Validating Module: $mod" -ForegroundColor Cyan
    
    $psd1Path = Join-Path $PSScriptRoot "$mod\$mod.psd1"
    
    if (-not (Test-Path $psd1Path)) {
        Write-Warning "Manifest missing for $mod. Skipping."
        continue
    }

    try {
        # 1. Test Module Manifest
        Test-ModuleManifest -Path $psd1Path | Out-Null
        Write-Host "    [OK] Manifest Validated" -ForegroundColor DarkGreen
        
        $testPath = Join-Path $PSScriptRoot "$mod\Tests"
        if (Test-Path $testPath) {
            Write-Host "    [RUNNING] Pester Tests for $mod..." -ForegroundColor DarkCyan
            $pesterConfig = New-PesterConfiguration
            $pesterConfig.Run.Path = $testPath
            $pesterConfig.Output.Verbosity = 'Detailed'
            $pesterConfig.Run.Exit = $true
            Invoke-Pester -Configuration $pesterConfig
        }
    }
    catch {
        Write-Error "Build failed for $mod : $($_.Exception.Message)"
        exit 1
    }
}

Write-Host "=========================================" -ForegroundColor Green
Write-Host "Build Complete. Modules are ready for distribution." -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
 








