# VCF.ClusterManager

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.5 · MIT License**

Cluster-level operations: DRS rules, HA failover testing, host power policy, NTP validation, host profiles, and vCLS retreat mode management.

## Requirements

- PowerShell 7.2+
- VCF.PowerCLI 9.0+
- vSphere 8.0 U3 / VCF 5.1+
- AnyStack.vSphere (connection management)

## Installation

```powershell
# Install the full AnyStack suite
Install-Module -Name AnyStack -Scope CurrentUser

# Or install this module individually
Install-Module -Name VCF.ClusterManager -Scope CurrentUser
```

## Cmdlets

### `Export-AnyStackClusterReport`
Generates a detailed cluster report covering DRS, HA, resource utilization, and host state.

### `Get-AnyStackHostFirmware`
Returns BIOS and firmware versions for all hosts in scope.

### `Get-AnyStackHostSensors`
Reads hardware sensor data (temperature, fans, power) from ESXi hosts.

### `New-AnyStackHostProfile`
Creates a new host profile from a reference host.

### `Set-AnyStackDrsRule`
Creates or modifies a DRS affinity or anti-affinity rule on a cluster.

### `Set-AnyStackHostPowerPolicy`
Sets the power management policy on ESXi hosts (balanced, high-performance, low-power).

### `Set-AnyStackVclsRetreatMode`
Enables or disables vCLS retreat mode on a cluster for maintenance scenarios.

### `Set-AnyStackVmAffinityRule`
Creates a VM-to-VM or VM-to-host affinity rule.

### `Test-AnyStackHaFailover`
Simulates an HA failover scenario and validates admission control capacity.

### `Test-AnyStackHostNtp`
Validates NTP configuration and sync state on all hosts in scope.

### `Test-AnyStackProactiveHa`
Checks Proactive HA configuration and provider health state on a cluster.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.ClusterManager
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 







