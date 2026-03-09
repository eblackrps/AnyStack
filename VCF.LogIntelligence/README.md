# VCF.LogIntelligence

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.7 · MIT License**

Syslog configuration, log bundle collection, stale log cleanup, and forwarding validation.

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
Install-Module -Name VCF.LogIntelligence -Scope CurrentUser
```

## Cmdlets

### `Clear-AnyStackStaleLogs`
Removes log files exceeding a configurable age from ESXi scratch partitions.

### `Get-AnyStackHostLogBundle`
Collects a support log bundle from a specified ESXi host.

### `Set-AnyStackSyslogServer`
Configures the syslog forwarding target on ESXi hosts.

### `Test-AnyStackLogForwarding`
Validates that syslog forwarding is active and reaching the configured destination.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.LogIntelligence
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 









