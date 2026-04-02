# AnyStack.vSphere

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · MIT License**

Core connectivity and foundational utilities. All other AnyStack modules depend on this one. Handles server connections, health checks, license auditing, and logging.

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
Install-Module -Name AnyStack.vSphere -Scope CurrentUser
```

## Cmdlets

### `Connect-AnyStackServer`
Establishes an authenticated session to a vCenter Server and stores the connection for use by all other AnyStack cmdlets.

### `Disconnect-AnyStackServer`
Cleanly terminates the active vCenter session.

### `Get-AnyStackLicenseUsage`
Audits assigned vSphere licenses and reports usage against entitlement.

### `Get-AnyStackVcenterServices`
Lists all vCenter services and their current state.

### `Invoke-AnyStackHealthCheck`
Runs a broad environment health check covering host connectivity, vSAN status, and cluster DRS/HA state.

### `Write-AnyStackLog`
Structured logging utility used internally by AnyStack cmdlets. Supports console and file output.

## Usage

```powershell
Import-Module AnyStack.vSphere
$server = Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Get-AnyStackLicenseUsage -Server $server
Invoke-AnyStackHealthCheck
Get-AnyStackLicenseUsage -Server 'vcenter.yourenv.local'
```

`-Server` can be omitted when exactly one active connection is present, passed as a connected `VIServer` object, or passed as the name of an already-connected vCenter.

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 
