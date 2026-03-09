@{
    RootModule = 'VCF.AutomationOrchestrator.psm1'
    ModuleVersion = '1.6.4'
    GUID = 'ee8c3b8f-e85f-40b6-b0fe-1040f9616353'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.AutomationOrchestrator automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VCF.PowerCLI'; ModuleVersion='9.0'}
    )
    FunctionsToExport = @('Get-AnyStackFailedScheduledTask','New-AnyStackScheduledSnapshot','Set-AnyStackEventWebhook','Sync-AnyStackAutomationScripts')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.AutomationOrchestrator')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







 






