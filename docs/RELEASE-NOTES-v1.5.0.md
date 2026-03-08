## AnyStack v1.5.0 â€” Full Enterprise Implementation

### What's New
- **117 production cmdlets** â€” all enterprise stubs fully implemented with real vSphere API logic.
- **28 modules** including the `AnyStack` meta-module for simplified suite-wide installation.
- **Gold Standard Compliance**: Standardized resilience (retry logic), typing, and metadata across all cmdlets.
- **Dependency Hardening**: Explicit declaration of `VMware.VimAutomation.Core` in all module manifests.
- **VCF.StorageAdvanced** expanded with full NVMe management cmdlet implementations.
- **New Workflow Examples**: Production-ready automation scripts added to the `examples/` directory.

### Installation
You can install the complete suite directly from the PowerShell Gallery:
```powershell
Install-Module -Name AnyStack -Scope CurrentUser
```

### Breaking Changes
The following cmdlets in `VCF.DRValidator` were renamed for consistency in previous releases:
| Old Name | New Name |
|----------|----------|
| Export-DRReadinessReport | Export-AnyStackDRReadinessReport |
| Test-DisasterRecoveryReadiness | Test-AnyStackDisasterRecoveryReadiness |
| Repair-DisasterRecoveryReadiness | Repair-AnyStackDisasterRecoveryReadiness |


 

