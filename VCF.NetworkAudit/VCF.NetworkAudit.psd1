@{
    RootModule = 'VCF.NetworkAudit.psm1'
    ModuleVersion = '1.6.5'
    GUID = 'df84f8f4-61b7-435e-b2d9-04018f369b87'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.NetworkAudit automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VCF.PowerCLI'; ModuleVersion='9.0'}
    )
    FunctionsToExport = @('Get-AnyStackMacAddressConflict','Repair-AnyStackNetworkConfiguration','Test-AnyStackHostNicStatus','Test-AnyStackNetworkConfiguration','Test-AnyStackVmotionNetwork')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.NetworkAudit')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







 







