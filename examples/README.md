# AnyStack Enterprise Examples

This folder contains end-to-end automation scripts that demonstrate how to chain AnyStack Enterprise cmdlets for common data center operations.

Each example is intended for a non-production lab first. Review the script, connect to the correct vCenter or VCF endpoint, and run the workflow with `-WhatIf` on any mutation cmdlets before executing it live.

| Script | Use Case | Recommended Schedule |
|---|---|---|
| `01-PatchTuesday-HostRemediation.ps1` | Pre-patching checks, evacuation, remediation | Monthly |
| `02-NewVM-Onboarding.ps1` | Standardizing new VM tags, tools, pool | Daily / Ad-hoc |
| `03-SecurityAudit-Weekly.ps1` | CIS STIG audit, lockdown verification | Weekly |
| `04-CapacityReview-Monthly.ps1` | Finding zombie VMs, datastore growth, right-sizing | Monthly |
| `05-DR-Readiness-Check.ps1` | Snapshot limits, HA failover checks, vSAN health | Weekly |

## How to Use the Examples

1. Install `VCF.PowerCLI` and import `AnyStack.vSphere`.
2. Authenticate once with `Connect-AnyStackServer`.
3. Review every environment-specific value in the script before running it.
4. Prefer `-WhatIf` for the first execution of any workflow that changes state.
5. Capture the report or output objects and review them before scheduling the script.

## Typical Validation Flow

```powershell
Import-Module AnyStack.vSphere
$server = Connect-AnyStackServer -Server 'vcenter.lab.local'

Invoke-AnyStackHealthCheck -Server $server
Get-AnyStackNonCompliantHost -Server $server -ClusterName 'Compute-A' -WhatIf
```
