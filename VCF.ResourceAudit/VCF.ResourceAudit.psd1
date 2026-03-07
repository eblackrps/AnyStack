@{
    RootModule           = 'VCF.ResourceAudit.psm1'
    ModuleVersion        = '1.0.0.0'
    GUID = 'c4212e0c-bf47-4519-b333-aee9b0ed312e'
    Author               = 'The Any Stack Architect'
    CompanyName          = 'AnyStack'
    Description          = 'Advanced Infrastructure Module for vSphere 8.0 U3'
    PowerShellVersion = '5.1'
    RequiredModules      = @( @{ ModuleName = 'VMware.VimAutomation.Core'; ModuleVersion = '13.3.0.22683933'
    GUID = 'c4212e0c-bf47-4519-b333-aee9b0ed312e' } )
    FunctionsToExport    = '*'
}

