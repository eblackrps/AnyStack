@{
    RootModule = 'VCF.ContentManager.psm1'
    ModuleVersion = '1.2.0'
    GUID = '27b14bf7-a39b-43d7-85b8-72a9281e9ceb'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.ContentManager automation and management.'
    PowerShellVersion = '7.2'
    
        'VMware.VimAutomation.Core',
        @{ModuleName='VMware.PowerCLI'; ModuleVersion='13.0'}
    )
    FunctionsToExport = @('Get-AnyStackLibraryItem','New-AnyStackVmTemplate','Remove-AnyStackOrphanedIso','Sync-AnyStackContentLibrary')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.ContentManager')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}




