@{
    RootModule = 'VCF.StorageAudit.psm1'
    ModuleVersion = '1.7.8'
    GUID = '4b043d6e-a2c6-40a9-b2ec-15bd2518b3fb'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.StorageAudit automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VCF.PowerCLI'; ModuleVersion='9.0'}
        @{ModuleName='AnyStack.vSphere'; ModuleVersion='1.7.8'}
    )
    FunctionsToExport = @('Get-AnyStackDatastoreIops','Get-AnyStackDatastoreLatency','Get-AnyStackOrphanedVmdk','Get-AnyStackVmDiskLatency','Get-AnyStackVsanHealth','Invoke-AnyStackDatastoreUnmount','Test-AnyStackDatastorePathMultipathing','Test-AnyStackStorageConfiguration','Test-AnyStackVsanCapacity')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.StorageAudit')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







 
