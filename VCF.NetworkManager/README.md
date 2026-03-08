# VCF.NetworkManager

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.0 · MIT License**

Distributed Virtual Switch management: port group inventory, VLAN provisioning, and tag assignment.

## Requirements

- PowerShell 7.2+
- VMware.PowerCLI 13.0+
- vSphere 8.0 U3 / VCF 5.1+
- AnyStack.vSphere (connection management)

## Installation

```powershell
# Install the full AnyStack suite
Install-Module -Name AnyStack -Scope CurrentUser

# Or install this module individually
Install-Module -Name VCF.NetworkManager -Scope CurrentUser
```

## Cmdlets

### `Get-AnyStackDistributedPortgroup`
Returns all DVS port groups with VLAN, uplink, and policy configuration.

### `New-AnyStackVlan`
Creates a new VLAN-backed port group on a specified Distributed Virtual Switch.

### `Set-AnyStackVlanTag`
Updates the VLAN tag on an existing DVS port group.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.NetworkManager
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
