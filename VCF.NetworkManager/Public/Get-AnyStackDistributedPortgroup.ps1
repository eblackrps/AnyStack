function Get-AnyStackDistributedPortgroup {
    <#
    .SYNOPSIS
        Lists Distributed Portgroups and their configuration.
    .DESCRIPTION
        Retrieves all portgroups from distributed switches.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Get-AnyStackDistributedPortgroup
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching portgroups on $($vi.Name)"
            $pgs = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType DistributedVirtualPortgroup -Property Name,Config }
            
            foreach ($pg in $pgs) {
                [PSCustomObject]@{
                    PSTypeName    = 'AnyStack.Portgroup'
                    Timestamp     = (Get-Date)
                    Server        = $vi.Name
                    PortgroupName = $pg.Name
                    VlanId        = $pg.Config.DefaultPortConfig.Vlan.VlanId
                    NumPorts      = $pg.Config.NumPorts
                    Switch        = $pg.Config.DistributedVirtualSwitch.Value
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
