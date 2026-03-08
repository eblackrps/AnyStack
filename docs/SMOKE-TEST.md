# AnyStack Post-Publish Smoke Test

Run these steps on a clean machine that has never had AnyStack installed.

## Step 1 — Fresh Install
```powershell
Install-Module AnyStack -Scope CurrentUser
Import-Module AnyStack
```

## Step 2 — Verify Module Count
```powershell
$modules = Get-Module -Name AnyStack* | Measure-Object
Write-Host "Modules loaded: $($modules.Count) (expected: 28)"

$cmdlets = Get-Command -Module (Get-Module AnyStack*) | Measure-Object
Write-Host "Cmdlets available: $($cmdlets.Count) (expected: 117)"
```

## Step 3 — Connect and Run Read-Only Cmdlets
```powershell
Connect-AnyStackServer -Server 'your-vcenter.domain.local'

# Safe read-only tests against a real environment
Get-AnyStackVcenterServices
Get-AnyStackActiveAlarm
Get-AnyStackUntaggedVm
Get-AnyStackEsxiLockdownMode
Test-AnyStackCertificates
Test-AnyStackSecurityBaseline
Get-AnyStackVsanHealth

Disconnect-AnyStackServer
```

## Step 4 — Verify WhatIf Works on Destructive Cmdlets
These must produce NO changes — only `-WhatIf` output:
```powershell
Clear-AnyStackOrphanedSnapshots -WhatIf
Remove-AnyStackOrphanedVmdk -WhatIf
Invoke-AnyStackDatastoreUnmount -WhatIf
Start-AnyStackHostEvacuation -WhatIf
Repair-AnyStackComplianceDrift -WhatIf
```

## Step 5 — Warning Verification
Confirm that the "Destructive Operations" warning is present in the `README.md` before executing any of the above without `-WhatIf`.
