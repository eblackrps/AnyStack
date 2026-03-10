BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.SecurityAdvanced.psd1" -Force -ErrorAction Stop
}

Describe "VCF.SecurityAdvanced Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.SecurityAdvanced'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Add-AnyStackNativeKeyProvider'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Disable-AnyStackHostSsh'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Enable-AnyStackHostSsh'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackEsxiLockdownMode'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Add-AnyStackNativeKeyProvider" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Add-AnyStackNativeKeyProvider' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Add-AnyStackNativeKeyProvider -Server 'MockVC' -ProviderName 'TestKP' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Disable-AnyStackHostSsh" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Disable-AnyStackHostSsh' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Disable-AnyStackHostSsh -Server 'MockVC' -HostName 'esxi1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Enable-AnyStackHostSsh" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Enable-AnyStackHostSsh' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Enable-AnyStackHostSsh -Server 'MockVC' -HostName 'esxi1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Set-AnyStackEsxiLockdownMode" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackEsxiLockdownMode' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Set-AnyStackEsxiLockdownMode -Server 'MockVC' -HostName 'esxi1' -Mode 'lockdownNormal' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
