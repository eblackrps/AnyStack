BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.NetworkManager.psd1" -Force -ErrorAction Stop
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
    }
    Context "New-AnyStackVlan" {
        It "Should exist as an exported function" {
            Get-Command -Name 'New-AnyStackVlan' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackVlanTag" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackVlanTag' | Should -Not -BeNullOrEmpty
        }
    }
}
