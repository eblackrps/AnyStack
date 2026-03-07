@{
    RootModule           = 'VCF.NetworkManager.psm1'
    ModuleVersion        = '1.0.0.0'
    GUID = '3a2cf465-e79f-4ac2-b8f7-8c35635f4b1e'
    Author               = 'The Any Stack Architect'
    Description          = 'Advanced Infrastructure Module for vSphere 8.0 U3'
    PowerShellVersion    = '5.1'
    RequiredModules      = @( @{ ModuleName = 'VMware.VimAutomation.Core'; ModuleVersion = '13.3.0.22683933'
    GUID = '3a2cf465-e79f-4ac2-b8f7-8c35635f4b1e' } )
    FunctionsToExport    = '*'
}

