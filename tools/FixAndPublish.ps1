param(
    [Parameter(Mandatory = $true)]
    [string]$NuGetApiKey,

    [string]$SmokeTestServer,

    [System.Management.Automation.PSCredential]$SmokeTestCredential,

    [string]$SmokeTestClusterName,

    [switch]$SkipLiveSmokeTest
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$modules = Get-ChildItem -Directory -Path $repoRoot | Where-Object {
    $_.Name -eq 'AnyStack' -or $_.Name -match '^(AnyStack|VCF)\.'
} | Sort-Object @{ Expression = { if ($_.Name -eq 'AnyStack') { 1 } else { 0 } } }, Name

& (Join-Path $repoRoot 'test-syntax.ps1')
& (Join-Path $repoRoot 'build.ps1')
& (Join-Path $PSScriptRoot 'Validate-ForGallery.ps1')

if ($SkipLiveSmokeTest) {
    Write-Warning 'Skipping live smoke test. Use this only when a lab environment is unavailable and the release risk is understood.'
}
else {
    if (-not $SmokeTestServer) {
        throw 'SmokeTestServer is required unless -SkipLiveSmokeTest is specified.'
    }

    if (-not $SmokeTestCredential) {
        throw 'SmokeTestCredential is required unless -SkipLiveSmokeTest is specified.'
    }

    if (-not $SmokeTestClusterName) {
        throw 'SmokeTestClusterName is required unless -SkipLiveSmokeTest is specified.'
    }

    & (Join-Path $PSScriptRoot 'Invoke-SmokeTest.ps1') `
        -Server $SmokeTestServer `
        -Credential $SmokeTestCredential `
        -ClusterName $SmokeTestClusterName
}

foreach ($module in $modules) {
    Write-Host "Publishing $($module.Name)..." -ForegroundColor Cyan
    Publish-Module -Path $module.FullName -NuGetApiKey $NuGetApiKey -Verbose -Force
}
