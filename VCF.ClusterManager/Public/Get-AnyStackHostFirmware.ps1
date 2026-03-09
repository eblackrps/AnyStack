function Get-AnyStackHostFirmware {
    <#
    .SYNOPSIS
        Retrieves ESXi host firmware versions.
    .DESCRIPTION
        Queries BiosInfo and SystemInfo.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster.
    .EXAMPLE
        PS> Get-AnyStackHostFirmware
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching host firmware on $($vi.Name)"
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Property Name,Hardware.BiosInfo,Hardware.SystemInfo }
            
            foreach ($h in $hosts) {
                [PSCustomObject]@{
                    PSTypeName      = 'AnyStack.HostFirmware'
                    Timestamp       = (Get-Date)
                    Server          = $vi.Name
                    Host            = $h.Name
                    BiosVersion     = $h.Hardware.BiosInfo.BiosVersion
                    BiosReleaseDate = $h.Hardware.BiosInfo.ReleaseDate
                    Manufacturer    = $h.Hardware.SystemInfo.Vendor
                    Model           = $h.Hardware.SystemInfo.Model
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 


