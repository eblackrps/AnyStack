BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.LifecycleManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.LifecycleManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.LifecycleManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackHardwareCompatibility'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackClusterImage'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Start-AnyStackHostRemediation'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackCompliance'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Export-AnyStackHardwareCompatibility" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackHardwareCompatibility' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Export-AnyStackHardwareCompatibility -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackClusterImage" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackClusterImage' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackClusterImage -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Start-AnyStackHostRemediation" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Start-AnyStackHostRemediation' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Start-AnyStackHostRemediation -Server 'MockVC' -HostName 'esxi1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackCompliance" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackCompliance' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackCompliance -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
