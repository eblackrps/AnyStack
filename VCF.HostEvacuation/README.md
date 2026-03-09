# VCF.HostEvacuation

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.2 · MIT License**

Controlled host evacuation for maintenance windows. Handles vMotion of workloads off a host and returns it to service.

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
Install-Module -Name VCF.HostEvacuation -Scope CurrentUser
```

## Cmdlets

### `Start-AnyStackHostEvacuation`
Places a host into maintenance mode and vMotions all running VMs to other hosts in the cluster.

### `Stop-AnyStackHostEvacuation`
Exits maintenance mode and returns the host to the cluster resource pool.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.HostEvacuation
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 



