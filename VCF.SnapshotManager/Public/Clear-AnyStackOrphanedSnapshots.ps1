function Get-FlatSnapshotList {
    param([object[]]$SnapshotTree)
    foreach ($snap in $SnapshotTree) {
        $snap
        if ($snap.ChildSnapshotList) {
            Get-FlatSnapshotList -SnapshotTree $snap.ChildSnapshotList
        }
    }
}

function Clear-AnyStackOrphanedSnapshots {
    <#
    .SYNOPSIS
        Removes old VM snapshots.
    .DESCRIPTION
        Deletes snapshots older than AgeDays.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER AgeDays
        Age in days (default 7).
    .PARAMETER VmName
        Filter by VM.
    .PARAMETER ClusterName
        Filter by cluster.
    .EXAMPLE
        PS> Clear-AnyStackOrphanedSnapshots
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$false)]
        [int]$AgeDays = 7,
        [Parameter(Mandatory=$false)]
        [string]$VmName,
        [Parameter(Mandatory=$false)]
        [string]$ClusterName
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Clearing snapshots on $($vi.Name)"
            $filter = if ($VmName) { @{Name="*$VmName*"} } else { $null }
            $clusterHostIds = $null
            if ($ClusterName) {
                $clusters = Invoke-AnyStackWithRetry -ScriptBlock {
                    Get-View -Server $vi -ViewType ClusterComputeResource -Filter @{Name="*$ClusterName*"} -Property Name,Host
                }
                $clusterHostIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
                foreach ($cluster in @($clusters)) {
                    foreach ($hostRef in @($cluster.Host)) {
                        if ($hostRef) {
                            $null = $clusterHostIds.Add($hostRef.Value)
                        }
                    }
                }
            }

            $vms = Invoke-AnyStackWithRetry -ScriptBlock {
                Get-View -Server $vi -ViewType VirtualMachine -Filter $filter -Property Name,Snapshot,Runtime.Host
            }
            if ($null -ne $clusterHostIds) {
                $vms = @($vms | Where-Object { $_.Runtime.Host -and $clusterHostIds.Contains($_.Runtime.Host.Value) })
            }
            
            $threshold = (Get-Date).AddDays(-$AgeDays)
            foreach ($vm in $vms) {
                if ($vm.Snapshot -and $vm.Snapshot.RootSnapshotList) {
                    $allSnaps = Get-FlatSnapshotList -SnapshotTree $vm.Snapshot.RootSnapshotList
                    foreach ($snap in $allSnaps) {
                        if ($snap.CreateTime -lt $threshold) {
                            if ($PSCmdlet.ShouldProcess($vm.Name, "Remove Snapshot $($snap.Name)")) {
                                $snapshotView = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $snap.Snapshot }
                                $taskRef = Invoke-AnyStackWithRetry -ScriptBlock { $snapshotView.RemoveSnapshot_Task($false, $true) }
                                
                                [PSCustomObject]@{
                                    PSTypeName   = 'AnyStack.ClearedSnapshot'
                                    Timestamp    = (Get-Date)
                                    Server       = $vi.Name
                                    VmName       = $vm.Name
                                    SnapshotName = $snap.Name
                                    SnapshotAge  = [int]((Get-Date) - $snap.CreateTime).TotalDays
                                    SizeGB       = 0
                                    TaskId       = $taskRef.Value
                                    Removed      = $true
                                }
                            }
                        }
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
