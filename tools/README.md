# AnyStack Tools

This directory contains utility scripts for AnyStack development, publishing, and code generation.

The supported production workflow is:

```powershell
.\tools\Set-Version.ps1 -Version 1.7.9
.\test-syntax.ps1
.\tools\Validate-ForGallery.ps1
.\build.ps1
.\tools\Invoke-SmokeTest.ps1 -Server 'vcenter.lab.local' -Credential (Get-Credential) -ClusterName 'Lab-Cluster'
```

## Directory Structure

### `/dev`
- **harden-functions.ps1**: Used for applying global standards and formatting rules to all PowerShell module functions.
- **Generate-Stubs.ps1**: Generates stubs based on specifications.

### `/generators`
- **generate-40-rounds.ps1**: Development script for generating large batches of module functions.
- **generate-advanced-modules.ps1**: Script to scaffold advanced VCF modules.
- **generate-production-modules.ps1**: Script to promote test modules to production state.

### Base Tools
- **FixAndPublish.ps1**: Runs syntax checks, gallery validation, the full build, and then publishes modules locally to PSGallery in a safe order.
- **Invoke-SmokeTest.ps1**: Connects to a real vCenter or VCF lab, exercises safe read-only cmdlets, and verifies `-WhatIf` behavior on high-risk commands before release.
- **Set-Version.ps1**: Updates version references across manifests, docs, and build metadata without touching git history.
- **Validate-ForGallery.ps1**: Pre-publish validation script to ensure all modules pass `Test-ModuleManifest`, PSScriptAnalyzer, and metadata checks.

