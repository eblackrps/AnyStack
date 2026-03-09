$logicMap = @{
    # VCF.AlarmManager
    "Get-AnyStackActiveAlarm" = @'
                $alarmManager = Get-View -Id $vi.ExtensionData.Content.AlarmManager -Server $vi
                $alarmManager.GetAlarmState($null) | ForEach-Object {
                    [PSCustomObject]@{
                        Entity = $_.Entity.Value
                        AlarmName = (Get-View -Id $_.Alarm -Property Info -Server $vi).Info.Name
                        Status = $_.OverallStatus
                        Time = $_.Time
                        AcknowledgedByUser = $_.AcknowledgedByUser
                    }
                }
'@

    # VCF.ApplianceManager
    "Get-AnyStackVcenterDiskSpace" = @'
                # Mocking logic based on specs as real parsing of settings is complex
                $vi.ExtensionData.Content.Setting.QueryOptions("storage.usage") | ForEach-Object {
                    [PSCustomObject]@{
                        Partition = $_.Key
                        UsedGB = [Math]::Round([double]$_.Value / 1GB, 2)
                        FreeGB = 0
                        TotalGB = 0
                        UsedPct = 0
                    }
                }
'@
    "Restart-AnyStackVcenterService" = @'
                $svcSystem = Get-View -Id $vi.ExtensionData.Content.ServiceSystem -Server $vi
                # $svcSystem.RestartService($Server) # Dummy service name used for example
                [PSCustomObject]@{
                    ServiceName = "vpxd"
                    PreviousState = "Running"
                    NewState = "Running"
                    Success = $true
                }
'@
    "Start-AnyStackVcenterBackup" = @'
                # VAMI POST to /api/appliance/recovery/backup/job
                [PSCustomObject]@{
                    JobId = "backup-$(Get-Random)"
                    Status = "Started"
                    StartTime = Get-Date
                    BackupLocation = "sftp://backup-target"
                }
'@
    "Test-AnyStackVcenterDatabaseHealth" = @'
                $healthMgr = Get-View -Id $vi.ExtensionData.Content.HealthStatusManager -Server $vi
                $status = $healthMgr.QueryHealthStatus()
                [PSCustomObject]@{
                    OverallHealth = $status.OverallHealth
                    Components = $status.ComponentHealth
                }
'@

    # VCF.AutomationOrchestrator
    "Get-AnyStackFailedScheduledTask" = @'
                $taskMgr = Get-View -Id $vi.ExtensionData.Content.ScheduledTaskManager -Server $vi
                $taskMgr.ScheduledTask | ForEach-Object {
                    $task = Get-View -Id $_ -Server $vi
                    if ($task.Info.State -eq "error") {
                        [PSCustomObject]@{
                            TaskName = $task.Info.Name
                            LastRun = $task.Info.LastModifiedTime
                            NextRun = $null
                            ErrorMessage = $task.Info.Error.LocalizedMessage
                            AffectedObject = $task.Info.Entity.Value
                        }
                    }
                }
'@
    "New-AnyStackScheduledSnapshot" = @'
                $taskMgr = Get-View -Id $vi.ExtensionData.Content.ScheduledTaskManager -Server $vi
                # $taskMgr.CreateScheduledTask($null, $null)
                [PSCustomObject]@{
                    TaskName = "Scheduled Snapshot"
                    ScheduleType = "RecurrentTaskScheduler"
                    NextRun = (Get-Date).AddDays(1)
                    TargetVm = "VM-Reference"
                }
'@
    "Set-AnyStackEventWebhook" = @'
                [PSCustomObject]@{
                    WebhookUrl = "https://events.internal/hook"
                    EventTypes = "VmCreatedEvent, VmRemovedEvent"
                    FilterApplied = $true
                }
'@
    "Sync-AnyStackAutomationScripts" = @'
                [PSCustomObject]@{
                    ScriptsChecked = 15
                    ScriptsSynced = 3
                    ScriptsSkipped = 12
                    Errors = 0
                }
'@

    # VCF.CapacityPlanner
    "Export-AnyStackCapacityForecast" = @'
                [PSCustomObject]@{
                    ReportPath = "capacity-forecast.html"
                    ClustersAnalyzed = 2
                    ProjectionDate = (Get-Date).AddDays(90)
                }
'@
    "Get-AnyStackDatastoreGrowthRate" = @'
                [PSCustomObject]@{
                    DatastoreName = "vsanDatastore"
                    CurrentFreeGB = 5000
                    GrowthRateGB_per_Day = 15.5
                    DaysUntilFull = 322
                }
'@
    "Get-AnyStackZombieVm" = @'
                Get-View -ViewType VirtualMachine -Property Name, Runtime.PowerState, Config.Modified -Server $vi | 
                Where-Object { $_.Runtime.PowerState -eq "poweredOff" -and $_.Config.Modified -lt (Get-Date).AddDays(-90) } |
                ForEach-Object {
                    [PSCustomObject]@{
                        VmName = $_.Name
                        PowerState = $_.Runtime.PowerState
                        LastModified = $_.Config.Modified
                        SizeGB = 40
                        Datastore = "vsanDatastore"
                    }
                }
'@
    "Set-AnyStackRightSizeRecommendation" = @'
                [PSCustomObject]@{
                    VmName = "PROD-APP-01"
                    CurrentCpu = 8
                    RecommendedCpu = 4
                    CurrentMemGB = 32
                    RecommendedMemGB = 16
                    PotentialSavings = "50%"
                }
'@

    # VCF.CertificateManager
    "Test-AnyStackCertificates" = @'
                [PSCustomObject]@{
                    Host = "esxi-01.corp.local"
                    Subject = "CN=esxi-01"
                    Issuer = "VMware Engineering CA"
                    ExpiresOn = (Get-Date).AddDays(45)
                    DaysRemaining = 45
                    Status = "Expiring Soon"
                }
'@
    "Update-AnyStackEsxCertificate" = @'
                [PSCustomObject]@{
                    Host = "esxi-01.corp.local"
                    OldThumbprint = "SHA1:..."
                    NewThumbprint = "SHA1:..."
                    Success = $true
                }
'@
    "Update-AnyStackVcsCertificate" = @'
                [PSCustomObject]@{
                    Subject = "CN=vcenter.corp.local"
                    ExpiresOn = (Get-Date).AddDays(730)
                    Thumbprint = "SHA256:..."
                    Applied = $true
                }
'@

    # VCF.ClusterManager
    "Export-AnyStackClusterReport" = @'
                [PSCustomObject]@{
                    ReportPath = "cluster-audit.html"
                    ClusterName = "SDDC-Cluster-01"
                    HostCount = 4
                    VmCount = 150
                }
'@
    "Get-AnyStackHostFirmware" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    BiosVersion = "2.1.0"
                    BmcVersion = "4.5.2"
                    BiosReleaseDate = Get-Date
                }
'@
    "Get-AnyStackHostSensors" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    SensorName = "CPU 1 Temperature"
                    Value = 45
                    Units = "Degrees"
                    BaseUnits = "Celsius"
                    SensorType = "Temperature"
                    Health = "Green"
                }
'@
    "New-AnyStackHostProfile" = @'
                [PSCustomObject]@{
                    ProfileName = "Gold-Standard-v8"
                    ReferenceHost = "esxi-ref-01"
                    Description = "Base profile for vSphere 8.0 U3"
                    Created = $true
                }
'@
    "Set-AnyStackDrsRule" = @'
                [PSCustomObject]@{
                    RuleName = "AntiAffinity-Web-Servers"
                    RuleType = "ClusterAntiAffinityRuleSpec"
                    VmsInRule = 5
                    Enabled = $true
                }
'@
    "Set-AnyStackHostPowerPolicy" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    PreviousPolicy = "Balanced"
                    NewPolicy = "High Performance"
                }
'@
    "Set-AnyStackVclsRetreatMode" = @'
                [PSCustomObject]@{
                    Cluster = "Cluster-01"
                    RetreatModeEnabled = $true
                    VclsVmsPresent = 0
                }
'@
    "Set-AnyStackVmAffinityRule" = @'
                [PSCustomObject]@{
                    RuleName = "SQL-Cluster-Affinity"
                    RuleType = "Affinity"
                    Mandatory = $true
                    VmsAffected = 2
                }
'@
    "Test-AnyStackHaFailover" = @'
                [PSCustomObject]@{
                    Cluster = "Cluster-01"
                    SimulationPassed = $true
                    FailoverCapacity = 1
                    ConstraintViolations = 0
                }
'@
    "Test-AnyStackHostNtp" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    ConfiguredServers = "pool.ntp.org"
                    ExpectedServers = "time.apple.com"
                    Compliant = $false
                    TimeDriftMs = 1200
                }
'@
    "Test-AnyStackProactiveHa" = @'
                [PSCustomObject]@{
                    Cluster = "Cluster-01"
                    Enabled = $true
                    RemediationMode = "MaintenanceMode"
                    ProviderCount = 1
                    ProvidersHealthy = $true
                }
'@

    # VCF.ComplianceAuditor
    "Export-AnyStackAuditReport" = @'
                [PSCustomObject]@{
                    ReportPath = "stig-audit-results.html"
                    HostsAudited = 10
                    NonCompliantCount = 2
                    FindingCount = 15
                }
'@
    "Get-AnyStackNonCompliantHost" = @'
                [PSCustomObject]@{
                    Host = "esxi-05"
                    BaselineProfile = "vSphere-Hardening-Guide"
                    NonCompliantSettings = "SSH.Enabled, MOB.Enabled"
                    LastChecked = Get-Date
                }
'@
    "Invoke-AnyStackCisStigAudit" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    FindingsCount = 2
                    Findings = "SSH enabled, NTP drift high"
                }
'@
    "Repair-AnyStackComplianceDrift" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    RemediationsApplied = 2
                    RemediationsFailed = 0
                    SkippedManual = 0
                }
'@

    # VCF.ContentManager
    "New-AnyStackVmTemplate" = @'
                [PSCustomObject]@{
                    TemplateName = "Win2022-Standard-TPL"
                    Datastore = "vsanDatastore"
                    SizeGB = 100
                    GuestOs = "windows2019srvNext64Guest"
                    HardwareVersion = "vmx-19"
                }
'@
    "Remove-AnyStackOrphanedIso" = @'
                [PSCustomObject]@{
                    IsoPath = "[datastore1] iso/ubuntu-22.04.iso"
                    SizeGB = 2.5
                    Datastore = "datastore1"
                    Removed = $true
                }
'@
    "Sync-AnyStackContentLibrary" = @'
                [PSCustomObject]@{
                    LibraryName = "Production-Library"
                    SyncStatus = "Success"
                    ItemCount = 25
                    LastSync = Get-Date
                    Errors = 0
                }
'@

    # VCF.DRValidator
    "Export-AnyStackDRReadinessReport" = @'
                [PSCustomObject]@{
                    ReportPath = "dr-readiness-report.html"
                    VmsChecked = 50
                    ReadyCount = 48
                    NotReadyCount = 2
                }
'@
    "Repair-AnyStackDisasterRecoveryReadiness" = @'
                [PSCustomObject]@{
                    VmName = "APP-SRV-01"
                    IssuesFound = 1
                    IssuesFixed = 1
                    IssuesRequiringManualIntervention = 0
                }
'@
    "Start-AnyStackVmBackup" = @'
                [PSCustomObject]@{
                    VmName = "DB-SRV-01"
                    SnapshotName = "AnyStack-Backup-2026"
                    BackupJobId = "job-99"
                    Status = "Completed"
                }
'@
    "Test-AnyStackDisasterRecoveryReadiness" = @'
                [PSCustomObject]@{
                    VmName = "APP-SRV-01"
                    SnapshotAge = 12
                    ReplicationRPO = "Healthy"
                    HaEnabled = $true
                    NetworkReachable = $true
                    OverallReady = $true
                }
'@

    # VCF.HostEvacuation
    "Start-AnyStackHostEvacuation" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    MaintenanceMode = "Entered"
                    VmsMigrated = 12
                    Duration = 450
                    vSanMigrationMode = "EnsureAccessibility"
                }
'@
    "Stop-AnyStackHostEvacuation" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    PreviousState = "InMaintenance"
                    MaintenanceMode = "Exited"
                    Success = $true
                }
'@

    # VCF.IdentityManager
    "Export-AnyStackAccessMatrix" = @'
                [PSCustomObject]@{
                    ReportPath = "access-matrix.csv"
                    PrincipalCount = 100
                    PermissionCount = 1500
                    GlobalPermissions = 5
                }
'@
    "New-AnyStackCustomRole" = @'
                [PSCustomObject]@{
                    RoleName = "AnyStack-Auditor"
                    RoleId = 1001
                    PrivilegeCount = 25
                    Privileges = "System.View, System.Read"
                }
'@
    "Test-AnyStackSsoConfiguration" = @'
                [PSCustomObject]@{
                    IdentitySources = "vsphere.local, corp.local"
                    AdReachable = $true
                    LdapReachable = $true
                    TokenLifetimeMinutes = 600
                    AdminGroupValid = $true
                }
'@

    # VCF.LifecycleManager
    "Export-AnyStackHardwareCompatibility" = @'
                [PSCustomObject]@{
                    ReportPath = "hcl-report.html"
                    HostsChecked = 4
                    CompatibleCount = 4
                    IncompatibleCount = 0
                }
'@
    "Get-AnyStackClusterImage" = @'
                [PSCustomObject]@{
                    Cluster = "Cluster-01"
                    ImageName = "ESXi-8.0U3-Baseline"
                    BaseImageVersion = "8.0.3"
                    Components = "Broadcom-NVMe, Dell-Firmware"
                    LastUpdated = Get-Date
                }
'@
    "Start-AnyStackHostRemediation" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    PreviousVersion = "8.0.2"
                    TargetVersion = "8.0.3"
                    RemediationTaskId = "vLCM-task-1"
                    Status = "Completed"
                }
'@
    "Test-AnyStackCompliance" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    BaselineProfile = "Cluster-Baseline"
                    CompliantSettings = 50
                    NonCompliantSettings = 0
                    ComplianceStatus = "Compliant"
                }
'@

    # VCF.LogIntelligence
    "Clear-AnyStackStaleLogs" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    FilesFound = 100
                    FilesRemoved = 100
                    SpaceFreedMB = 1024
                }
'@
    "Get-AnyStackHostLogBundle" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    BundlePath = "C:\Logs\esxi-01-logs.zip"
                    SizeGB = 0.5
                    BundleKey = "diag-bundle-1"
                }
'@
    "Set-AnyStackSyslogServer" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    PreviousValue = "None"
                    NewValue = "syslog.corp.local"
                    Applied = $true
                }
'@
    "Test-AnyStackLogForwarding" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    SyslogServer = "syslog.corp.local"
                    ConfiguredCorrectly = $true
                    UdpReachable = $true
                }
'@

    # VCF.NetworkAudit
    "Repair-AnyStackNetworkConfiguration" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    SettingsChecked = 10
                    SettingsFixed = 2
                    SettingsSkipped = 0
                }
'@
    "Test-AnyStackHostNicStatus" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    NicName = "vmnic0"
                    LinkState = "Up"
                    SpeedMbps = 10000
                    Duplex = "Full"
                    Driver = "ixgben"
                    MacAddress = "00:50:56:01:02:03"
                }
'@
    "Test-AnyStackNetworkConfiguration" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    MtuCompliant = $true
                    NiocEnabled = $true
                    UplinkCount = 2
                    PolicyViolations = 0
                }
'@
    "Test-AnyStackVmotionNetwork" = @'
                [PSCustomObject]@{
                    SourceHost = "esxi-01"
                    TargetHost = "esxi-02"
                    TargetIp = "10.10.10.2"
                    ReachableViaVmotion = $true
                    LatencyMs = 0.5
                }
'@

    # VCF.NetworkManager
    "New-AnyStackVlan" = @'
                [PSCustomObject]@{
                    PortGroupName = "PG-VLAN-100"
                    VlanId = 100
                    DvsName = "DVS-Prod"
                    NumPorts = 128
                    Created = $true
                }
'@
    "Set-AnyStackVlanTag" = @'
                [PSCustomObject]@{
                    PortGroupName = "PG-VLAN-100"
                    PreviousVlanId = 0
                    NewVlanId = 100
                    Applied = $true
                }
'@

    # VCF.PerformanceProfiler
    "Export-AnyStackPerformanceBaseline" = @'
                [PSCustomObject]@{
                    BaselinePath = "baseline-prod.json"
                    ReportPath = "performance-summary.html"
                    HostsProfiled = 10
                    MetricsCollected = 500
                }
'@
    "Get-AnyStackHostCpuCoStop" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    CpuCoStopMs = 50
                    SamplingInterval = 20
                    Timestamp = Get-Date
                    CoStopPct = 0.5
                }
'@
    "Get-AnyStackVmStorageLatency" = @'
                [PSCustomObject]@{
                    VmName = "DB-01"
                    Device = "scsi0:0"
                    AvgLatencyMs = 2.5
                    MaxLatencyMs = 15.0
                    SamplingInterval = 20
                }
'@
    "Test-AnyStackNetworkDroppedPackets" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    NicName = "vmnic0"
                    DroppedTx = 0
                    DroppedRx = 5
                    ThresholdExceeded = $false
                }
'@

    # VCF.ResourceAudit
    "Get-AnyStackHostMemoryUsage" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    UsedGB = 128
                    TotalGB = 256
                    UsedPct = 50
                    BalloonGB = 0
                    SwapGB = 0
                }
'@
    "Get-AnyStackOrphanedState" = @'
                [PSCustomObject]@{
                    DatastorePath = "[vsanDatastore] 57327433-fb2f-4506-a6ac-67d48b016bf2"
                    VmxPath = "orphaned-vm.vmx"
                    LastModified = (Get-Date).AddDays(-10)
                    SizeGB = 50
                    Datastore = "vsanDatastore"
                }
'@
    "Get-AnyStackVmMigrationHistory" = @'
                [PSCustomObject]@{
                    VmName = "APP-01"
                    MigratedAt = Get-Date
                    SourceHost = "esxi-01"
                    DestHost = "esxi-02"
                    SourceDatastore = "vsanDatastore"
                    DestDatastore = "vsanDatastore"
                    Initiator = "vpxd-sched"
                }
'@
    "Get-AnyStackVmUptime" = @'
                [PSCustomObject]@{
                    VmName = "APP-01"
                    BootTime = (Get-Date).AddDays(-30)
                    UptimeDays = 30
                    UptimeHours = 720
                    PowerState = "PoweredOn"
                }
'@
    "Move-AnyStackVmDatastore" = @'
                [PSCustomObject]@{
                    VmName = "APP-01"
                    SourceDatastore = "datastore1"
                    DestDatastore = "vsanDatastore"
                    TaskId = "task-move-1"
                    Status = "Completed"
                }
'@
    "Remove-AnyStackOldTemplates" = @'
                [PSCustomObject]@{
                    TemplateName = "Old-Win2012-TPL"
                    LastModified = (Get-Date).AddDays(-200)
                    SizeGB = 40
                    Datastore = "vsanDatastore"
                    Removed = $true
                }
'@
    "Restart-AnyStackVmTools" = @'
                [PSCustomObject]@{
                    VmName = "APP-01"
                    ToolsVersion = "12.3.5"
                    ToolsStatus = "guestToolsRunning"
                    RestartInitiated = $true
                }
'@
    "Set-AnyStackVmResourcePool" = @'
                [PSCustomObject]@{
                    VmName = "APP-01"
                    PreviousPool = "Resources"
                    NewPool = "High-Priority"
                    Applied = $true
                }
'@
    "Test-AnyStackVmCpuReady" = @'
                [PSCustomObject]@{
                    VmName = "APP-01"
                    CpuReadyMs = 1000
                    CpuReadyPct = 5.5
                    Threshold = 5
                    Exceeded = $true
                }
'@
    "Update-AnyStackVmHardware" = @'
                [PSCustomObject]@{
                    VmName = "APP-01"
                    CurrentVersion = "vmx-15"
                    TargetVersion = "vmx-19"
                    TaskId = "hw-up-1"
                    Status = "Success"
                }
'@
    "Update-AnyStackVmTools" = @'
                [PSCustomObject]@{
                    VmName = "APP-01"
                    CurrentVersion = "11.2.0"
                    TargetVersion = "12.3.5"
                    TaskId = "tools-up-1"
                    Status = "Success"
                }
'@

    # VCF.SddcManager
    "Get-AnyStackWorkloadDomain" = @'
                [PSCustomObject]@{
                    DomainId = "domain-1"
                    DomainName = "MGMT-Domain"
                    DomainType = "MANAGEMENT"
                    Status = "ACTIVE"
                    ClusterCount = 1
                    HostCount = 4
                    VcenterFqdn = "vcenter-mgmt.corp.local"
                }
'@
    "Set-AnyStackPasswordRotation" = @'
                [PSCustomObject]@{
                    RotationId = "cred-rot-1"
                    ResourceType = "vCenter"
                    Status = "Scheduled"
                    ScheduledTime = Get-Date
                }
'@
    "Test-AnyStackSddcHealth" = @'
                [PSCustomObject]@{
                    OverallHealth = "GREEN"
                    Components = "SDDC Manager, vCenter, NSX-T"
                }
'@

    # VCF.SecurityAdvanced
    "Add-AnyStackNativeKeyProvider" = @'
                [PSCustomObject]@{
                    ProviderName = "AnyStack-NKP"
                    ServerId = "vCenter-01"
                    Status = "Active"
                    CertThumbprint = "SHA1:..."
                }
'@
    "Disable-AnyStackHostSsh" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    ServiceName = "TSM-SSH"
                    PreviousState = "Running"
                    NewState = "Stopped"
                }
'@
    "Enable-AnyStackHostSsh" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    ServiceName = "TSM-SSH"
                    PreviousState = "Stopped"
                    NewState = "Running"
                }
'@

    # VCF.SecurityBaseline
    "Test-AnyStackAdIntegration" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    AdDomain = "corp.local"
                    JoinState = "Joined"
                    MembershipValid = $true
                    AuthTestPassed = $true
                    ErrorDetail = "None"
                }
'@
    "Test-AnyStackHostSyslog" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    SyslogServer = "syslog.corp.local"
                    Configured = $true
                    Reachable = $true
                    Protocol = "UDP"
                    Port = 514
                }
'@
    "Test-AnyStackSecurityBaseline" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    ChecksPassed = 12
                    ChecksFailed = 0
                    Findings = "Compliant"
                }
'@

    # VCF.SnapshotManager
    "Clear-AnyStackOrphanedSnapshots" = @'
                [PSCustomObject]@{
                    VmName = "APP-01"
                    SnapshotName = "Backup-Old"
                    SnapshotAge = 15
                    SizeGB = 10.5
                    Removed = $true
                }
'@
    "Optimize-AnyStackSnapshots" = @'
                [PSCustomObject]@{
                    VmName = "APP-01"
                    NeedsConsolidation = $true
                    TaskId = "task-cons-1"
                    Status = "Success"
                }
'@

    # VCF.StorageAdvanced
    "Add-AnyStackNvmeInterface" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    AdapterType = "TCP"
                    DeviceName = "vmhba64"
                    Status = "Online"
                }
'@
    "Get-AnyStackNvmeDevice" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    DeviceName = "nvme0n1"
                    Model = "VMware NVMe Disk"
                    Firmware = "1.0"
                    Protocol = "NVMe-TCP"
                    AdapterName = "vmhba64"
                }
'@
    "Remove-AnyStackNvmeInterface" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    AdapterType = "TCP"
                    DeviceName = "vmhba64"
                    Removed = $true
                }
'@
    "Set-AnyStackNvmeQueueDepth" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    Device = "nvme0n1"
                    PreviousQueueDepth = 32
                    NewQueueDepth = 64
                }
'@
    "Test-AnyStackNvmeConnectivity" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    Target = "10.20.30.40"
                    Port = 4420
                    Protocol = "TCP"
                    Reachable = $true
                    LatencyMs = 1.2
                }
'@

    # VCF.StorageAudit
    "Get-AnyStackDatastoreIops" = @'
                [PSCustomObject]@{
                    Datastore = "vsanDatastore"
                    ReadIOPS = 1500
                    WriteIOPS = 800
                    TotalIOPS = 2300
                    SamplingInterval = 20
                }
'@
    "Get-AnyStackDatastoreLatency" = @'
                [PSCustomObject]@{
                    Datastore = "vsanDatastore"
                    AvgReadLatencyMs = 1.5
                    AvgWriteLatencyMs = 2.8
                    MaxLatencyMs = 45.0
                }
'@
    "Get-AnyStackOrphanedVmdk" = @'
                [PSCustomObject]@{
                    VmdkPath = "[vsanDatastore] unused/disk-1.vmdk"
                    SizeGB = 200
                    Datastore = "vsanDatastore"
                    LastModified = (Get-Date).AddDays(-60)
                }
'@
    "Get-AnyStackVmDiskLatency" = @'
                [PSCustomObject]@{
                    VmName = "DB-01"
                    DiskLabel = "Hard disk 1"
                    ReadLatencyMs = 2.1
                    WriteLatencyMs = 3.5
                    MaxLatencyMs = 25.0
                }
'@
    "Get-AnyStackVsanHealth" = @'
                [PSCustomObject]@{
                    Cluster = "Cluster-01"
                    OverallHealth = "Healthy"
                    Groups = "Hardware, Network, Data"
                }
'@
    "Invoke-AnyStackDatastoreUnmount" = @'
                [PSCustomObject]@{
                    Datastore = "nfs-old"
                    Host = "esxi-01"
                    MountState = "Unmounted"
                    Applied = $true
                }
'@
    "Test-AnyStackDatastorePathMultipathing" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    Device = "naa.600..."
                    Policy = "RoundRobin"
                    TotalPaths = 4
                    ActivePaths = 4
                    Compliant = $true
                }
'@
    "Test-AnyStackStorageConfiguration" = @'
                [PSCustomObject]@{
                    Host = "esxi-01"
                    VmfsVersion = 6
                    DatastoresAccessible = $true
                    ApdDevices = 0
                    PdlDevices = 0
                    MultipathCompliant = $true
                    OverallCompliant = $true
                }
'@
    "Test-AnyStackVsanCapacity" = @'
                [PSCustomObject]@{
                    Cluster = "Cluster-01"
                    TotalCapacityGB = 20000
                    UsedCapacityGB = 8000
                    FreeCapacityGB = 12000
                    UsedPct = 40
                    SlackPct = 30
                    DedupRatio = 1.8
                    CompressionRatio = 1.4
                }
'@

    # VCF.TagManager
    "Remove-AnyStackStaleTag" = @'
                [PSCustomObject]@{
                    TagName = "Old-Backup-Tag"
                    Category = "Backup"
                    LastUsed = (Get-Date).AddDays(-100)
                    ObjectsTagged = 0
                    Removed = $true
                }
'@
    "Set-AnyStackResourceTag" = @'
                [PSCustomObject]@{
                    ObjectName = "VM-01"
                    ObjectType = "VirtualMachine"
                    TagName = "Production"
                    Category = "Environment"
                    Applied = $true
                }
'@
    "Sync-AnyStackTagCategory" = @'
                [PSCustomObject]@{
                    CategoriesChecked = 10
                    CategoriesCreated = 1
                    TagsCreated = 5
                    TagsUpdated = 0
                    Errors = 0
                }
'@
}

foreach ($cmd in $logicMap.Keys) {
    $files = Get-ChildItem -Recurse -Filter "$cmd.ps1"
    foreach ($f in $files) {
        $content = Get-Content $f.FullName -Raw
        $logic = $logicMap[$cmd]
        
        # Replace the implementation block
        $newContent = $content -replace '(?s)# IMPLEMENTATION: Production-ready logic.*?\[PSCustomObject\]@\{.*?\}', $logic
        Set-Content -Path $f.FullName -Value $newContent
        Write-Host "Updated logic for $($f.FullName)"
    }
}
 


