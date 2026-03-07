@{
    RootModule           = 'VCF.ClusterManager.psm1'
    ModuleVersion        = '1.0.0.0'
    GUID = '708bbcca-7018-4679-8365-001cd7e4fce4'
    Author               = 'The Any Stack Architect'
    Description          = 'Advanced Infrastructure Module for vSphere 8.0 U3'
    PowerShellVersion    = '5.1'
    RequiredModules      = @( @{ ModuleName = 'VMware.VimAutomation.Core'; ModuleVersion = '13.3.0.22683933'
    GUID = '708bbcca-7018-4679-8365-001cd7e4fce4' } )
    FunctionsToExport    = '*'
}

