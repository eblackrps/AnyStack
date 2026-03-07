<#
.SYNOPSIS
    Installs the AnyStack Enterprise Module Suite into your local PowerShell environment.
#>
[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$Global
)

$ErrorActionPreference = 'Stop'

Write-Host "Checking for VMware.PowerCLI dependency..." -ForegroundColor Cyan
if (-not (Get-Module -ListAvailable VMware.PowerCLI)) {
    Write-Warning "VMware.PowerCLI is required but not installed."
    $response = Read-Host "Would you like to install it now from the PSGallery? (Y/N)"
    if ($response -eq 'Y') {
        Write-Host "Installing VMware.PowerCLI..." -ForegroundColor Cyan
        Install-Module -Name VMware.PowerCLI -AllowClobber -Scope CurrentUser -Force
    } else {
        Write-Error "Cannot continue without VMware.PowerCLI."
    }
} else {
    Write-Host "  [OK] VMware.PowerCLI found." -ForegroundColor DarkGreen
}

Write-Host "=========================================" -ForegroundColor Green
Write-Host "Installing AnyStack Enterprise Suite" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

$Modules = Get-ChildItem -Directory -Path $PSScriptRoot | Where-Object Name -match '^(AnyStack|VCF)\.' | Select-Object -ExpandProperty Name

$targetPathBase = if ($Global) { 
    Join-Path $env:ProgramFiles "WindowsPowerShell\Modules" 
} else { 
    Join-Path (Split-Path $profile -Parent) "Modules" 
}

if (-not (Test-Path $targetPathBase)) {
    New-Item -ItemType Directory -Path $targetPathBase -Force | Out-Null
}

foreach ($mod in $Modules) {
    $targetPath = Join-Path $targetPathBase $mod
    if (Test-Path $targetPath) {
        if ($Force) {
            Remove-Item -Path $targetPath -Recurse -Force
            Write-Host "Overwriting existing $mod..." -ForegroundColor Yellow
        } else {
            Write-Warning "Module $mod already exists. Use -Force to overwrite."
            continue
        }
    }
    Copy-Item -Path (Join-Path $PSScriptRoot $mod) -Destination $targetPathBase -Recurse -Force
    Write-Host "  [OK] Installed $mod" -ForegroundColor DarkCyan
}

Write-Host "=========================================" -ForegroundColor Green
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "Run 'Import-Module AnyStack.vSphere' to begin." -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
