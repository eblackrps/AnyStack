# AnyStack Enterprise Module Suite

**Version:** 1.6.1 | **Author:** [The Any Stack Architect](https://www.anystackarchitect.com) | **License:** MIT

[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/AnyStack.vSphere?style=flat-square&logo=powershell&label=AnyStack.vSphere)](https://www.powershellgallery.com/packages/AnyStack.vSphere)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](https://opensource.org/licenses/MIT)
![CI](https://github.com/eblackrps/AnyStack/actions/workflows/ci.yml/badge.svg)

Production-ready PowerShell automation for VMware vSphere 8.0 U3 and VMware Cloud Foundation. 121+ cmdlets across 27 specialized modules covering everything from STIG compliance and certificate lifecycle to capacity forecasting, vSAN health, and SDDC Manager integration.

If you have spent real time managing VCF or vSphere at scale, you know what click-ops fatigue feels like. AnyStack is the answer to that.

## Compatibility

| Component | Supported | Notes |
|---|---|---|
| VMware vSphere | 8.0 U3 | vCenter + ESXi |
| VMware VCF | 5.1, 5.2 | SDDC Manager required for VCF.SddcManager |
| PowerShell | 7.2+, 7.4+ recommended | Windows PowerShell 5.1 not supported |
| VMware.PowerCLI | 13.0+ | `Install-Module VMware.PowerCLI` |
| Pester | 5.0+ | For test suite |
| OS | Windows 10+, Ubuntu 22.04+, macOS 13+ | Via PowerShell 7 |

## Installation

### From PowerShell Gallery (recommended)

```powershell
# Install the meta-module — pulls in all 27 modules automatically
Install-Module -Name AnyStack -Scope CurrentUser
```

### From Source

```powershell
.\Install-AnyStack.ps1 -Force
# Add -Global to install for all users (requires Administrator)
```

## Quick Start

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

# Run a full environment health check
Invoke-AnyStackHealthCheck

# Check DR readiness across all VMs
Test-AnyStackDisasterRecoveryReadiness

# Surface zombie VMs consuming storage
Get-AnyStackZombieVm

# Run a CIS/STIG compliance audit
Invoke-AnyStackCisStigAudit
```

Every public cmdlet supports `-WhatIf` so you can validate before touching production.

## Modules

| Module | Cmdlets | Description |
|---|---|---|
| [AnyStack.vSphere](./AnyStack.vSphere/) | 6 | Core connectivity, health checks, license auditing |
| [AnyStack.ConfigurationAsCode](./AnyStack.ConfigurationAsCode/) | 2 | Export and sync vCenter config as code |
| [AnyStack.Reporting](./AnyStack.Reporting/) | 2 | HTML infrastructure reports |
| [VCF.AlarmManager](./VCF.AlarmManager/) | 1 | Active alarm surfacing and triage |
| [VCF.ApplianceManager](./VCF.ApplianceManager/) | 4 | VCSA disk, services, and database health |
| [VCF.AutomationOrchestrator](./VCF.AutomationOrchestrator/) | 4 | Scheduled tasks, snapshot automation, webhooks |
| [VCF.CapacityPlanner](./VCF.CapacityPlanner/) | 4 | Datastore growth forecasting, zombie VMs, right-sizing |
| [VCF.CertificateManager](./VCF.CertificateManager/) | 3 | Certificate lifecycle for ESXi and vCenter |
| [VCF.ClusterManager](./VCF.ClusterManager/) | 11 | DRS, HA, host profiles, NTP, power policy, vCLS |
| [VCF.ComplianceAuditor](./VCF.ComplianceAuditor/) | 4 | CIS/STIG audit and drift remediation |
| [VCF.ContentManager](./VCF.ContentManager/) | 4 | Content Library and template management |
| [VCF.DRValidator](./VCF.DRValidator/) | 4 | DR readiness: snapshot age, HA state, reachability |
| [VCF.HostEvacuation](./VCF.HostEvacuation/) | 2 | Controlled maintenance mode and host evacuation |
| [VCF.IdentityManager](./VCF.IdentityManager/) | 4 | RBAC auditing, roles, SSO validation |
| [VCF.LifecycleManager](./VCF.LifecycleManager/) | 4 | vLCM cluster images, remediation, compliance |
| [VCF.LogIntelligence](./VCF.LogIntelligence/) | 4 | Syslog config, log bundles, forwarding validation |
| [VCF.NetworkAudit](./VCF.NetworkAudit/) | 5 | MAC conflicts, NIC status, vMotion network checks |
| [VCF.NetworkManager](./VCF.NetworkManager/) | 3 | DVS port groups, VLAN provisioning |
| [VCF.PerformanceProfiler](./VCF.PerformanceProfiler/) | 4 | CPU co-stop, storage latency, performance baselines |
| [VCF.ResourceAudit](./VCF.ResourceAudit/) | 11 | VM uptime, migrations, CPU ready, VMware Tools |
| [VCF.SddcManager](./VCF.SddcManager/) | 3 | Workload Domains, password rotation, SDDC health |
| [VCF.SecurityAdvanced](./VCF.SecurityAdvanced/) | 4 | Native Key Provider, SSH control, lockdown mode |
| [VCF.SecurityBaseline](./VCF.SecurityBaseline/) | 4 | Security baseline: lockdown, SSH, NTP, syslog |
| [VCF.SnapshotManager](./VCF.SnapshotManager/) | 2 | Orphaned snapshot cleanup and chain optimization |
| [VCF.StorageAdvanced](./VCF.StorageAdvanced/) | 5 | NVMe-oF interface management for vSphere 8.0 U3 |
| [VCF.StorageAudit](./VCF.StorageAudit/) | 9 | IOPS, latency, orphaned VMDKs, vSAN health |
| [VCF.TagManager](./VCF.TagManager/) | 4 | Tag enforcement, stale tag cleanup, category sync |

## Development & Testing

```powershell
.\test-syntax.ps1
.\build.ps1
Invoke-Pester .\ -Recurse
```

## Broadcom / Licensing Note

VMware products are under Broadcom ownership as of 2024. VCF and vSphere licensing has changed significantly. AnyStack requires valid Broadcom licenses for the target environment. AnyStack itself is MIT licensed and free to use.

## Contributing

All public cmdlets must support `-WhatIf` via `[CmdletBinding(SupportsShouldProcess=$true)]` and follow PowerShell verb-noun conventions. See [CONTRIBUTING.md](./CONTRIBUTING.md).

## Links

- [anystackarchitect.com](https://www.anystackarchitect.com)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [Introducing AnyStack — blog post](https://www.anystackarchitect.com/introducing-anystack-powershell-automation-for-vsphere-and-vcf/)


 
