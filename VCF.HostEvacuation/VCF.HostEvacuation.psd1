@{
    RootModule = 'VCF.HostEvacuation.psm1'
    ModuleVersion = '1.6.7'
    GUID = 'b0a4a324-eb78-4b94-b876-6a831c09cef7'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.HostEvacuation automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VCF.PowerCLI'; ModuleVersion='9.0'}
    )
    FunctionsToExport = @('Start-AnyStackHostEvacuation','Stop-AnyStackHostEvacuation')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.HostEvacuation')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







 









