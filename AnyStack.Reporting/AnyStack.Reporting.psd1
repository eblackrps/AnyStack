@{
    RootModule = 'AnyStack.Reporting.psm1'
    ModuleVersion = '1.7.9'
    GUID = 'e3a41f70-f989-4079-bbc6-65965e3644d1'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 The AnyStack Architect. Released under the MIT License.'
    Description = 'Enterprise module for AnyStack.Reporting automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VCF.PowerCLI'; ModuleVersion='9.0'}
        @{ModuleName='AnyStack.vSphere'; ModuleVersion='1.7.9'}
    )
    FunctionsToExport = @('Export-AnyStackHtmlReport','Invoke-AnyStackReport')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'AnyStack.Reporting')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







 

