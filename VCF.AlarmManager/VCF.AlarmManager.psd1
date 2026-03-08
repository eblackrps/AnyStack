@{
    RootModule = 'VCF.AlarmManager.psm1'
    ModuleVersion = '1.5.0'
    GUID = 'af0a8e65-7c68-4fea-96ae-65278bc5009e'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.AlarmManager automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VMware.PowerCLI'; ModuleVersion='13.0'}
    )
    FunctionsToExport = @('Get-AnyStackActiveAlarm')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.AlarmManager')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







