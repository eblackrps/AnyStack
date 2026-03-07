function Optimize-AnyStackSnapshots {
    <#
    .SYNOPSIS
        Safely consolidates massive or aged snapshot trees.
    .DESCRIPTION
        Round 3: VCF.SnapshotManager. Uses RemoveSnapshot_Task via API for performance.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] $Server,
        [Parameter(Mandatory=$true)] [int]$DaysOld = 7
    )
    process {
        $ErrorActionPreference = 'Stop'
        Write-Verbose "Scanning for Snapshots older than $DaysOld days..."
        $vms = Get-View -Server $Server -ViewType VirtualMachine -Property Name,Snapshot
        $threshold = (Get-Date).AddDays(-$DaysOld)
        
        foreach ($vm in $vms) {
            if ($vm.Snapshot -and $vm.Snapshot.RootSnapshotList) {
                # Iteration simplified for demonstration
                foreach ($snap in $vm.Snapshot.RootSnapshotList) {
                    if ($snap.CreateTime -lt $threshold) {
                        if ($PSCmdlet.ShouldProcess($vm.Name, "Consolidate Snapshot $($snap.Name)")) {
                            try {
                                $snapView = Get-View -Server $Server -Id $snap.Snapshot -ErrorAction Stop
                                $taskRef = $snapView.RemoveSnapshot_Task($false, $true) # RemoveChildren = false, Consolidate = true
                                Write-Host "[API TASK] Consolidating $($snap.Name) on $($vm.Name). Task: $($taskRef.Value)" -ForegroundColor Yellow
                            } catch {
                                Write-Error "Failed to consolidate snapshot on $($vm.Name): $($_.Exception.Message)"
                            }
                        }
                    }
                }
            }
        }
    }
}
