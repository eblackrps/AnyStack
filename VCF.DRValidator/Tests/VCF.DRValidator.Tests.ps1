Describe "VCF.DRValidator Unit Tests" {
    BeforeAll {
        $modulePath = Join-Path $PSScriptRoot "..\VCF.DRValidator.psd1"
        Import-Module $modulePath -Force
    }
    
    Context "Private Helper: Get-OldSnapshots" {
        It "Should return true if a snapshot is older than the 24h threshold" {
            $mockSnap = [PSCustomObject]@{
                CreateTime = (Get-Date).AddDays(-2)
                ChildSnapshotList = $null
            }
            $result = Get-OldSnapshots -SnapshotTree @($mockSnap) -OlderThan (Get-Date).AddDays(-1)
            $result | Should Be $true
        }
        
        It "Should return false if no snapshots are older than the threshold" {
            $mockSnap = [PSCustomObject]@{
                CreateTime = (Get-Date).AddHours(-1)
                ChildSnapshotList = $null
            }
            $result = Get-OldSnapshots -SnapshotTree @($mockSnap) -OlderThan (Get-Date).AddDays(-1)
            $result | Should Be $false
        }

        It "Should return true if a nested child snapshot is older than the threshold" {
            $childSnap = [PSCustomObject]@{
                CreateTime = (Get-Date).AddDays(-5)
                ChildSnapshotList = $null
            }
            $mockSnap = [PSCustomObject]@{
                CreateTime = (Get-Date).AddHours(-1)
                ChildSnapshotList = @($childSnap)
            }
            $result = Get-OldSnapshots -SnapshotTree @($mockSnap) -OlderThan (Get-Date).AddDays(-1)
            $result | Should Be $true
        }
    }
}