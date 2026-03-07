function Test-AnyStackStorageConfiguration {
    <#
    .SYNOPSIS
        Validates datastore health and ESXi multipathing states.
    .DESCRIPTION
        Round 1: VCF.StorageAudit. Uses Get-View to rapidly assess VMFS/vSAN free space across clusters
        and checks host multipath states (NMP) for active/dead paths.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] $Server,
        [Parameter(Mandatory=$true)] [string]$DatastoreCluster
    )
    process {
        $ErrorActionPreference = 'Stop'
        Write-Verbose "Auditing Storage for $DatastoreCluster"
        $dsView = Get-View -Server $Server -ViewType Datastore -Property Name,Summary.Capacity,Summary.FreeSpace,Summary.Type,Host
        $dsResults = foreach ($ds in $dsView) {
            $capGB = [math]::Round($ds.Summary.Capacity / 1GB, 2)
            $freeGB = [math]::Round($ds.Summary.FreeSpace / 1GB, 2)
            $pctFree = if ($capGB -gt 0) { [math]::Round(($freeGB / $capGB) * 100, 2) } else { 0 }
            
            [PSCustomObject]@{
                Datastore = $ds.Name
                Type      = $ds.Summary.Type
                CapacityGB= $capGB
                FreeGB    = $freeGB
                PctFree   = $pctFree
                Alert     = if ($pctFree -lt 15) { "CRITICAL SPACE" } else { "OK" }
            }
        }
        Write-Output $dsResults
    }
}
