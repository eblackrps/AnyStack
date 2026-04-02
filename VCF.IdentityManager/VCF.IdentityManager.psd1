@{
    RootModule = 'VCF.IdentityManager.psm1'
    ModuleVersion = '1.7.9'
    GUID = 'bfd98cf4-0261-4e5f-ad55-b818f8e22ce5'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 The AnyStack Architect. Released under the MIT License.'
    Description = 'Enterprise module for VCF.IdentityManager automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VCF.PowerCLI'; ModuleVersion='9.0'}
        @{ModuleName='AnyStack.vSphere'; ModuleVersion='1.7.9'}
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







 

