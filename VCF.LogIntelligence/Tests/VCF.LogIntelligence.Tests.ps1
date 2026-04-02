BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.LogIntelligence.psd1" -Force -ErrorAction Stop
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
    }
    Context "Get-AnyStackHostLogBundle" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackHostLogBundle' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackSyslogServer" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackSyslogServer' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackLogForwarding" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackLogForwarding' | Should -Not -BeNullOrEmpty
        }
    }
}
