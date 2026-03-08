BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\VCF.CapacityPlanner.psd1" -Force
}

Describe "VCF.CapacityPlanner Suite" {
    Context "Export-AnyStackCapacityForecast" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.CapacityPlanner"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.CapacityPlanner"
            Mock Get-View { return @([PSCustomObject]@{Name='vsanDatastore'; MoRef=[PSCustomObject]@{Value='datastore-1'}; Summary=[PSCustomObject]@{FreeSpace=536870912000; Capacity=2199023255552; Accessible=$true; Type='vsan'}}) } -ModuleName "VCF.CapacityPlanner"
            Mock Get-Datastore { return [PSCustomObject]@{Name="vsanDatastore"; Id="datastore-1"} } -ModuleName "VCF.CapacityPlanner"
            Mock Get-Stat { return @([PSCustomObject]@{Value=102400; Timestamp=(Get-Date).AddDays(-7)}; [PSCustomObject]@{Value=153600; Timestamp=(Get-Date)}) } -ModuleName "VCF.CapacityPlanner"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"} } -ModuleName "VCF.CapacityPlanner"
            $result = Export-AnyStackCapacityForecast -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackDatastoreGrowthRate" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.CapacityPlanner"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.CapacityPlanner"
            Mock Get-View { return @([PSCustomObject]@{Name='vsanDatastore'; MoRef=[PSCustomObject]@{Value='datastore-1'}; Summary=[PSCustomObject]@{FreeSpace=536870912000; Capacity=2199023255552; Accessible=$true; Type='vsan'}}) } -ModuleName "VCF.CapacityPlanner"
            Mock Get-Datastore { return [PSCustomObject]@{Name="vsanDatastore"; Id="datastore-1"} } -ModuleName "VCF.CapacityPlanner"
            Mock Get-Stat { return @([PSCustomObject]@{Value=102400; Timestamp=(Get-Date).AddDays(-7)}; [PSCustomObject]@{Value=153600; Timestamp=(Get-Date)}) } -ModuleName "VCF.CapacityPlanner"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"} } -ModuleName "VCF.CapacityPlanner"
            $result = Get-AnyStackDatastoreGrowthRate -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackZombieVm" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.CapacityPlanner"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.CapacityPlanner"
            Mock Get-View { return @([PSCustomObject]@{Name='vsanDatastore'; MoRef=[PSCustomObject]@{Value='datastore-1'}; Summary=[PSCustomObject]@{FreeSpace=536870912000; Capacity=2199023255552; Accessible=$true; Type='vsan'}}) } -ModuleName "VCF.CapacityPlanner"
            Mock Get-Datastore { return [PSCustomObject]@{Name="vsanDatastore"; Id="datastore-1"} } -ModuleName "VCF.CapacityPlanner"
            Mock Get-Stat { return @([PSCustomObject]@{Value=102400; Timestamp=(Get-Date).AddDays(-7)}; [PSCustomObject]@{Value=153600; Timestamp=(Get-Date)}) } -ModuleName "VCF.CapacityPlanner"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"} } -ModuleName "VCF.CapacityPlanner"
            $result = Get-AnyStackZombieVm -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackRightSizeRecommendation" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.CapacityPlanner"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.CapacityPlanner"
            Mock Get-View { return @([PSCustomObject]@{Name='vsanDatastore'; MoRef=[PSCustomObject]@{Value='datastore-1'}; Summary=[PSCustomObject]@{FreeSpace=536870912000; Capacity=2199023255552; Accessible=$true; Type='vsan'}}) } -ModuleName "VCF.CapacityPlanner"
            Mock Get-Datastore { return [PSCustomObject]@{Name="vsanDatastore"; Id="datastore-1"} } -ModuleName "VCF.CapacityPlanner"
            Mock Get-Stat { return @([PSCustomObject]@{Value=102400; Timestamp=(Get-Date).AddDays(-7)}; [PSCustomObject]@{Value=153600; Timestamp=(Get-Date)}) } -ModuleName "VCF.CapacityPlanner"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"} } -ModuleName "VCF.CapacityPlanner"
            $result = Set-AnyStackRightSizeRecommendation -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
}
