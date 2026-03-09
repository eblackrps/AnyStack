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
            $targets = if ($Server) { 
                if ($Server -is [string]) { Get-VIServer -Name $Server } else { $Server }
            } else { $global:DefaultVIServers }

            foreach ($srv in $targets) {
                if ($PSCmdlet.ShouldProcess($srv.Name, "Disconnect from vSphere")) {
                    Write-Verbose "[$($MyInvocation.MyCommand.Name)] Disconnecting from $($srv.Name)"
                    Invoke-AnyStackWithRetry -ScriptBlock { Disconnect-VIServer -Server $srv -Confirm:$false }
                    
                    [PSCustomObject]@{
                        PSTypeName = 'AnyStack.Disconnection'
                        Timestamp  = (Get-Date)
                        Status     = 'Disconnected'
                        Server     = $srv.Name
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
 


