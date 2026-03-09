@{
    RootModule = 'AnyStack.ConfigurationAsCode.psm1'
    ModuleVersion = '1.7.1'
    GUID = 'b7d6c0fe-c4df-4761-b72d-dfdea8301311'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for AnyStack.ConfigurationAsCode automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        'VCF.PowerCLI',
        @{ModuleName='AnyStack.vSphere'; ModuleVersion='1.7.1'}
    )
    FunctionsToExport = @('Export-AnyStackConfiguration','Sync-AnyStackConfiguration')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'AnyStack.ConfigurationAsCode')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







 











