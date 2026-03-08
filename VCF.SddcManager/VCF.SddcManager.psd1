@{
    RootModule = 'VCF.SddcManager.psm1'
    ModuleVersion = '1.2.0'
    GUID = '8873f9b6-1cce-449b-8835-5d390fd6b623'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.SddcManager automation and management.'
    PowerShellVersion = '7.2'
    
        'VMware.VimAutomation.Core',
        @{ModuleName='VMware.PowerCLI'; ModuleVersion='13.0'}
    )
    FunctionsToExport = @('Get-AnyStackWorkloadDomain','Set-AnyStackPasswordRotation','Test-AnyStackSddcHealth')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.SddcManager')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}




