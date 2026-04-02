function Get-AnyStackClusterHostIdSet {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.HashSet[string]])]
    param(
        [Parameter(Mandatory = $true)]
        $Server,
        [Parameter(Mandatory = $false)]
        [string]$ClusterName
    )

    if ([string]::IsNullOrWhiteSpace($ClusterName)) {
        return $null
    }

    $clusters = Invoke-AnyStackWithRetry -ScriptBlock {
        Get-View -Server $Server -ViewType ClusterComputeResource -Filter @{ Name = "*$ClusterName*" } -Property Name,Host
    }

    $hostIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($cluster in @($clusters)) {
        foreach ($hostRef in @($cluster.Host)) {
            if ($hostRef) {
                $null = $hostIds.Add($hostRef.Value)
            }
        }
    }

    return $hostIds
}
