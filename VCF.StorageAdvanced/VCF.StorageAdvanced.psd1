@{
    RootModule = 'VCF.StorageAdvanced.psm1'
    ModuleVersion = '1.7.9'
    GUID = '486d7e59-50bd-42eb-8a5b-bab558129ddb'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 The AnyStack Architect. Released under the MIT License.'
    Description = 'Enterprise module for VCF.StorageAdvanced automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VCF.PowerCLI'; ModuleVersion='9.0'}
        @{ModuleName='AnyStack.vSphere'; ModuleVersion='1.7.9'}
    )
    FunctionsToExport = @('Add-AnyStackNvmeInterface','Get-AnyStackNvmeDevice','Remove-AnyStackNvmeInterface','Set-AnyStackNvmeQueueDepth','Test-AnyStackNvmeConnectivity')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.StorageAdvanced')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}








 

