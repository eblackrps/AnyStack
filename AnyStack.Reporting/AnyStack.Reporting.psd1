@{
    RootModule = 'AnyStack.Reporting.psm1'
    ModuleVersion = '1.5.0'
    GUID = 'e3a41f70-f989-4079-bbc6-65965e3644d1'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for AnyStack.Reporting automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        'VMware.VimAutomation.Core',
        @{ModuleName='VMware.PowerCLI'; ModuleVersion='13.0'}
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







