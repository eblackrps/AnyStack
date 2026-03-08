@{
    RootModule = 'VCF.TagManager.psm1'
    ModuleVersion = '1.5.0'
    GUID = '1c7dc7a6-a1ad-4bf2-bdb0-885ce8089e53'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.TagManager automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        'VMware.VimAutomation.Core',
        @{ModuleName='VMware.PowerCLI'; ModuleVersion='13.0'}
    )
    FunctionsToExport = @('Get-AnyStackUntaggedVm','Remove-AnyStackStaleTag','Set-AnyStackResourceTag','Sync-AnyStackTagCategory')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.TagManager')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







