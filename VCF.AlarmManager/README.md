# VCF.AlarmManager

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · MIT License**

Surface and triage active vSphere alarms across the environment. Useful for automated alerting pipelines and ops dashboards.

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
Install-Module -Name VCF.AlarmManager -Scope CurrentUser
```

## Cmdlets

### `Get-AnyStackActiveAlarm`
Returns all currently triggered alarms across the vCenter inventory with severity, entity, and acknowledgment state.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.AlarmManager
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 
