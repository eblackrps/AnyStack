function Disconnect-AnyStackServer {
    <#
    .SYNOPSIS
        Terminate existing sessions to vCenter Server or ESXi Host.

    .DESCRIPTION
        Safely closes one or more active VIServer connections, preventing session leakage and maintaining infrastructure security.
        Optimized for multi-server environments.

    .PARAMETER Server
        Specifies the server(s) to disconnect. If omitted, all active sessions are terminated.

    .EXAMPLE
        Disconnect-AnyStackServer -Server 'vcenter.anystack.local'
        Disconnects the specified server session.

    .EXAMPLE
        Disconnect-AnyStackServer
        Disconnects all currently connected vSphere servers.

    .NOTES
        Author: The Any Stack Architect
        Version: 1.0.0.0
        Namespace: AnyStack.vSphere
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string[]]$Server
    )

    process {
        $ErrorActionPreference = 'Stop'
        try {
            if ($PSBoundParameters.ContainsKey('Server')) {
                foreach ($srv in $Server) {
                    Write-Verbose "Disconnecting from server: $srv"
                    Disconnect-VIServer -Server $srv -Confirm:$false -ErrorAction Stop
                }
            }
            else {
                Write-Verbose "Disconnecting from ALL vSphere servers."
                Disconnect-VIServer -Server * -Confirm:$false -ErrorAction SilentlyContinue
            }
            
            # Return success object
            [PSCustomObject]@{
                Timestamp = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Operation = 'Disconnect'
                Status    = 'Success'
            }
        }
        catch {
            Write-Error "Failed to disconnect: $($_.Exception.Message)"
            [PSCustomObject]@{
                Timestamp = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Operation = 'Disconnect'
                Status    = 'Failed'
                Error     = $_.Exception.Message
            }
        }
    }
}

