function Disconnect-AnyStackServer {
    <#
    .SYNOPSIS
        Disconnects from a vCenter Server or ESXi host.
    .DESCRIPTION
        Closes the active session using Disconnect-VIServer.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses all active connections if omitted.
    .EXAMPLE
        PS> Disconnect-AnyStackServer
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        $Server
    )
    process {
        try {
            $vi = Get-AnyStackConnection -Server $Server
            if ($PSCmdlet.ShouldProcess($vi.Name, "Disconnect from vSphere")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Disconnecting from $($vi.Name)"
                Invoke-AnyStackWithRetry -ScriptBlock { Disconnect-VIServer -Server $vi -Confirm:$false }
                
                [PSCustomObject]@{
                    PSTypeName = 'AnyStack.Disconnection'
                    Timestamp  = (Get-Date)
                    Status     = 'Disconnected'
                    Server     = $vi.Name
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
