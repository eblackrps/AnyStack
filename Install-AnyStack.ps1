<#
.SYNOPSIS
    Installs the AnyStack Enterprise Module Suite v1.7.1 into your local PowerShell environment.
#>
[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$Global
)

$ErrorActionPreference = 'Stop'

if ($Global) {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        throw 'The -Global flag requires an elevated PowerShell session. Please restart PowerShell as Administrator and try again.'
    }
}

Write-Host "Checking for VCF.PowerCLI dependency..." -ForegroundColor Cyan
if (-not (Get-Module -ListAvailable VCF.PowerCLI)) {
    Write-Warning "VCF.PowerCLI is required but not installed."
    $response = Read-Host "Would you like to install it now from the PSGallery? (Y/N)"
    if ($response -eq 'Y') {
        Write-Host "Installing VCF.PowerCLI..." -ForegroundColor Cyan
        Install-Module -Name VCF.PowerCLI -AllowClobber -Scope CurrentUser -Force
    } else {
        Write-Error "Cannot continue without VCF.PowerCLI."
    }
} else {
    Write-Host "  [OK] VCF.PowerCLI found." -ForegroundColor DarkGreen
}

Write-Host "=========================================" -ForegroundColor Green
Write-Host "Installing AnyStack Enterprise Suite v1.7.1" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

$Modules = Get-ChildItem -Directory -Path $PSScriptRoot | Where-Object Name -match '^(AnyStack|VCF)\.' | Select-Object -ExpandProperty Name

$targetPathBase = if ($Global) {
    Join-Path $env:ProgramFiles "PowerShell\Modules"
} else {
    Join-Path ([Environment]::GetFolderPath('MyDocuments')) "PowerShell\Modules"
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
    Write-Host "  [OK] Installed $mod v1.7.1" -ForegroundColor DarkCyan
}

Write-Host "=========================================" -ForegroundColor Green
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "Run 'Import-Module AnyStack.vSphere' to begin." -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
 












