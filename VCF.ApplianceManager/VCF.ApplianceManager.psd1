@{
    RootModule = 'VCF.ApplianceManager.psm1'
    ModuleVersion = '1.7.7'
    GUID = 'f65b0300-962a-42bb-b14f-705f88cdf65f'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.ApplianceManager automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VCF.PowerCLI'; ModuleVersion='9.0'}
        @{ModuleName='AnyStack.vSphere'; ModuleVersion='1.7.7'}
    )
    FunctionsToExport = @('Get-AnyStackVcenterDiskSpace','Restart-AnyStackVcenterService','Start-AnyStackVcenterBackup','Test-AnyStackVcenterDatabaseHealth')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.ApplianceManager')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







 
