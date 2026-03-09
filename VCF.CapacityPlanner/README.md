# VCF.CapacityPlanner

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.5 · MIT License**

Datastore growth forecasting, zombie VM detection, and right-sizing recommendations. Go beyond current utilization to understand where you are heading.

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
Install-Module -Name VCF.CapacityPlanner -Scope CurrentUser
```

## Cmdlets

### `Export-AnyStackCapacityForecast`
Projects datastore capacity forward based on a 7-day usage trend and exports a CSV/HTML forecast report.

### `Get-AnyStackDatastoreGrowthRate`
Calculates daily growth rate for each datastore based on Get-Stat disk.used.latest samples over the past 7 days.

### `Get-AnyStackZombieVm`
Identifies VMs that are powered off, have no recent activity, and are consuming storage without active use.

### `Set-AnyStackRightSizeRecommendation`
Analyzes CPU and memory utilization trends and generates right-sizing recommendations for over-provisioned VMs.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.CapacityPlanner
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 







