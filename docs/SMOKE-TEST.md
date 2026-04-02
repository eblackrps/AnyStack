# AnyStack Live Smoke Test

Run the smoke test against a non-production vCenter or VCF lab after `.\test-syntax.ps1`, `.\build.ps1`, and `.\tools\Validate-ForGallery.ps1` have already passed.

## Scripted Path
```powershell
.\tools\Invoke-SmokeTest.ps1 -Server 'vcenter.lab.local' -Credential (Get-Credential) -ClusterName 'Lab-Cluster'
```

The smoke runner verifies:

- connection establishment through `Connect-AnyStackServer`
- the resolved-connection path in `Get-AnyStackLicenseUsage`
- safe read-only inventory and appliance queries
- `-WhatIf` behavior on snapshot-oriented mutation cmdlets

## Manual Verification Checklist

If you need to step through it manually, run:

```powershell
Import-Module AnyStack -Force
$server = Connect-AnyStackServer -Server 'vcenter.lab.local' -Credential (Get-Credential)

Get-AnyStackLicenseUsage
Get-AnyStackVcenterServices
Get-AnyStackActiveAlarm

Clear-AnyStackOrphanedSnapshots -ClusterName 'Lab-Cluster' -WhatIf
Optimize-AnyStackSnapshots -ClusterName 'Lab-Cluster' -WhatIf

Disconnect-AnyStackServer -Server $server -Confirm:$false
```

## Release Gate

Do not publish from `.\tools\FixAndPublish.ps1` until the live smoke test has passed, unless you intentionally provide `-SkipLiveSmokeTest` and accept the release risk.
 
