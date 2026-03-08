@{
    RootModule = 'VCF.ClusterManager.psm1'
    ModuleVersion = '1.2.0'
    GUID = '708bbcca-7018-4679-8365-001cd7e4fce4'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.ClusterManager automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VMware.PowerCLI'; ModuleVersion='13.0'}
    )
    FunctionsToExport = @('Export-AnyStackClusterReport','Get-AnyStackHostFirmware','Get-AnyStackHostSensors','New-AnyStackHostProfile','Set-AnyStackDrsRule','Set-AnyStackHostPowerPolicy','Set-AnyStackVclsRetreatMode','Set-AnyStackVmAffinityRule','Test-AnyStackHaFailover','Test-AnyStackHostNtp','Test-AnyStackProactiveHa')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.ClusterManager')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}



