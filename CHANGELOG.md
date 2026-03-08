# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-03-07
### Added
- Full implementation of all 79 previously-stubbed cmdlets
- VCF.StorageAdvanced expanded with 4 new NVMe cmdlets
- AnyStack meta-module for single-command suite installation
- PSGallery publication workflow via GitHub Actions
- tools/Validate-ForGallery.ps1 pre-publish validation script
- Compatibility matrix in README
### Fixed
- VCF.DRValidator cmdlet naming inconsistency (I-01)
- Install-AnyStack.ps1 elevation guard for -Global flag
### Changed  
- Generator and dev scripts moved to tools/ subdirectory
- All module manifests audited and hardened
- CI workflow now publishes test results as artifacts
### Security
- FixAndPublish.ps1 replaced by GitHub Actions publish workflow
- PSGallery API key moved to GitHub repository secret

## [1.0.0] - 2026-03-07

### Added
- Initial release of the AnyStack Enterprise PowerShell Module Suite.
- Comprehensive suite of 113 cmdlets for VMware vSphere 8.0 U3 / VCF automation.
- Production-grade hardening, pipeline support, structured error handling, and robust Pester 5 test coverage.
