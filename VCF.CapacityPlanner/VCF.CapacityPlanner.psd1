@{
    RootModule = 'VCF.CapacityPlanner.psm1'
    ModuleVersion = '1.7.5'
    GUID = '2d04c202-4008-40c8-84b2-22b356955b4c'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.CapacityPlanner automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VCF.PowerCLI'; ModuleVersion = '1.7.5'}
    )
    FunctionsToExport = @('Export-AnyStackCapacityForecast','Get-AnyStackDatastoreGrowthRate','Get-AnyStackZombieVm','Set-AnyStackRightSizeRecommendation')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.CapacityPlanner')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







 









