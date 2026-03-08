@{
    RootModule = 'VCF.CertificateManager.psm1'
    ModuleVersion = '1.2.0'
    GUID = '48a5e0e4-ef1b-4ec2-badb-2f8e883dc086'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Enterprise module for VCF.CertificateManager automation and management.'
    PowerShellVersion = '7.2'
    
        'VMware.VimAutomation.Core',
        @{ModuleName='VMware.PowerCLI'; ModuleVersion='13.0'}
    )
    FunctionsToExport = @('Test-AnyStackCertificates','Update-AnyStackEsxCertificate','Update-AnyStackVcsCertificate')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.CertificateManager')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}




