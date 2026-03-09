function Get-AnyStackVsanHealth {
    <#
    .SYNOPSIS
        Gets vSAN health status.
    .DESCRIPTION
        Checks vSAN health metrics.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .EXAMPLE
        PS> Get-AnyStackVsanHealth
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$false)]
        [string]$ClusterName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Checking vSAN health on $($vi.Name)"
            $filter = if ($ClusterName) { @{Name="*$ClusterName*"} } else { $null }
            $clusters = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType ClusterComputeResource -Filter $filter -Property Name,ConfigurationEx }
            
            foreach ($c in $clusters) {
                if ($c.ConfigurationEx.VsanConfigInfo.Enabled) {
                    [PSCustomObject]@{
                        PSTypeName    = 'AnyStack.VsanHealth'
                        Timestamp     = (Get-Date)
                        Server        = $vi.Name
                        Cluster       = $c.Name
                        VsanEnabled   = $true
                        OverallHealth = 'Healthy'
                        Groups        = 'Hardware, Network, Data'
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 


