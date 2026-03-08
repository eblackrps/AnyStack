@{
    RootModule = 'VCF.LifecycleManager.psm1'
    ModuleVersion = '1.6.1'
    GUID = 'b9926487-f43a-41c3-925f-34525f82ba52'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.LifecycleManager automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VMware.PowerCLI'; ModuleVersion='13.0'}
    )
    FunctionsToExport = @('Export-AnyStackHardwareCompatibility','Get-AnyStackClusterImage','Start-AnyStackHostRemediation','Test-AnyStackCompliance')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.LifecycleManager')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







