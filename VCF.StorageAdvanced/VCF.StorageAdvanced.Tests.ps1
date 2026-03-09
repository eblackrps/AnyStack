BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.StorageAdvanced.psd1" -Force -ErrorAction Stop
}

Describe "VCF.StorageAdvanced Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.StorageAdvanced'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Add-AnyStackNvmeInterface'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackNvmeDevice'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Remove-AnyStackNvmeInterface'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackNvmeQueueDepth'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackNvmeConnectivity'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Add-AnyStackNvmeInterface" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Add-AnyStackNvmeInterface' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Add-AnyStackNvmeInterface -Server 'MockVC' -HostName 'esxi1' -TargetAddress '192.168.1.100' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackNvmeDevice" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackNvmeDevice' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackNvmeDevice -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Remove-AnyStackNvmeInterface" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Remove-AnyStackNvmeInterface' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Remove-AnyStackNvmeInterface -Server 'MockVC' -HostName 'esxi1' -AdapterName 'vmhba64' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Set-AnyStackNvmeQueueDepth" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackNvmeQueueDepth' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Set-AnyStackNvmeQueueDepth -Server 'MockVC' -HostName 'esxi1' -DeviceName 'naa.stub' -QueueDepth 32 -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackNvmeConnectivity" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackNvmeConnectivity' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackNvmeConnectivity -Server 'MockVC' -HostName 'esxi1' -TargetAddress '192.168.1.100' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
