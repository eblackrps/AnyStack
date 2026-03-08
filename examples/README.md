# AnyStack Enterprise Examples

This folder contains end-to-end automation scripts that demonstrate how to chain AnyStack Enterprise cmdlets for common data center operations.

| Script | Use Case | Recommended Schedule |
|---|---|---|
| `01-PatchTuesday-HostRemediation.ps1` | Pre-patching checks, evacuation, remediation | Monthly |
| `02-NewVM-Onboarding.ps1` | Standardizing new VM tags, tools, pool | Daily / Ad-hoc |
| `03-SecurityAudit-Weekly.ps1` | CIS STIG audit, lockdown verification | Weekly |
| `04-CapacityReview-Monthly.ps1` | Finding zombie VMs, datastore growth, right-sizing | Monthly |
| `05-DR-Readiness-Check.ps1` | Snapshot limits, HA failover checks, vSAN health | Weekly |
