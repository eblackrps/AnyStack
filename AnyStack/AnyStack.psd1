@{
    RootModule = 'AnyStack.psm1'
    ModuleVersion = '1.7.7'
    GUID = 'dee0a564-e550-4cce-a916-eac3ebff45c2'
    Author = 'The AnyStack Architect'
    CompanyName = 'AnyStack'
    Copyright = '(c) 2026 AnyStack. All rights reserved.'
    Description = 'Meta-module that installs the complete AnyStack Enterprise Suite for VMware vSphere 8.0 U3 and VCF'
    PowerShellVersion = '7.2'
    RequiredModules = @(
        'VCF.PowerCLI',
        @{ModuleName='AnyStack.ConfigurationAsCode'; ModuleVersion = '1.7.7'},
        @{ModuleName='AnyStack.Reporting'; ModuleVersion = '1.7.7'},
        @{ModuleName='AnyStack.vSphere'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.AlarmManager'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.ApplianceManager'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.AutomationOrchestrator'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.CapacityPlanner'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.CertificateManager'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.ClusterManager'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.ComplianceAuditor'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.ContentManager'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.DRValidator'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.HostEvacuation'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.IdentityManager'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.LifecycleManager'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.LogIntelligence'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.NetworkAudit'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.NetworkManager'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.PerformanceProfiler'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.ResourceAudit'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.SddcManager'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.SecurityAdvanced'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.SecurityBaseline'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.SnapshotManager'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.StorageAdvanced'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.StorageAudit'; ModuleVersion = '1.7.7'},
        @{ModuleName='VCF.TagManager'; ModuleVersion = '1.7.7'}
    )
    FunctionsToExport = @()
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('VMware','vSphere','VCF','Automation')
            ProjectUri = 'https://github.com/eblackrps/AnyStack'
            LicenseUri = 'https://github.com/eblackrps/AnyStack/blob/main/LICENSE'
        }
    }
}

 









