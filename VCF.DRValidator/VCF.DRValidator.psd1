# VCF.DRValidator Module Manifest
@{
    RootModule           = 'VCF.DRValidator.psm1'
    ModuleVersion        = '1.0.0.0'
    GUID = '57327433-fb2f-4506-a6ac-67d48b016bf2'
    Author               = 'The Any Stack Architect'
    CompanyName          = 'AnyStack'
    Copyright            = '(c) 2026 The Any Stack Architect. All rights reserved.'
    Description          = 'Advanced Disaster Recovery Readiness Validator for vSphere 8.0 U3 (ESXi 8.0.3 / VCSA 8.0.3)'
    PowerShellVersion = '5.1'
    RequiredModules      = @(
        @{ ModuleName = 'VMware.VimAutomation.Core'; ModuleVersion = '13.3.0.22683933' }
    )
    FunctionsToExport    = '*'
    CmdletsToExport      = '*'
    VariablesToExport    = '*'
    AliasesToExport      = '*'
    PrivateData = @{
        PSData = @{
            Tags = @('vSphere', 'Automation', 'DR', 'DisasterRecovery', 'VCF9', 'ESXi8')
            ProjectUri = 'https://anystack.io'
        }
    }
}
