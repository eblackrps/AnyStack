# VCF.SecurityBaseline

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.7 · MIT License**

Security baseline auditing for ESXi: lockdown mode, SSH state, NTP configuration, syslog, and AD integration validation.

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
Install-Module -Name VCF.SecurityBaseline -Scope CurrentUser
```

## Cmdlets

### `Get-AnyStackEsxiLockdownMode`
Returns current lockdown mode state for all hosts in scope.

### `Test-AnyStackAdIntegration`
Validates Active Directory join state and authentication for ESXi hosts.

### `Test-AnyStackHostSyslog`
Checks syslog configuration and forwarding state on ESXi hosts.

### `Test-AnyStackSecurityBaseline`
Runs a four-check security baseline audit: lockdown mode, SSH state, NTP configuration, and syslog forwarding.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.SecurityBaseline
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 









