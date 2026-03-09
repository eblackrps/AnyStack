# VCF.PerformanceProfiler

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.2 · MIT License**

Performance baseline capture, CPU co-stop analysis, storage latency profiling, and dropped packet detection.

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
Install-Module -Name VCF.PerformanceProfiler -Scope CurrentUser
```

## Cmdlets

### `Export-AnyStackPerformanceBaseline`
Captures a point-in-time performance baseline across CPU, memory, storage, and network for the environment.

### `Get-AnyStackHostCpuCoStop`
Returns CPU co-stop metrics for all VMs on a host, identifying scheduling contention.

### `Get-AnyStackVmStorageLatency`
Reports per-VM storage read/write latency from vSphere stats.

### `Test-AnyStackNetworkDroppedPackets`
Checks for dropped packet counters on physical NICs and DVS uplinks.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.PerformanceProfiler
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 



