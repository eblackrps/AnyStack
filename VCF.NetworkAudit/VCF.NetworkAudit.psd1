# VCF.NetworkAudit Module Manifest
@{
    RootModule           = 'VCF.NetworkAudit.psm1'
    ModuleVersion        = '1.0.0.0'
    GUID = 'df84f8f4-61b7-435e-b2d9-04018f369b87'
    Author               = 'The Any Stack Architect'
    CompanyName          = 'AnyStack'
    Copyright            = '(c) 2026 The Any Stack Architect. All rights reserved.'
    Description          = 'Advanced Virtual Switch & Distributed Switch Configuration Auditor for vSphere 8.0 U3'
    PowerShellVersion = '5.1'
    RequiredModules      = @(
        @{ ModuleName = 'VMware.VimAutomation.Core'; ModuleVersion = '13.3.0.22683933' }
    )
    FunctionsToExport    = '*'
}
