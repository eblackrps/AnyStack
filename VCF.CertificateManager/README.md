# VCF.CertificateManager

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · MIT License**

Certificate lifecycle management for ESXi hosts and vCenter. Audit expiry, renew host certificates, and manage VMCA-signed certs without manual console work.

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
Install-Module -Name VCF.CertificateManager -Scope CurrentUser
```

## Cmdlets

### `Test-AnyStackCertificates`
Audits TLS certificate validity across ESXi hosts and vCenter, reporting expiry dates and flagging certificates expiring within a configurable threshold.

### `Update-AnyStackEsxCertificate`
Renews the certificate on a specified ESXi host using VMCA or a provided CA-signed certificate.

### `Update-AnyStackVcsCertificate`
Renews the vCenter Server certificate via the VMCA REST API.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.CertificateManager
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 
