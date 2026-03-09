# AnyStack Tools

This directory contains utility scripts for AnyStack development, publishing, and code generation.

## Directory Structure

### `/dev`
- **harden-functions.ps1**: Used for applying global standards and formatting rules to all PowerShell module functions.
- **Generate-Stubs.ps1**: Generates stubs based on specifications.

### `/generators`
- **generate-40-rounds.ps1**: Development script for generating large batches of module functions.
- **generate-advanced-modules.ps1**: Script to scaffold advanced VCF modules.
- **generate-production-modules.ps1**: Script to promote test modules to production state.

### Base Tools
- **FixAndPublish.ps1**: Validation and publication script to deploy modules to PSGallery. (Replaced by GitHub Actions, kept for local testing)
- **Validate-ForGallery.ps1**: Pre-publish validation script to ensure all modules pass PSScriptAnalyzer and meet manifest requirements.
 


