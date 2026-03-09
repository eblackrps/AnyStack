function Test-AnyStackProactiveHa {
    <#
    .SYNOPSIS
        Tests proactive HA configuration.
    .DESCRIPTION
        Checks cluster ProactiveDrsConfig.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .EXAMPLE
        PS> Test-AnyStackProactiveHa
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Testing Proactive HA on $($vi.Name)"
            $filter = if ($ClusterName) { @{Name="*$ClusterName*"} } else { $null }
            $clusters = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType ClusterComputeResource -Filter $filter -Property Name,Configuration }
            
            foreach ($c in $clusters) {
                $proHa = $c.Configuration.ProactiveDrsConfig
                [PSCustomObject]@{
                    PSTypeName      = 'AnyStack.ProactiveHa'
                    Timestamp       = (Get-Date)
                    Server          = $vi.Name
                    Cluster         = $c.Name
                    Enabled         = $proHa.Enabled
                    RemediationMode = if ($proHa) { $proHa.VmRemediation } else { 'Unknown' }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 


