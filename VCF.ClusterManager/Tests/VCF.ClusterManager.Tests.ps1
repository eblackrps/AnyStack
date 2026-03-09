BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.ClusterManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.ClusterManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.ClusterManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackClusterReport'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackHostFirmware'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackHostSensors'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['New-AnyStackHostProfile'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackDrsRule'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackHostPowerPolicy'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackVclsRetreatMode'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackVmAffinityRule'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackHaFailover'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackHostNtp'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackProactiveHa'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Export-AnyStackClusterReport" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackClusterReport' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Export-AnyStackClusterReport -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackHostFirmware" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackHostFirmware' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackHostFirmware -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackHostSensors" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackHostSensors' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackHostSensors -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "New-AnyStackHostProfile" {
        It "Should exist as an exported function" {
            Get-Command -Name 'New-AnyStackHostProfile' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { New-AnyStackHostProfile -Server 'MockVC' -HostName 'esxi1' -ProfileName 'prof1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Set-AnyStackDrsRule" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackDrsRule' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Set-AnyStackDrsRule -Server 'MockVC' -ClusterName 'c1' -RuleName 'r1' -VmNames @('vm1') -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Set-AnyStackHostPowerPolicy" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackHostPowerPolicy' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Set-AnyStackHostPowerPolicy -Server 'MockVC' -HostName 'esxi1' -Policy Balanced -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Set-AnyStackVclsRetreatMode" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackVclsRetreatMode' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Set-AnyStackVclsRetreatMode -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Set-AnyStackVmAffinityRule" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackVmAffinityRule' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Set-AnyStackVmAffinityRule -Server 'MockVC' -ClusterName 'c1' -RuleName 'r1' -VmNames @('vm1') -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackHaFailover" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackHaFailover' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackHaFailover -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackHostNtp" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackHostNtp' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackHostNtp -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackProactiveHa" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackProactiveHa' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackProactiveHa -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
