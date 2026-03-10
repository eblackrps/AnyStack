@{
    RootModule = 'AnyStack.vSphere.psm1'
    ModuleVersion = '1.7.5'
    GUID = 'f5053a10-87a3-4e68-b568-ce9245938e94'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for AnyStack.vSphere automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VCF.PowerCLI'; ModuleVersion = '1.7.5'}
    )
    FunctionsToExport = @('Connect-AnyStackServer','Disconnect-AnyStackServer','Get-AnyStackLicenseUsage','Get-AnyStackVcenterServices','Invoke-AnyStackHealthCheck','Write-AnyStackLog')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'AnyStack.vSphere')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}


 









