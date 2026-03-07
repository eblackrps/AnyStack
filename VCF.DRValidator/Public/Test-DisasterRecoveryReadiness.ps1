function Test-DisasterRecoveryReadiness {
    <#
    .SYNOPSIS
        Evaluates VMware vSphere disaster recovery readiness for VMs across sites.

    .DESCRIPTION
        This advanced function uses Get-View to rapidly assess VMs in a source cluster against DR readiness criteria.
        Checks include CBT status, Snapshot age, Hardware Version (vmx-19+), vCPU/NUMA limits against a target cluster,
        Resource Pool constraints, Storage Blockers (pRDMs, Independent Disks, Multi-Writer, ISOs), Network configurations,
        DRS rules, and Encryption/vTPM status. Validates target Datastore Cluster capacity (>20% free).

    .PARAMETER SourceServer
        Connection to the source vCenter server.

    .PARAMETER TargetServer
        Connection to the target vCenter server.

    .PARAMETER SourceCluster
        Name of the source cluster.

    .PARAMETER TargetCluster
        Name of the target DR cluster.

    .PARAMETER TargetDatastoreCluster
        Name of the target Datastore Cluster.

    .PARAMETER VMName
        Optional array of critical VM names to test. If omitted, all applicable VMs in the source cluster are evaluated.

    .EXAMPLE
        Test-DisasterRecoveryReadiness -SourceServer $srcVc -TargetServer $tgtVc -SourceCluster "SiteA-Cl01" -TargetCluster "SiteB-Cl01" -TargetDatastoreCluster "SiteB-DSC01"

    .NOTES
        Author: The Any Stack Architect
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $SourceServer,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $TargetServer,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$SourceCluster,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$TargetCluster,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$TargetDatastoreCluster,

        [Parameter(Mandatory=$false)]
        [string[]]$VMName
    )

    begin {
        Write-Verbose "Initializing DR Readiness Validation..."
    }

    process {
        $ErrorActionPreference = 'Stop'
        try {
            # 1. Target Datastore Cluster Evaluation
            Write-Verbose "Evaluating Target Datastore Cluster: $TargetDatastoreCluster"
            $dsClusterView = Get-View -Server $TargetServer -ViewType StoragePod -Filter @{"Name"="^$TargetDatastoreCluster$"} -Property Name,Summary -ErrorAction Stop
            
            $targetDsHealthy = $false
            if ($dsClusterView) {
                $capacity = $dsClusterView.Summary.Capacity
                $freeSpace = $dsClusterView.Summary.FreeSpace
                if ($capacity -gt 0) {
                    $freePct = ($freeSpace / $capacity) * 100
                    if ($freePct -gt 20) { $targetDsHealthy = $true }
                }
            }
            if (-not $targetDsHealthy) {
                Write-Warning "Target Datastore Cluster '$TargetDatastoreCluster' has less than 20% free space or was not found."
            }

            # 2. Target Cluster Compute Boundaries
            Write-Verbose "Evaluating Target Cluster: $TargetCluster"
            $tgtClusterView = Get-View -Server $TargetServer -ViewType ClusterComputeResource -Filter @{"Name"="^$TargetCluster$"} -Property Host -ErrorAction Stop
            $maxTargetCores = 0
            if ($tgtClusterView -and $tgtClusterView.Host) {
                $tgtHosts = Get-View -Server $TargetServer -Id $tgtClusterView.Host -Property Hardware.CpuInfo.NumCores
                foreach ($h in $tgtHosts) {
                    if ($h.Hardware.CpuInfo.NumCores -gt $maxTargetCores) {
                        $maxTargetCores = $h.Hardware.CpuInfo.NumCores
                    }
                }
            }

            # 3. Source Cluster rules (DRS Affinity)
            Write-Verbose "Fetching Source Cluster: $SourceCluster"
            $srcClusterView = Get-View -Server $SourceServer -ViewType ClusterComputeResource -Filter @{"Name"="^$SourceCluster$"} -Property ConfigurationEx.Rule,MoRef -ErrorAction Stop
            if (-not $srcClusterView) {
                throw "Source Cluster '$SourceCluster' not found."
            }

            # Map VM MoRef to DRS Rules
            $vmDrsRules = @{}
            if ($srcClusterView.ConfigurationEx.Rule) {
                foreach ($rule in $srcClusterView.ConfigurationEx.Rule) {
                    if ($rule -is [VMware.Vim.ClusterAntiAffinityRuleSpec] -or $rule -is [VMware.Vim.ClusterAffinityRuleSpec]) {
                        foreach ($ruleVm in $rule.Vm) {
                            $vmStr = $ruleVm.Value
                            if (-not $vmDrsRules[$vmStr]) { $vmDrsRules[$vmStr] = @() }
                            $vmDrsRules[$vmStr] += $rule.Name
                        }
                    }
                }
            }

            # 4. Fetch VMs
            Write-Verbose "Fetching VMs from Source Cluster..."
            $vmProps = @(
                "Name", "Config.ManagedBy", "Config.FtInfo", "Config.ChangeTrackingEnabled", "Config.Version",
                "Config.Hardware.Device", "Config.Hardware.NumCPU", "Config.CpuAllocation", "Config.MemoryAllocation",
                "Config.KeyId", "Guest.ToolsStatus", "Snapshot.RootSnapshotList", "Parent", "Network"
            )
            
            $allVms = Get-View -Server $SourceServer -ViewType VirtualMachine -SearchRoot $srcClusterView.MoRef -Property $vmProps
            
            # Filter vCLS and FT VMs, and by VMName if provided
            $filteredVms = $allVms | Where-Object {
                ($null -eq $_.Config.ManagedBy -or $_.Config.ManagedBy.ExtensionKey -ne "com.vmware.vcls") -and
                ($_.Name -notmatch "^vCLS") -and
                ($null -eq $_.Config.FtInfo)
            }

            if ($VMName -and $VMName.Count -gt 0) {
                $filteredVms = $filteredVms | Where-Object { $VMName -contains $_.Name }
            }

            # 5. Process each VM
            $snapThreshold = (Get-Date).AddHours(-24)
            
            # Pre-fetch Resource Pools
            $rpViews = Get-View -Server $SourceServer -ViewType ResourcePool -Property Name,Config
            $rpMap = @{}
            if ($rpViews) { foreach ($rp in $rpViews) { $rpMap[$rp.MoRef.Value] = $rp } }

            # Pre-fetch Networks for VSS check
            $netViews = Get-View -Server $SourceServer -ViewType Network -Property Name
            $vssMap = @{}
            if ($netViews) { foreach ($net in $netViews) { $vssMap[$net.MoRef.Value] = $net.Name } }

            $results = foreach ($vm in $filteredVms) {
                $isReady = $true

                # --- Data Protection Readiness ---
                $cbtEnabled = ($vm.Config.ChangeTrackingEnabled -eq $true)
                if (-not $cbtEnabled) { $isReady = $false }

                $toolsStatus = $vm.Guest.ToolsStatus
                if ($toolsStatus -ne "toolsOk") { $isReady = $false }

                $hwVersion = $vm.Config.Version
                $hwVerInt = 0
                if ($hwVersion -match "\d+") { $hwVerInt = [int]$Matches[0] }
                if ($hwVerInt -lt 19) { $isReady = $false }

                $hasOrphanedSnaps = $false
                if ($vm.Snapshot -and $vm.Snapshot.RootSnapshotList) {
                    $hasOrphanedSnaps = Get-OldSnapshots -SnapshotTree $vm.Snapshot.RootSnapshotList -OlderThan $snapThreshold
                    if ($hasOrphanedSnaps) { $isReady = $false }
                }

                # --- Storage Edge Cases ---
                $storageFlags = @()
                $networkFlags = @()
                $encryptionFlags = @()

                if ($vm.Config.Hardware.Device) {
                    foreach ($dev in $vm.Config.Hardware.Device) {
                        # Connected ISO
                        if ($dev.GetType().Name -eq "VirtualCdrom") {
                            if ($dev.Backing.GetType().Name -eq "VirtualCdromIsoBackingInfo" -and $dev.Connectable.Connected) {
                                $storageFlags += "Connected ISO"
                            }
                        }
                        # Disks
                        elseif ($dev.GetType().Name -eq "VirtualDisk") {
                            if ($dev.Backing.DiskMode -match "independent") {
                                $storageFlags += "Independent Disk ($($dev.Backing.DiskMode))"
                            }
                            if ($dev.Backing.Sharing -eq "sharingMultiWriter") {
                                $storageFlags += "Multi-Writer VMDK"
                            }
                            if ($dev.Backing.CompatibilityMode -eq "physicalMode") {
                                $storageFlags += "Physical RDM (pRDM)"
                            }
                        }
                        # Network Adapters
                        elseif ($dev.GetType().Name -match "Virtual(?:E1000|E1000e|PCNet32|Vmxnet|Vmxnet2|Vmxnet3)") {
                            if (-not $dev.Connectable.Connected) {
                                $networkFlags += "Disconnected vNIC"
                            }
                            if ($dev.AddressType -eq "Manual") {
                                $networkFlags += "Static MAC Address"
                            }
                        }
                        # vTPM
                        elseif ($dev.GetType().Name -eq "VirtualTPM") {
                            $encryptionFlags += "vTPM Present"
                        }
                    }
                }

                if ($storageFlags.Count -gt 0) { $isReady = $false }

                # --- Compute & NUMA ---
                $numaFlags = @()
                if ($maxTargetCores -gt 0 -and $vm.Config.Hardware.NumCPU -gt $maxTargetCores) {
                    $numaFlags += "vCPUs ($($vm.Config.Hardware.NumCPU)) exceeds Target Host Physical Cores ($maxTargetCores)"
                    $isReady = $false
                }

                # --- Resource Constraints ---
                $resourceFlags = @()
                if ($vm.Config.CpuAllocation.Reservation -gt 0) {
                    $resourceFlags += "Hardcoded CPU Reservation"
                }
                if ($vm.Config.MemoryAllocation.Reservation -gt 0) {
                    $resourceFlags += "Hardcoded Memory Reservation"
                }
                if ($vm.Parent) {
                    $parentRp = $rpMap[$vm.Parent.Value]
                    if ($parentRp) {
                        if ($parentRp.Config.CpuAllocation.Limit -ne -1 -or $parentRp.Config.MemoryAllocation.Limit -ne -1) {
                            $resourceFlags += "Restricted Resource Pool ($($parentRp.Name))"
                        }
                    }
                }

                # --- Networking & Cluster Rules ---
                if ($vm.Network) {
                    foreach ($netRef in $vm.Network) {
                        if ($vssMap.ContainsKey($netRef.Value)) {
                            $networkFlags += "Standard vSwitch ($($vssMap[$netRef.Value]))"
                        }
                    }
                }
                if ($vmDrsRules.ContainsKey($vm.MoRef.Value)) {
                    $networkFlags += "DRS Rules: $($vmDrsRules[$vm.MoRef.Value] -join '; ')"
                }
                if ($networkFlags.Count -gt 0) { $isReady = $false }

                # --- Security & Encryption ---
                if ($vm.Config.KeyId) {
                    $encryptionFlags += "VM Encrypted"
                }
                if ($encryptionFlags.Count -gt 0) { 
                    $isReady = $false 
                    Write-Warning "VM $($vm.Name) has Encryption or vTPM active. Target vCenter requires a synced Key Provider."
                }

                # --- Output ---
                [PSCustomObject]@{
                    VMName                 = $vm.Name
                    HardwareVersion        = $hwVersion
                    CBTEnabled             = $cbtEnabled
                    ToolsStatus            = $toolsStatus
                    HasOrphanedSnaps       = $hasOrphanedSnaps
                    StorageBlockers        = ($storageFlags -join ' | ')
                    NumaOrCoreViolations   = ($numaFlags -join ' | ')
                    ResourceConstraints    = ($resourceFlags -join ' | ')
                    NetworkOrRuleFlags     = ($networkFlags -join ' | ')
                    EncryptionFlags        = ($encryptionFlags -join ' | ')
                    TargetDatastoreHealthy = $targetDsHealthy
                    DRReady                = $isReady
                }
            }

            Write-Output $results
        }
        catch {
            Write-Error "Failed to evaluate DR Readiness: $($_.Exception.Message)"
            throw
        }
    }
}
