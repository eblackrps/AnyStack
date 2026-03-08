@{
    RootModule = 'VCF.LogIntelligence.psm1'
    ModuleVersion = '1.2.0'
    GUID = '4fbd7b2e-6e82-44a1-a5cd-4e282b207c3f'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.LogIntelligence automation and management.'
    PowerShellVersion = '7.2'
    
        'VMware.VimAutomation.Core',
        @{ModuleName='VMware.PowerCLI'; ModuleVersion='13.0'}
    )
    FunctionsToExport = @('Clear-AnyStackStaleLogs','Get-AnyStackHostLogBundle','Set-AnyStackSyslogServer','Test-AnyStackLogForwarding')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.LogIntelligence')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}




