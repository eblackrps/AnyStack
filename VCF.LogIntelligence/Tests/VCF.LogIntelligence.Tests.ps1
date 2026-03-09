BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.LogIntelligence.psd1" -Force -ErrorAction Stop
}

Describe "VCF.LogIntelligence Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.LogIntelligence'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Clear-AnyStackStaleLogs'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackHostLogBundle'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackSyslogServer'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackLogForwarding'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Clear-AnyStackStaleLogs" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Clear-AnyStackStaleLogs' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Clear-AnyStackStaleLogs -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackHostLogBundle" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackHostLogBundle' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackHostLogBundle -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Set-AnyStackSyslogServer" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackSyslogServer' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Set-AnyStackSyslogServer -Server 'MockVC' -SyslogServer 'syslog.test' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackLogForwarding" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackLogForwarding' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackLogForwarding -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
