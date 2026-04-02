function Get-AnyStackVirtualMachineView {
    [CmdletBinding()]
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory = $true)]
        $Server,
        [Parameter(Mandatory = $false)]
        [string]$ClusterName,
        [Parameter(Mandatory = $false)]
        [string]$VmName,
        [Parameter(Mandatory = $false)]
        [string[]]$Property = @('Name')
    )

    $requestedProperties = [System.Collections.Generic.List[string]]::new()
    foreach ($item in @($Property)) {
        if (-not [string]::IsNullOrWhiteSpace($item) -and -not $requestedProperties.Contains($item)) {
            $requestedProperties.Add($item)
        }
    }
    if (-not $requestedProperties.Contains('Runtime.Host')) {
        $requestedProperties.Add('Runtime.Host')
    }

    $filter = if ($VmName) { @{ Name = "*$VmName*" } } else { $null }
    $vms = Invoke-AnyStackWithRetry -ScriptBlock {
        Get-View -Server $Server -ViewType VirtualMachine -Filter $filter -Property $requestedProperties
    }

    $clusterHostIds = Get-AnyStackClusterHostIdSet -Server $Server -ClusterName $ClusterName
    if ($null -eq $clusterHostIds) {
        return @($vms)
    }

    return @($vms | Where-Object { $_.Runtime.Host -and $clusterHostIds.Contains($_.Runtime.Host.Value) })
}
