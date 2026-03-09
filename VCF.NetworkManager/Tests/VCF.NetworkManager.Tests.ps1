BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.NetworkManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.NetworkManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.NetworkManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackDistributedPortgroup'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['New-AnyStackVlan'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackVlanTag'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackDistributedPortgroup" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackDistributedPortgroup' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackDistributedPortgroup -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "New-AnyStackVlan" {
        It "Should exist as an exported function" {
            Get-Command -Name 'New-AnyStackVlan' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { New-AnyStackVlan -Server 'MockVC' -VlanId 100 -Name 'TestVlan' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Set-AnyStackVlanTag" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackVlanTag' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Set-AnyStackVlanTag -Server 'MockVC' -PortgroupName 'pg1' -VlanId 100 -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
