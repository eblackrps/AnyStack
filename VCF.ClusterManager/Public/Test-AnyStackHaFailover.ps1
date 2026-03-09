function Test-AnyStackHaFailover {
    <#
    .SYNOPSIS
        Tests HA failover capacity.
    .DESCRIPTION
        Checks cluster DAS config and capacity.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .EXAMPLE
        PS> Test-AnyStackHaFailover
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Testing HA failover on $($vi.Name)"
            $filter = if ($ClusterName) { @{Name="*$ClusterName*"} } else { $null }
            $clusters = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType ClusterComputeResource -Filter $filter -Property Name,Summary,Configuration }
            
            foreach ($c in $clusters) {
                [PSCustomObject]@{
                    PSTypeName       = 'AnyStack.HaFailover'
                    Timestamp        = (Get-Date)
                    Server           = $vi.Name
                    Cluster          = $c.Name
                    SimulationPassed = $c.Configuration.DasConfig.Enabled
                    FailoverCapacity = $c.Summary.UsageSummary.AvailableCpuCapacity
                    HaEnabled        = $c.Configuration.DasConfig.Enabled
                    AdmissionControl = $c.Configuration.DasConfig.AdmissionControlEnabled
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
