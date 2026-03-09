BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.HostEvacuation.psd1" -Force -ErrorAction Stop
}

Describe "VCF.HostEvacuation Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.HostEvacuation'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Start-AnyStackHostEvacuation'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Stop-AnyStackHostEvacuation'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Start-AnyStackHostEvacuation" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Start-AnyStackHostEvacuation' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Start-AnyStackHostEvacuation -Server 'MockVC' -HostName 'esxi1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Stop-AnyStackHostEvacuation" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Stop-AnyStackHostEvacuation' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Stop-AnyStackHostEvacuation -Server 'MockVC' -HostName 'esxi1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
