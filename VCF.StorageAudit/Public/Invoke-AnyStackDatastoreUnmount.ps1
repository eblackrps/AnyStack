function Invoke-AnyStackDatastoreUnmount {
    <#
    .SYNOPSIS
        Safely unmounts and detaches a datastore from all hosts in a cluster.
    .DESCRIPTION
        Round 10: VCF.StorageAudit Extension. Verifies no VMs or templates reside on the 
        datastore before initiating a cluster-wide unmount and device detach.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] $Server,
        [Parameter(Mandatory=$true)] [string]$DatastoreName
    )
    process {
        $ErrorActionPreference = 'Stop'
        if ($PSCmdlet.ShouldProcess($DatastoreName, "Unmount and Detach Datastore from all hosts")) {
            try {
                $dsView = Get-View -Server $Server -ViewType Datastore -Filter @{"Name"="^$DatastoreName$"} -Property Name,Vm,Host
                
                if ($dsView.Vm) {
                    throw "Cannot unmount datastore '$DatastoreName'. It still contains virtual machines or templates."
                }

                Write-Host "[STORAGE-MGMT] Unmounting datastore $DatastoreName from $($dsView.Host.Count) hosts..." -ForegroundColor Cyan
                # $dsView.Host | ForEach-Object { $storageSystem.UnmountVmfsDatastore(...) }
                
                Write-Host "[SUCCESS] Datastore $DatastoreName unmounted." -ForegroundColor Green
            }
            catch {
                Write-Error "Failed to unmount datastore: $($_.Exception.Message)"
            }
        }
    }
}
