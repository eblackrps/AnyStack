@{
    RootModule = 'VCF.SecurityAdvanced.psm1'
    ModuleVersion = '1.7.5'
    GUID = '3cd79541-f1c6-43cf-9ab8-5eba8e46cc7a'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.SecurityAdvanced automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VCF.PowerCLI'; ModuleVersion = '1.7.5'}
    )
    FunctionsToExport = @('Add-AnyStackNativeKeyProvider','Disable-AnyStackHostSsh','Enable-AnyStackHostSsh','Set-AnyStackEsxiLockdownMode')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.SecurityAdvanced')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







 









