[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Server,

    [Parameter(Mandatory = $true)]
    [System.Management.Automation.PSCredential]$Credential,

    [string]$ClusterName
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$env:PSModulePath = "$repoRoot$([System.IO.Path]::PathSeparator)$env:PSModulePath"

Import-Module AnyStack -Force -ErrorAction Stop

$readOnlyChecks = @(
    @{
        Name = 'Get-AnyStackLicenseUsage'
        ScriptBlock = { Get-AnyStackLicenseUsage }
    }
    @{
        Name = 'Get-AnyStackVcenterServices'
        ScriptBlock = { Get-AnyStackVcenterServices }
    }
    @{
        Name = 'Get-AnyStackActiveAlarm'
        ScriptBlock = { Get-AnyStackActiveAlarm }
    }
)

$whatIfChecks = @(
    @{
        Name = 'Clear-AnyStackOrphanedSnapshots'
        ScriptBlock = {
            if ($ClusterName) {
                Clear-AnyStackOrphanedSnapshots -ClusterName $ClusterName -WhatIf
            }
            else {
                Clear-AnyStackOrphanedSnapshots -WhatIf
            }
        }
    }
    @{
        Name = 'Optimize-AnyStackSnapshots'
        ScriptBlock = {
            if (-not $ClusterName) {
                throw 'ClusterName is required to run the Optimize-AnyStackSnapshots -WhatIf smoke check.'
            }

            Optimize-AnyStackSnapshots -ClusterName $ClusterName -WhatIf
        }
    }
)

Write-Host '========================================' -ForegroundColor Cyan
Write-Host 'Starting AnyStack Live Smoke Test' -ForegroundColor Cyan
Write-Host "Target server: $Server" -ForegroundColor Cyan
if ($ClusterName) {
    Write-Host "Target cluster: $ClusterName" -ForegroundColor Cyan
}
Write-Host '========================================' -ForegroundColor Cyan

$results = New-Object System.Collections.Generic.List[psobject]
$vi = $null

try {
    $vi = Connect-AnyStackServer -Server $Server -Credential $Credential
    Write-Host "Connected to $($vi.Name)." -ForegroundColor Green

    foreach ($check in $readOnlyChecks) {
        Write-Host "Running read-only check: $($check.Name)" -ForegroundColor Cyan
        & $check.ScriptBlock | Out-Null
        $results.Add([pscustomobject]@{
            Phase  = 'ReadOnly'
            Check  = $check.Name
            Result = 'Passed'
        })
    }

    foreach ($check in $whatIfChecks) {
        Write-Host "Running WhatIf check: $($check.Name)" -ForegroundColor Cyan
        & $check.ScriptBlock | Out-Null
        $results.Add([pscustomobject]@{
            Phase  = 'WhatIf'
            Check  = $check.Name
            Result = 'Passed'
        })
    }
}
catch {
    $message = $_.Exception.Message
    Write-Error "Smoke test failed: $message"
    throw
}
finally {
    if ($vi) {
        Disconnect-AnyStackServer -Server $vi -Confirm:$false | Out-Null
    }
}

Write-Host '========================================' -ForegroundColor Cyan
Write-Host 'Smoke Test Passed' -ForegroundColor Green
Write-Host '========================================' -ForegroundColor Cyan
$results
