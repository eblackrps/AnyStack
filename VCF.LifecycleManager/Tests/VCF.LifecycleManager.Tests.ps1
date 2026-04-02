BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\..\VCF.LifecycleManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.LifecycleManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.LifecycleManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackHardwareCompatibility'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackClusterImage'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Start-AnyStackHostRemediation'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackCompliance'] | Should -Not -BeNullOrEmpty
        }
    }

    Context "Export-AnyStackHardwareCompatibility" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackHardwareCompatibility' | Should -Not -BeNullOrEmpty
        }
    }

    Context "Get-AnyStackClusterImage" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackClusterImage' | Should -Not -BeNullOrEmpty
        }
    }

    Context "Start-AnyStackHostRemediation" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Start-AnyStackHostRemediation' | Should -Not -BeNullOrEmpty
        }
    }

    Context "Test-AnyStackCompliance" {
        BeforeEach {
            $script:complianceTaskRequests = 0
            $script:taskWaitRequests = 0

            $script:profileManager = [PSCustomObject]@{}
            $script:profileManager | Add-Member -MemberType ScriptMethod -Name CheckCompliance_Task -Value {
                param($hostRefs)
                [PSCustomObject]@{ Value = 'task-003' }
            }

            Mock Get-AnyStackConnection -ModuleName VCF.LifecycleManager {
                [PSCustomObject]@{
                    Name          = 'ResolvedVC'
                    IsConnected   = $true
                    ExtensionData = [PSCustomObject]@{
                        Content = [PSCustomObject]@{
                            HostProfileManager = 'profile-2'
                        }
                    }
                }
            }

            Mock Get-AnyStackHostView -ModuleName VCF.LifecycleManager {
                @(
                    [PSCustomObject]@{
                        Name  = 'esx02'
                        MoRef = [PSCustomObject]@{ Value = 'host-2' }
                    }
                )
            }

            Mock Invoke-AnyStackWithRetry -ModuleName VCF.LifecycleManager {
                param($ScriptBlock)

                $scriptText = $ScriptBlock.ToString()

                if ($scriptText -like '*HostProfileManager*') {
                    return $script:profileManager
                }

                if ($scriptText -like '*CheckCompliance_Task*') {
                    $script:complianceTaskRequests++
                    return [PSCustomObject]@{ Value = 'task-003' }
                }

                if ($scriptText -like '*Get-Task -Id*') {
                    $script:taskWaitRequests++
                    return $null
                }

                if ($scriptText -like '*.Info.Result*') {
                    return @(
                        [PSCustomObject]@{
                            Entity           = [PSCustomObject]@{ Value = 'host-2' }
                            ComplianceStatus = 'nonCompliant'
                            Failure          = @(
                                [PSCustomObject]@{ Message = 'Firmware baseline mismatch.' }
                            )
                        }
                    )
                }

                throw "Unexpected script block: $scriptText"
            }
        }

        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackCompliance' | Should -Not -BeNullOrEmpty
        }

        It "Should return lifecycle compliance results during normal execution" {
            $result = Test-AnyStackCompliance -Server 'InputVC' -ClusterName 'ClusterA' -Confirm:$false

            $result.Server | Should -Be 'ResolvedVC'
            $result.Host | Should -Be 'esx02'
            $result.ComplianceStatus | Should -Be 'nonCompliant'
            $result.NonCompliantSettings | Should -Be 1
            Assert-MockCalled Get-AnyStackHostView -ModuleName VCF.LifecycleManager -Times 1 -ParameterFilter { $ClusterName -eq 'ClusterA' }
            $script:complianceTaskRequests | Should -Be 1
            $script:taskWaitRequests | Should -Be 1
        }

        It "Should not queue a lifecycle compliance task when -WhatIf is used" {
            $result = @(Test-AnyStackCompliance -Server 'InputVC' -ClusterName 'ClusterA' -WhatIf)

            $result.Count | Should -Be 0
            $script:complianceTaskRequests | Should -Be 0
            $script:taskWaitRequests | Should -Be 0
        }
    }
}
