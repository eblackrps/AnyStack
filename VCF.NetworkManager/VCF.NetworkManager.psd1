@{
    RootModule = 'VCF.NetworkManager.psm1'
    ModuleVersion = '1.5.0'
    GUID = '3a2cf465-e79f-4ac2-b8f7-8c35635f4b1e'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.NetworkManager automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        'VMware.VimAutomation.Core',
        @{ModuleName='VMware.PowerCLI'; ModuleVersion='13.0'}
    )
    FunctionsToExport = @('Get-AnyStackDistributedPortgroup','New-AnyStackVlan','Set-AnyStackVlanTag')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.NetworkManager')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







