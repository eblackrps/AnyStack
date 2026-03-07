# AnyStack.vSphere Module Manifest
@{
    RootModule           = 'AnyStack.vSphere.psm1'
    ModuleVersion        = '1.0.0.0'
    GUID                 = 'b9a8c1d2-3e4f-4a6b-bc8d-123456789abc'
    Author               = 'The Any Stack Architect'
    CompanyName          = 'AnyStack'
    Copyright            = '(c) 2026 The Any Stack Architect. All rights reserved.'
    Description          = 'Advanced Infrastructure Automation Module for vSphere 8.0 U3 (ESXi 8.0.3 / VCSA 8.0.3)'
    PowerShellVersion = '5.1' # Optimized for modern PowerShell and PowerCLI v13+
    RequiredModules      = @(
        @{ ModuleName = 'VMware.VimAutomation.Core'; ModuleVersion = '13.3.0.22683933' } # VCF 9.0 / PowerCLI 13.3
    )
    FunctionsToExport    = '*'
    CmdletsToExport      = '*'
    VariablesToExport    = '*'
    AliasesToExport      = '*'
    PrivateData = @{
        PSData = @{
            Tags = @('vSphere', 'Automation', 'Infrastructure', 'VMware', 'ESXi8', 'VCSA8')
            ProjectUri = 'https://anystack.io'
        }
    }
}
