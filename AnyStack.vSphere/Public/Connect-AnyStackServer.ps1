function Connect-AnyStackServer {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    <#
    .SYNOPSIS
        Establish a secure session to vCenter Server or ESXi Host for the AnyStack Infrastructure Module.

    .DESCRIPTION
        Connects to one or more vSphere servers (vCenter/ESXi) using VMware PowerCLI 13.3+.
    .INPUTS
        VMware.VimAutomation.Types.VIServer. Accepts a connected VIServer object via pipeline.
    .OUTPUTS
        PSCustomObject. Returns a result object with Timestamp, Status, and relevant data fields.
    .LINK
        https://github.com/eblackrps/AnyStack
        Optimized for vSphere 8.0 U3 (API 8.0.3) with support for modern authentication and TLS profiles.
        This function handles connection state and returns a structured object indicating success or failure.

    .PARAMETER Server
        DNS name or IP address of the vCenter Server or ESXi Host.

    .PARAMETER Credential
        PSCreadential object for authentication. If not provided, current session credentials or stored credentials will be used.

    .PARAMETER SaveCredential
        If specified, the credential will be saved for future sessions (PowerCLI default behavior).

    .EXAMPLE
        Connect-AnyStackServer -Server 'vcenter.anystack.local' -Credential (Get-Credential)
        Connects to the specified vCenter with the provided credentials.

    .EXAMPLE
        Connect-AnyStackServer -Server '10.10.1.50'
        Connects to an ESXi host using current Windows session credentials (SSO).

    .NOTES
        Author: The Any Stack Architect
        Version: 1.0.0.0
        Namespace: AnyStack.vSphere
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Server,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(Mandatory = $false)]
        [switch]$SaveCredential
    )

    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        foreach ($srv in $Server) {
            $Result = [PSCustomObject]@{
                Timestamp = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                Server    = $srv
                Status    = 'Connecting'
                SessionID = $null
                Error     = $null
            }

            try {
                # Connection parameters
                $ConnectArgs = @{
                    Server = $srv
                    ErrorAction = 'Stop'
                }
                if ($PSBoundParameters.ContainsKey('Credential')) {
                    $ConnectArgs.Credential = $Credential
                }
                if ($SaveCredential) {
                    $ConnectArgs.SaveCredentials = $true
                }

                Write-Verbose "Attempting to connect to vSphere Server: $srv"

                # Execute PowerCLI connection
                $Session = Connect-VIServer @ConnectArgs

                $Result.Status    = 'Connected'
                $Result.SessionID = $Session.SessionId
                $Result.Version   = "$($Session.Version) Build $($Session.Build)"

                Write-Verbose "Successfully connected to $srv (Version: $($Session.Version))"
                Write-Output $Result
            }
            catch {
                $Result.Status = 'Failed'
                $Result.Error  = $_.Exception.Message
                Write-Error "Connection to $srv failed: $($_.Exception.Message)"
                Write-Output $Result
            }
        }
    }
}



