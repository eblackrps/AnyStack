BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\..\VCF.SnapshotManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.SnapshotManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.SnapshotManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Clear-AnyStackOrphanedSnapshots'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Optimize-AnyStackSnapshots'] | Should -Not -BeNullOrEmpty
        }
    }

    Context "Clear-AnyStackOrphanedSnapshots" {
        BeforeEach {
            $script:oldSnapshot = [PSCustomObject]@{
                Name              = 'snap-old'
                CreateTime        = (Get-Date).AddDays(-30)
                Snapshot          = [PSCustomObject]@{ Value = 'snapshot-1' }
                ChildSnapshotList = @()
            }

            Mock Get-AnyStackConnection -ModuleName VCF.SnapshotManager {
                [PSCustomObject]@{
                    Name        = 'ResolvedVC'
                    IsConnected = $true
                }
            }

            Mock Invoke-AnyStackWithRetry -ModuleName VCF.SnapshotManager {
                param($ScriptBlock)

                $scriptText = $ScriptBlock.ToString()

                if ($scriptText -like '*ViewType ClusterComputeResource*') {
                    return [PSCustomObject]@{
                        Name = 'ClusterA'
                        Host = @([PSCustomObject]@{ Value = 'host-1' })
                    }
                }

                if ($scriptText -like '*ViewType VirtualMachine*') {
                    return @(
                        [PSCustomObject]@{
                            Name    = 'vm-in-cluster'
                            Runtime = [PSCustomObject]@{
                                Host = [PSCustomObject]@{ Value = 'host-1' }
                            }
                            Snapshot = [PSCustomObject]@{
                                RootSnapshotList = @($script:oldSnapshot)
                            }
                        },
                        [PSCustomObject]@{
                            Name    = 'vm-out-of-cluster'
                            Runtime = [PSCustomObject]@{
                                Host = [PSCustomObject]@{ Value = 'host-2' }
                            }
                            Snapshot = [PSCustomObject]@{
                                RootSnapshotList = @($script:oldSnapshot)
                            }
                        }
                    )
                }

                if ($scriptText -like '*Id $snap.Snapshot*') {
                    $snapshotView = [PSCustomObject]@{}
                    $snapshotView | Add-Member -MemberType ScriptMethod -Name RemoveSnapshot_Task -Value {
                        param($removeChildren, $consolidate)
                        [PSCustomObject]@{ Value = 'task-123' }
                    }
                    return $snapshotView
                }

                if ($scriptText -like '*RemoveSnapshot_Task*') {
                    return [PSCustomObject]@{ Value = 'task-123' }
                }

                return $null
            }
        }

        It "Should exist as an exported function" {
            Get-Command -Name 'Clear-AnyStackOrphanedSnapshots' | Should -Not -BeNullOrEmpty
        }

        It "Should limit cleanup to the requested cluster and use the snapshot task" {
            $result = Clear-AnyStackOrphanedSnapshots -Server 'InputVC' -ClusterName 'ClusterA' -AgeDays 7 -Confirm:$false

            @($result).Count | Should -Be 1
            $result.Server | Should -Be 'ResolvedVC'
            $result.VmName | Should -Be 'vm-in-cluster'
            $result.SnapshotName | Should -Be 'snap-old'
            $result.TaskId | Should -Be 'task-123'
        }
    }

    Context "Optimize-AnyStackSnapshots" {
        BeforeEach {
            $script:consolidationRequests = 0

            Mock Get-AnyStackConnection -ModuleName VCF.SnapshotManager {
                [PSCustomObject]@{
                    Name        = 'ResolvedVC'
                    IsConnected = $true
                }
            }

            Mock Get-AnyStackVirtualMachineView -ModuleName VCF.SnapshotManager {
                @(
                    [PSCustomObject]@{
                        Name    = 'vm-needs-consolidation'
                        Runtime = [PSCustomObject]@{
                            ConsolidationNeeded = $true
                        }
                    },
                    [PSCustomObject]@{
                        Name    = 'vm-already-clean'
                        Runtime = [PSCustomObject]@{
                            ConsolidationNeeded = $false
                        }
                    }
                )
            }

            Mock Invoke-AnyStackWithRetry -ModuleName VCF.SnapshotManager {
                param($ScriptBlock)

                if ($ScriptBlock.ToString() -like '*ConsolidateVMDisks_Task*') {
                    $script:consolidationRequests++
                    return [PSCustomObject]@{ Value = 'task-456' }
                }

                throw "Unexpected script block: $($ScriptBlock.ToString())"
            }
        }

        It "Should exist as an exported function" {
            Get-Command -Name 'Optimize-AnyStackSnapshots' | Should -Not -BeNullOrEmpty
        }

        It "Should queue consolidation only for VMs that need it" {
            $result = Optimize-AnyStackSnapshots -Server 'InputVC' -ClusterName 'ClusterA' -Confirm:$false

            @($result).Count | Should -Be 1
            $result.Server | Should -Be 'ResolvedVC'
            $result.VmName | Should -Be 'vm-needs-consolidation'
            $result.TaskId | Should -Be 'task-456'
            Assert-MockCalled Get-AnyStackVirtualMachineView -ModuleName VCF.SnapshotManager -Times 1 -ParameterFilter { $ClusterName -eq 'ClusterA' }
            $script:consolidationRequests | Should -Be 1
        }

        It "Should not consolidate disks when -WhatIf is used" {
            $result = @(Optimize-AnyStackSnapshots -Server 'InputVC' -ClusterName 'ClusterA' -WhatIf)

            $result.Count | Should -Be 0
            $script:consolidationRequests | Should -Be 0
        }
    }
}
