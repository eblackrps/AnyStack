function Get-AnyStackHostView {
    [CmdletBinding()]
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory = $true)]
        $Server,
        [Parameter(Mandatory = $false)]
        [string]$ClusterName,
        [Parameter(Mandatory = $false)]
        [string]$HostName,
        [Parameter(Mandatory = $false)]
        [string[]]$Property = @('Name')
    )

    $filter = if ($HostName) { @{ Name = "*$HostName*" } } else { $null }
    $hosts = Invoke-AnyStackWithRetry -ScriptBlock {
        Get-View -Server $Server -ViewType HostSystem -Filter $filter -Property $Property
    }

    $clusterHostIds = Get-AnyStackClusterHostIdSet -Server $Server -ClusterName $ClusterName
    if ($null -eq $clusterHostIds) {
        return @($hosts)
    }

    return @($hosts | Where-Object { $clusterHostIds.Contains($_.MoRef.Value) })
}
