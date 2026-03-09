BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.SddcManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.SddcManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.SddcManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackWorkloadDomain'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackPasswordRotation'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackSddcHealth'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackWorkloadDomain" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackWorkloadDomain' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackWorkloadDomain -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Set-AnyStackPasswordRotation" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackPasswordRotation' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Set-AnyStackPasswordRotation -Server 'MockVC' -DomainName 'fake' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackSddcHealth" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackSddcHealth' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackSddcHealth -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
