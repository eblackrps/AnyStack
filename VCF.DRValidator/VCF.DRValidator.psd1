@{
    RootModule = 'VCF.DRValidator.psm1'
    ModuleVersion = '1.6.8'
    GUID = '57327433-fb2f-4506-a6ac-67d48b016bf2'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.DRValidator automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VCF.PowerCLI'; ModuleVersion='9.0'}
    )
    FunctionsToExport = @('Export-AnyStackDRReadinessReport','Repair-AnyStackDisasterRecoveryReadiness','Start-AnyStackVmBackup','Test-AnyStackDisasterRecoveryReadiness')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.DRValidator')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







 










