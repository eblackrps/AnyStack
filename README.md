# AnyStack Enterprise Module Suite
**Version:** 1.0.0 | **Author:** The Any Stack Architect

AnyStack is a production-ready, enterprise-grade PowerShell automation suite for VMware vSphere 8.0 U3 and VMware Cloud Foundation (VCF). It transforms imperative "click-ops" into scalable, declarative infrastructure management.

## Features
- **115+ Enterprise Cmdlets** spread across 27 specialized modules.
- **Reporting Engine:** Generate beautiful HTML reports of cluster health and capacity.
- **Configuration as Code:** Export and sync vCenter configurations dynamically.
- **Day-2 Operations:** Manage VSAN health, orphaned snapshots, TLS certificates, and resource pools.
- **VCF / SDDC Manager Integration:** Direct password rotation and Workload Domain management.
- **Security Auditing:** Run STIG compliance checks and remediate drift.

## Installation
Run the included setup script to install the modules into your local PowerShell path:
```powershell
.\Install-AnyStack.ps1 -Force
```
*(To install for all users, run as Administrator and append the `-Global` flag)*

## Usage
Import the core module to begin:
```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.anystack.local'
```

### Module Breakdown
* `AnyStack.Reporting` - Generate SDDC state reports.
* `AnyStack.ConfigurationAsCode` - Declarative vSphere syncs.
* `VCF.LifecycleManager` - vLCM updates and hardware compatibility.
* `VCF.StorageAudit` - Deep-dive datastore and VSAN performance metrics.
* `VCF.SecurityBaseline` - Lockdown mode and SSH compliance.
* ...and 20+ more!

## Development & Testing
To validate the application before deployment:
```powershell
.\test-syntax.ps1
.\build.ps1
Invoke-Pester .\VCF.DRValidator\Tests\VCF.DRValidator.Tests.ps1
```

## Contributing
All Public cmdlets must support `-WhatIf` (via `[CmdletBinding(SupportsShouldProcess=$true)]`) and follow standard PowerShell verb-noun conventions.

## License
MIT License
