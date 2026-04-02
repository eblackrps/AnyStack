@{
    RootModule = 'VCF.ComplianceAuditor.psm1'
    ModuleVersion = '1.7.6'
    GUID = 'c93bd47c-49fb-4ec2-afd6-8e8b24df8f7d'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.ComplianceAuditor automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VCF.PowerCLI'; ModuleVersion='9.0'}
        @{ModuleName='AnyStack.vSphere'; ModuleVersion='1.7.6'}
    )
    FunctionsToExport = @('Export-AnyStackAuditReport','Get-AnyStackNonCompliantHost','Invoke-AnyStackCisStigAudit','Repair-AnyStackComplianceDrift')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.ComplianceAuditor')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}







 
