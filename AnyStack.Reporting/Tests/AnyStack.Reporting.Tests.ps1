BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\AnyStack.Reporting.psd1" -Force -ErrorAction Stop
}

Describe "AnyStack.Reporting Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'AnyStack.Reporting'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackHtmlReport'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Invoke-AnyStackReport'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Export-AnyStackHtmlReport" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackHtmlReport' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Export-AnyStackHtmlReport -Server 'MockVC' -OutputPath 'C:\test.html' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Invoke-AnyStackReport" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Invoke-AnyStackReport' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Invoke-AnyStackReport -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
