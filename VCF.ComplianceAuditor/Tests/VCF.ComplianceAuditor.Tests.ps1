BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.ComplianceAuditor.psd1" -Force -ErrorAction Stop
}

Describe "VCF.ComplianceAuditor Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.ComplianceAuditor'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackAuditReport'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackNonCompliantHost'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Invoke-AnyStackCisStigAudit'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Repair-AnyStackComplianceDrift'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Export-AnyStackAuditReport" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackAuditReport' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackNonCompliantHost" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackNonCompliantHost' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Invoke-AnyStackCisStigAudit" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Invoke-AnyStackCisStigAudit' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Repair-AnyStackComplianceDrift" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Repair-AnyStackComplianceDrift' | Should -Not -BeNullOrEmpty
        }
    }
}
