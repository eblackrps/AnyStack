## AnyStack v1.1.0 — Full Production Release

### What's New
- **113+ production cmdlets** — all stubs fully implemented.
- **28 modules** including new `AnyStack` meta-module for single-command install.
- **VCF.StorageAdvanced** expanded with NVMe management cmdlets.
- **Single install command:** `Install-Module AnyStack -Scope CurrentUser`

### Breaking Changes
The following cmdlets in `VCF.DRValidator` were renamed for consistency:
| Old Name | New Name |
|----------|----------|
| Export-DRReadinessReport | Export-AnyStackDRReadinessReport |
| Test-DisasterRecoveryReadiness | Test-AnyStackDisasterRecoveryReadiness |
| Repair-DisasterRecoveryReadiness | Repair-AnyStackDisasterRecoveryReadiness |

### Requirements
- PowerShell 7.2+
- VMware.PowerCLI 13.0+
- VMware vSphere 8.0 U3 / VCF 5.1 or 5.2

### Installation
`Install-Module AnyStack -Scope CurrentUser`