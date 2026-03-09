BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.ResourceAudit.psd1" -Force -ErrorAction Stop
}

Describe "VCF.ResourceAudit Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.ResourceAudit'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackHostMemoryUsage'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackOrphanedState'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackVmMigrationHistory'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackVmUptime'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Move-AnyStackVmDatastore'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Remove-AnyStackOldTemplates'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Restart-AnyStackVmTools'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackVmResourcePool'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackVmCpuReady'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Update-AnyStackVmHardware'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Update-AnyStackVmTools'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackHostMemoryUsage" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackHostMemoryUsage' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackHostMemoryUsage -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackOrphanedState" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackOrphanedState' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackOrphanedState -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackVmMigrationHistory" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackVmMigrationHistory' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackVmMigrationHistory -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackVmUptime" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackVmUptime' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackVmUptime -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Move-AnyStackVmDatastore" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Move-AnyStackVmDatastore' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Move-AnyStackVmDatastore -Server 'MockVC' -VmName 'vm1' -DestinationDatastore 'ds1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Remove-AnyStackOldTemplates" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Remove-AnyStackOldTemplates' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Remove-AnyStackOldTemplates -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Restart-AnyStackVmTools" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Restart-AnyStackVmTools' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Restart-AnyStackVmTools -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Set-AnyStackVmResourcePool" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackVmResourcePool' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Set-AnyStackVmResourcePool -Server 'MockVC' -VmName 'vm1' -ResourcePoolName 'rp1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackVmCpuReady" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackVmCpuReady' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackVmCpuReady -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Update-AnyStackVmHardware" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Update-AnyStackVmHardware' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Update-AnyStackVmHardware -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Update-AnyStackVmTools" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Update-AnyStackVmTools' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Update-AnyStackVmTools -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
