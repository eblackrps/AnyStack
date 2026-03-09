# VCF.ApplianceManager

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.7.1 · MIT License**

Operational management of the vCenter Server Appliance (VCSA). Disk space monitoring, service control, and database health checks.

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
Install-Module -Name VCF.ApplianceManager -Scope CurrentUser
```

## Cmdlets

### `Get-AnyStackVcenterDiskSpace`
Reports disk utilization across all VCSA partitions, flagging partitions above threshold.

### `Restart-AnyStackVcenterService`
Safely restarts a named vCenter service with pre/post state validation.

### `Start-AnyStackVcenterBackup`
Initiates a file-based VCSA backup to a configured remote target.

### `Test-AnyStackVcenterDatabaseHealth`
Runs diagnostic checks against the embedded PostgreSQL database and reports on table bloat, connection count, and replication state.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.ApplianceManager
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 











