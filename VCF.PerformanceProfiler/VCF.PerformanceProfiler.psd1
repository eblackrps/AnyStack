@{
    RootModule = 'VCF.PerformanceProfiler.psm1'
    ModuleVersion = '1.2.0'
    GUID = 'e577018e-c017-4682-88a9-b613e640d15e'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.PerformanceProfiler automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VMware.PowerCLI'; ModuleVersion='13.0'}
    )
    FunctionsToExport = @('Export-AnyStackPerformanceBaseline','Get-AnyStackHostCpuCoStop','Get-AnyStackVmStorageLatency','Test-AnyStackNetworkDroppedPackets')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.PerformanceProfiler')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}



