BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\VCF.ClusterManager.psd1" -Force
}

Describe "VCF.ClusterManager Suite" {
    Context "Export-AnyStackClusterReport" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.ClusterManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.ClusterManager"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.ClusterManager"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"; DrsEnabled=$true; HaEnabled=$true; MoRef=[PSCustomObject]@{Value="domain-c1"}} } -ModuleName "VCF.ClusterManager"
            $result = Export-AnyStackClusterReport -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackHostFirmware" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.ClusterManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.ClusterManager"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.ClusterManager"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"; DrsEnabled=$true; HaEnabled=$true; MoRef=[PSCustomObject]@{Value="domain-c1"}} } -ModuleName "VCF.ClusterManager"
            $result = Get-AnyStackHostFirmware -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackHostSensors" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.ClusterManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.ClusterManager"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.ClusterManager"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"; DrsEnabled=$true; HaEnabled=$true; MoRef=[PSCustomObject]@{Value="domain-c1"}} } -ModuleName "VCF.ClusterManager"
            $result = Get-AnyStackHostSensors -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "New-AnyStackHostProfile" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.ClusterManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.ClusterManager"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.ClusterManager"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"; DrsEnabled=$true; HaEnabled=$true; MoRef=[PSCustomObject]@{Value="domain-c1"}} } -ModuleName "VCF.ClusterManager"
            $result = New-AnyStackHostProfile -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackDrsRule" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.ClusterManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.ClusterManager"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.ClusterManager"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"; DrsEnabled=$true; HaEnabled=$true; MoRef=[PSCustomObject]@{Value="domain-c1"}} } -ModuleName "VCF.ClusterManager"
            $result = Set-AnyStackDrsRule -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackHostPowerPolicy" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.ClusterManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.ClusterManager"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.ClusterManager"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"; DrsEnabled=$true; HaEnabled=$true; MoRef=[PSCustomObject]@{Value="domain-c1"}} } -ModuleName "VCF.ClusterManager"
            $result = Set-AnyStackHostPowerPolicy -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackVclsRetreatMode" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.ClusterManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.ClusterManager"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.ClusterManager"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"; DrsEnabled=$true; HaEnabled=$true; MoRef=[PSCustomObject]@{Value="domain-c1"}} } -ModuleName "VCF.ClusterManager"
            $result = Set-AnyStackVclsRetreatMode -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackVmAffinityRule" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.ClusterManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.ClusterManager"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.ClusterManager"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"; DrsEnabled=$true; HaEnabled=$true; MoRef=[PSCustomObject]@{Value="domain-c1"}} } -ModuleName "VCF.ClusterManager"
            $result = Set-AnyStackVmAffinityRule -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackHaFailover" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.ClusterManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.ClusterManager"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.ClusterManager"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"; DrsEnabled=$true; HaEnabled=$true; MoRef=[PSCustomObject]@{Value="domain-c1"}} } -ModuleName "VCF.ClusterManager"
            $result = Test-AnyStackHaFailover -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackHostNtp" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.ClusterManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.ClusterManager"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.ClusterManager"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"; DrsEnabled=$true; HaEnabled=$true; MoRef=[PSCustomObject]@{Value="domain-c1"}} } -ModuleName "VCF.ClusterManager"
            $result = Test-AnyStackHostNtp -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackProactiveHa" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.ClusterManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.ClusterManager"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.ClusterManager"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"; DrsEnabled=$true; HaEnabled=$true; MoRef=[PSCustomObject]@{Value="domain-c1"}} } -ModuleName "VCF.ClusterManager"
            $result = Test-AnyStackProactiveHa -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
}
 
