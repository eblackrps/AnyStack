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
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Clearing snapshots on $($vi.Name)"
            $filter = if ($VmName) { @{Name="*$VmName*"} } else { $null }
            $vms = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType VirtualMachine -Filter $filter -Property Name,Snapshot }
            
            $threshold = (Get-Date).AddDays(-$AgeDays)
            foreach ($vm in $vms) {
                if ($vm.Snapshot -and $vm.Snapshot.RootSnapshotList) {
                    foreach ($snap in $vm.Snapshot.RootSnapshotList) {
                        if ($snap.CreateTime -lt $threshold) {
                            if ($PSCmdlet.ShouldProcess($vm.Name, "Remove Snapshot $($snap.Name)")) {
                                Invoke-AnyStackWithRetry -ScriptBlock { $vm.RemoveSnapshot_Task($snap.Snapshot, $false, $true) }
                                
                                [PSCustomObject]@{
                                    PSTypeName   = 'AnyStack.ClearedSnapshot'
                                    Timestamp    = (Get-Date)
                                    Server       = $vi.Name
                                    VmName       = $vm.Name
                                    SnapshotName = $snap.Name
                                    SnapshotAge  = [int]((Get-Date) - $snap.CreateTime).TotalDays
                                    SizeGB       = 0
                                    Removed      = $true
                                }
                            }
                        }
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



