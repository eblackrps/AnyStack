BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\AnyStack.ConfigurationAsCode.psd1" -Force -ErrorAction Stop
}

Describe "AnyStack.ConfigurationAsCode Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'AnyStack.ConfigurationAsCode'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackConfiguration'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Sync-AnyStackConfiguration'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Export-AnyStackConfiguration" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackConfiguration' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Export-AnyStackConfiguration -Server 'MockVC' -OutputPath 'C:\test.json' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Sync-AnyStackConfiguration" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Sync-AnyStackConfiguration' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Sync-AnyStackConfiguration -Server 'MockVC' -ConfigFilePath 'C:\test.json' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
