BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\VCF.StorageAudit.psd1" -Force
}

Describe "VCF.StorageAudit Suite" {
    Context "Get-AnyStackDatastoreIops" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.StorageAudit"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.StorageAudit"
            Mock Get-View { return @([PSCustomObject]@{Name='vsanDatastore'; MoRef=[PSCustomObject]@{Value='datastore-1'}; Summary=[PSCustomObject]@{FreeSpace=536870912000; Capacity=2199023255552; Accessible=$true; Type='vsan'}}) } -ModuleName "VCF.StorageAudit"
            $result = Get-AnyStackDatastoreIops -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackDatastoreLatency" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.StorageAudit"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.StorageAudit"
            Mock Get-View { return @([PSCustomObject]@{Name='vsanDatastore'; MoRef=[PSCustomObject]@{Value='datastore-1'}; Summary=[PSCustomObject]@{FreeSpace=536870912000; Capacity=2199023255552; Accessible=$true; Type='vsan'}}) } -ModuleName "VCF.StorageAudit"
            $result = Get-AnyStackDatastoreLatency -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackOrphanedVmdk" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.StorageAudit"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.StorageAudit"
            Mock Get-View { return @([PSCustomObject]@{Name='vsanDatastore'; MoRef=[PSCustomObject]@{Value='datastore-1'}; Summary=[PSCustomObject]@{FreeSpace=536870912000; Capacity=2199023255552; Accessible=$true; Type='vsan'}}) } -ModuleName "VCF.StorageAudit"
            $result = Get-AnyStackOrphanedVmdk -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackVmDiskLatency" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.StorageAudit"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.StorageAudit"
            Mock Get-View { return @([PSCustomObject]@{Name='vsanDatastore'; MoRef=[PSCustomObject]@{Value='datastore-1'}; Summary=[PSCustomObject]@{FreeSpace=536870912000; Capacity=2199023255552; Accessible=$true; Type='vsan'}}) } -ModuleName "VCF.StorageAudit"
            $result = Get-AnyStackVmDiskLatency -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackVsanHealth" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.StorageAudit"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.StorageAudit"
            Mock Get-View { return @([PSCustomObject]@{Name='vsanDatastore'; MoRef=[PSCustomObject]@{Value='datastore-1'}; Summary=[PSCustomObject]@{FreeSpace=536870912000; Capacity=2199023255552; Accessible=$true; Type='vsan'}}) } -ModuleName "VCF.StorageAudit"
            $result = Get-AnyStackVsanHealth -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Invoke-AnyStackDatastoreUnmount" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.StorageAudit"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.StorageAudit"
            Mock Get-View { return @([PSCustomObject]@{Name='vsanDatastore'; MoRef=[PSCustomObject]@{Value='datastore-1'}; Summary=[PSCustomObject]@{FreeSpace=536870912000; Capacity=2199023255552; Accessible=$true; Type='vsan'}}) } -ModuleName "VCF.StorageAudit"
            $result = Invoke-AnyStackDatastoreUnmount -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackDatastorePathMultipathing" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.StorageAudit"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.StorageAudit"
            Mock Get-View { return @([PSCustomObject]@{Name='vsanDatastore'; MoRef=[PSCustomObject]@{Value='datastore-1'}; Summary=[PSCustomObject]@{FreeSpace=536870912000; Capacity=2199023255552; Accessible=$true; Type='vsan'}}) } -ModuleName "VCF.StorageAudit"
            $result = Test-AnyStackDatastorePathMultipathing -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackStorageConfiguration" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.StorageAudit"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.StorageAudit"
            Mock Get-View { return @([PSCustomObject]@{Name='vsanDatastore'; MoRef=[PSCustomObject]@{Value='datastore-1'}; Summary=[PSCustomObject]@{FreeSpace=536870912000; Capacity=2199023255552; Accessible=$true; Type='vsan'}}) } -ModuleName "VCF.StorageAudit"
            $result = Test-AnyStackStorageConfiguration -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackVsanCapacity" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.StorageAudit"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.StorageAudit"
            Mock Get-View { return @([PSCustomObject]@{Name='vsanDatastore'; MoRef=[PSCustomObject]@{Value='datastore-1'}; Summary=[PSCustomObject]@{FreeSpace=536870912000; Capacity=2199023255552; Accessible=$true; Type='vsan'}}) } -ModuleName "VCF.StorageAudit"
            $result = Test-AnyStackVsanCapacity -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
}
 
