function Test-AnyStackProactiveHa {
    <#
    .SYNOPSIS
        Audits the Proactive HA status and Health Provider configuration.
    .DESCRIPTION
        Round 9: VCF.ClusterManager. Ensures the cluster is protected against 
        impending hardware failures via Proactive HA.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] $Server,
        [Parameter(Mandatory=$true)] [string]$ClusterName
    )
    process {
        $ErrorActionPreference = 'Stop'
        try {
            $clusterView = Get-View -Server $Server -ViewType ClusterComputeResource -Filter @{"Name"="^$ClusterName$"} -Property Name,ConfigurationEx
            
            $haConfig = $clusterView.ConfigurationEx.ProactiveHaConfig
            
            [PSCustomObject]@{
                Cluster            = $clusterView.Name
                ProactiveHaEnabled = $haConfig.Enabled
                StrictExecution    = $haConfig.StrictExecution
                HealthProviders    = ($haConfig.HealthProviderIds -join ', ')
                Status             = if ($haConfig.Enabled) { "Protected" } else { "Unprotected" }
            }
        }
        catch {
            Write-Error "Failed to audit Proactive HA: $($_.Exception.Message)"
        }
    }
}
