@{
    RootModule = 'VCF.SnapshotManager.psm1'
    ModuleVersion = '1.7.9'
    GUID = '6787a7ee-62f0-4167-9326-1f816aa6de6b'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 The AnyStack Architect. Released under the MIT License.'
    Description = 'Enterprise module for VCF.SnapshotManager automation and management.'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        @{ModuleName='VCF.PowerCLI'; ModuleVersion='9.0'}
        @{ModuleName='AnyStack.vSphere'; ModuleVersion='1.7.9'}
    )
    FunctionsToExport = @('Clear-AnyStackOrphanedSnapshots','Optimize-AnyStackSnapshots')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation', 'VCF.SnapshotManager')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}








 

