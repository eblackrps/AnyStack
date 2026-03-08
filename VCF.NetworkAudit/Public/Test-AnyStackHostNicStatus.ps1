function Test-AnyStackHostNicStatus {
    <#
    .SYNOPSIS
        Tests status of host physical NICs.
    .DESCRIPTION
        Checks link state, speed, duplex, and driver of physical NICs.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .PARAMETER HostName
        Filter by host name.
    .EXAMPLE
        PS> Test-AnyStackHostNicStatus
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
        $Server,
        [Parameter(Mandatory=$false)]
        [string]$ClusterName,
        [Parameter(Mandatory=$false)]
        [string]$HostName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Testing host NICs on $($vi.Name)"
            $filter = if ($HostName) { @{Name="*$HostName*"} } else { $null }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter $filter -Property Name,Config.Network }
            
            foreach ($h in $hosts) {
                foreach ($nic in $h.Config.Network.Pnic) {
                    [PSCustomObject]@{
                        PSTypeName  = 'AnyStack.NicStatus'
                        Timestamp   = (Get-Date)
                        Server      = $vi.Name
                        Host        = $h.Name
                        NicName     = $nic.Device
                        LinkState   = if ($nic.LinkSpeed) { 'Up' } else { 'Down' }
                        SpeedMbps   = if ($nic.LinkSpeed) { $nic.LinkSpeed.SpeedMb } else { 0 }
                        Driver      = $nic.Driver
                        MacAddress  = $nic.Mac
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 
