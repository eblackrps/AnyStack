@{
    RootModule           = 'VCF.HostEvacuation.psm1'
    ModuleVersion        = '1.0.0.0'
    GUID = 'b0a4a324-eb78-4b94-b876-6a831c09cef7'
    Author               = 'The Any Stack Architect'
    Description          = 'Automated Host Evacuation Protocols for vSphere 8.0 U3'
    PowerShellVersion = '5.1'
    RequiredModules      = @(
        @{ ModuleName = 'VMware.VimAutomation.Core'; ModuleVersion = '13.3.0.22683933' }
    )
    FunctionsToExport    = '*'
}
