BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.IdentityManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.IdentityManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.IdentityManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackAccessMatrix'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackGlobalPermission'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['New-AnyStackCustomRole'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackSsoConfiguration'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Export-AnyStackAccessMatrix" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackAccessMatrix' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Export-AnyStackAccessMatrix -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackGlobalPermission" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackGlobalPermission' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackGlobalPermission -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "New-AnyStackCustomRole" {
        It "Should exist as an exported function" {
            Get-Command -Name 'New-AnyStackCustomRole' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { New-AnyStackCustomRole -Server 'MockVC' -RoleName 'TestRole' -Privileges @('System.Read') -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackSsoConfiguration" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackSsoConfiguration' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackSsoConfiguration -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
