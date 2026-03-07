@{
    RootModule           = 'VCF.StorageAdvanced.psm1'
    ModuleVersion        = '1.0.0.0'
    GUID = '486d7e59-50bd-42eb-8a5b-bab558129ddb'
    Author               = 'The Any Stack Architect'
    Description          = 'Advanced Infrastructure Module for vSphere 8.0 U3'
    PowerShellVersion    = '5.1'
    RequiredModules      = @( @{ ModuleName = 'VMware.VimAutomation.Core'; ModuleVersion = '13.3.0.22683933'
    GUID = '486d7e59-50bd-42eb-8a5b-bab558129ddb' } )
    FunctionsToExport    = '*'
}

