function Disconnect-AnyStackServer {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    <#
    .SYNOPSIS
        Terminate existing sessions to vCenter Server or ESXi Host.

    .DESCRIPTION
        Safely closes one or more active VIServer connections, preventing session leakage and maintaining infrastructure security.
    .INPUTS
        VMware.VimAutomation.Types.VIServer. Accepts a connected VIServer object via pipeline.
    .OUTPUTS
        PSCustomObject. Returns a result object with Timestamp, Status, and relevant data fields.
    .LINK
        https://github.com/eblackrps/AnyStack
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
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string[]]$Server
    )

    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
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


