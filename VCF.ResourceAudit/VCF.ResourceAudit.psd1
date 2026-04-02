@{
    RootModule = 'VCF.ResourceAudit.psm1'
    ModuleVersion = '1.7.8'
    GUID = 'c4212e0c-bf47-4519-b333-aee9b0ed312e'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.ResourceAudit automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VCF.PowerCLI'; ModuleVersion='9.0'}
        @{ModuleName='AnyStack.vSphere'; ModuleVersion='1.7.8'}
    )
    FunctionsToExport = @('Get-AnyStackHostMemoryUsage','Get-AnyStackOrphanedState','Get-AnyStackVmMigrationHistory','Get-AnyStackVmUptime','Move-AnyStackVmDatastore','Remove-AnyStackOldTemplates','Restart-AnyStackVmTools','Set-AnyStackVmResourcePool','Test-AnyStackVmCpuReady','Update-AnyStackVmHardware','Update-AnyStackVmTools')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.ResourceAudit')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







 
