@{
    RootModule = 'VCF.SecurityBaseline.psm1'
    ModuleVersion = '1.1.0'
    GUID = '519143fe-e924-4451-a767-f9c7e7f08a56'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.SecurityBaseline automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VMware.PowerCLI'; ModuleVersion='13.0'}
    )
    FunctionsToExport = @('Get-AnyStackEsxiLockdownMode','Test-AnyStackAdIntegration','Test-AnyStackHostSyslog','Test-AnyStackSecurityBaseline')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.SecurityBaseline')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}


