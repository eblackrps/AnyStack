BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.SecurityBaseline.psd1" -Force -ErrorAction Stop
}

Describe "VCF.SecurityBaseline Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.SecurityBaseline'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackEsxiLockdownMode'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackAdIntegration'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackHostSyslog'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackSecurityBaseline'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackEsxiLockdownMode" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackEsxiLockdownMode' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackEsxiLockdownMode -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackAdIntegration" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackAdIntegration' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackAdIntegration -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackHostSyslog" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackHostSyslog' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackHostSyslog -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackSecurityBaseline" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackSecurityBaseline' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackSecurityBaseline -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
