BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\..\VCF.LogIntelligence.psd1" -Force -ErrorAction Stop
}

Describe "VCF.LogIntelligence Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.LogIntelligence'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Clear-AnyStackStaleLogs'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackHostLogBundle'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackSyslogServer'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackLogForwarding'] | Should -Not -BeNullOrEmpty
        }
    }

    Context "Clear-AnyStackStaleLogs" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Clear-AnyStackStaleLogs' | Should -Not -BeNullOrEmpty
        }
    }

    Context "Get-AnyStackHostLogBundle" {
        BeforeEach {
            $script:bundleTaskRequests = 0
            $script:taskWaitRequests = 0

            $script:diagnosticManager = [PSCustomObject]@{}
            $script:diagnosticManager | Add-Member -MemberType ScriptMethod -Name GenerateLogBundles_Task -Value {
                param($includeDefault, $hosts)
                [PSCustomObject]@{ Value = 'task-001' }
            }

            Mock Get-AnyStackConnection -ModuleName VCF.LogIntelligence {
                [PSCustomObject]@{
                    Name          = 'ResolvedVC'
                    IsConnected   = $true
                    ExtensionData = [PSCustomObject]@{
                        Content = [PSCustomObject]@{
                            DiagnosticManager = 'diag-1'
                        }
                    }
                }
            }

            Mock Get-AnyStackHostView -ModuleName VCF.LogIntelligence {
                [PSCustomObject]@{
                    Name  = 'esx01'
                    MoRef = [PSCustomObject]@{ Value = 'host-1' }
                }
            }

            Mock Invoke-AnyStackWithRetry -ModuleName VCF.LogIntelligence {
                param($ScriptBlock)

                $scriptText = $ScriptBlock.ToString()

                if ($scriptText -like '*DiagnosticManager*') {
                    return $script:diagnosticManager
                }

                if ($scriptText -like '*GenerateLogBundles_Task*') {
                    $script:bundleTaskRequests++
                    return [PSCustomObject]@{ Value = 'task-001' }
                }

                if ($scriptText -like '*Get-Task -Id*') {
                    $script:taskWaitRequests++
                    return $null
                }

                throw "Unexpected script block: $scriptText"
            }
            Mock Test-Path -ModuleName VCF.LogIntelligence { $false }
        }

        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackHostLogBundle' | Should -Not -BeNullOrEmpty
        }

        It "Should request and wait for a host log bundle during normal execution" {
            $result = Get-AnyStackHostLogBundle -Server 'InputVC' -HostName 'esx01' -DestinationPath 'C:\temp\logs' -Confirm:$false

            $result.Server | Should -Be 'ResolvedVC'
            $result.Host | Should -Be 'esx01'
            $result.BundleKey | Should -Be 'task-001'
            $script:bundleTaskRequests | Should -Be 1
            $script:taskWaitRequests | Should -Be 1
        }

        It "Should not queue a host log bundle when -WhatIf is used" {
            $result = Get-AnyStackHostLogBundle -Server 'InputVC' -HostName 'esx01' -DestinationPath 'C:\temp\logs' -WhatIf

            $result.Server | Should -Be 'ResolvedVC'
            $result.BundleKey | Should -BeNullOrEmpty
            $script:bundleTaskRequests | Should -Be 0
            $script:taskWaitRequests | Should -Be 0
        }
    }

    Context "Set-AnyStackSyslogServer" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackSyslogServer' | Should -Not -BeNullOrEmpty
        }
    }

    Context "Test-AnyStackLogForwarding" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackLogForwarding' | Should -Not -BeNullOrEmpty
        }
    }
}
