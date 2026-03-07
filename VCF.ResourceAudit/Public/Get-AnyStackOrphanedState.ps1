function Get-AnyStackOrphanedState {
    <#
    .SYNOPSIS
        Identifies VMs that are orphaned, inaccessible, or disconnected.
    .DESCRIPTION
        Round 6: VCF.ResourceAudit. Quickly scans the vCenter inventory for registered VMs 
        that have lost their underlying datastore connection or are orphaned.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] $Server
    )
    process {
        $ErrorActionPreference = 'Stop'
        Write-Verbose "Scanning for orphaned or disconnected virtual machines..."
        
        # In Get-View, ConnectionState = "orphaned" or "inaccessible"
        $vms = Get-View -Server $Server -ViewType VirtualMachine -Property Name,Runtime.ConnectionState
        
        $orphaned = $vms | Where-Object { $_.Runtime.ConnectionState -match "orphaned|inaccessible|disconnected" }
        
        foreach ($vm in $orphaned) {
            [PSCustomObject]@{
                VMName = $vm.Name
                State  = $vm.Runtime.ConnectionState
                Action = "Requires manual investigation or unregistration"
            }
        }
    }
}
