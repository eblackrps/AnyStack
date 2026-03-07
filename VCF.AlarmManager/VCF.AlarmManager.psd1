@{
    RootModule           = 'VCF.AlarmManager.psm1'
    ModuleVersion        = '1.0.0.0'
    GUID = 'af0a8e65-7c68-4fea-96ae-65278bc5009e'
    Author               = 'The Any Stack Architect'
    CompanyName          = 'AnyStack'
    Description          = 'Advanced Infrastructure Module for vSphere 8.0 U3'
    PowerShellVersion = '5.1'
    RequiredModules      = @( @{ ModuleName = 'VMware.VimAutomation.Core'; ModuleVersion = '13.3.0.22683933'
    GUID = 'af0a8e65-7c68-4fea-96ae-65278bc5009e' } )
    FunctionsToExport    = '*'
}

