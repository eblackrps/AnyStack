BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.ComplianceAuditor.psd1" -Force -ErrorAction Stop
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
        It "Should be callable without throwing a syntax error" {
            { Export-AnyStackAuditReport -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackNonCompliantHost" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackNonCompliantHost' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackNonCompliantHost -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Invoke-AnyStackCisStigAudit" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Invoke-AnyStackCisStigAudit' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Invoke-AnyStackCisStigAudit -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Repair-AnyStackComplianceDrift" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Repair-AnyStackComplianceDrift' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Repair-AnyStackComplianceDrift -Server 'MockVC' -HostName 'esxi1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
