param(
    [Parameter(Mandatory = $true)]
    [string]$NuGetApiKey
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$modules = Get-ChildItem -Directory -Path $repoRoot | Where-Object {
    $_.Name -eq 'AnyStack' -or $_.Name -match '^(AnyStack|VCF)\.'
} | Sort-Object @{ Expression = { if ($_.Name -eq 'AnyStack') { 1 } else { 0 } } }, Name

& (Join-Path $repoRoot 'test-syntax.ps1')
& (Join-Path $repoRoot 'build.ps1')
& (Join-Path $PSScriptRoot 'Validate-ForGallery.ps1')

foreach ($module in $modules) {
    Write-Host "Publishing $($module.Name)..." -ForegroundColor Cyan
    Publish-Module -Path $module.FullName -NuGetApiKey $NuGetApiKey -Verbose -Force
}
