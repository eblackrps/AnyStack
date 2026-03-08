@{
    RootModule = 'VCF.IdentityManager.psm1'
    ModuleVersion = '1.5.0'
    GUID = 'bfd98cf4-0261-4e5f-ad55-b818f8e22ce5'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.IdentityManager automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        'VMware.VimAutomation.Core',
        @{ModuleName='VMware.PowerCLI'; ModuleVersion = '1.5.0'}
    )
    FunctionsToExport = @('Export-AnyStackAccessMatrix','Get-AnyStackGlobalPermission','New-AnyStackCustomRole','Test-AnyStackSsoConfiguration')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.IdentityManager')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







 


