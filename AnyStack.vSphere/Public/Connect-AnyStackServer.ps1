function Connect-AnyStackServer {
    <#
    .SYNOPSIS
        Connects to a vCenter Server or ESXi host.
    .DESCRIPTION
        Establishes a session using Connect-VIServer.
    .PARAMETER Server
        DNS name or IP of the server.
    .PARAMETER Credential
        PSCredential object for authentication.
    .EXAMPLE
        PS> Connect-AnyStackServer -Server 'vcenter.corp.local' -Credential (Get-Credential)
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Server,
        [Parameter(Mandatory=$false)]
        [System.Management.Automation.PSCredential]$Credential
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        foreach ($srv in $Server) {
            try {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Attempting connection to $srv"
                $connArgs = @{ Server = $srv; ErrorAction = 'Stop' }
                if ($Credential) { $connArgs.Credential = $Credential }
                
                $session = Invoke-AnyStackWithRetry -ScriptBlock { Connect-VIServer @connArgs }
                
                [PSCustomObject]@{
                    PSTypeName = 'AnyStack.Connection'
                    Timestamp  = (Get-Date)
                    Status     = 'Connected'
                    Server     = $srv
                    SessionID  = $session.SessionId
                    Version    = "$($session.Version) Build $($session.Build)"
                }
            }
            catch {
                Write-Error "Connection to $srv failed: $($_.Exception.Message)"
                [PSCustomObject]@{
                    PSTypeName = 'AnyStack.Connection'
                    Timestamp  = (Get-Date)
                    Status     = 'Failed'
                    Server     = $srv
                    Error      = $_.Exception.Message
                }
            }
        }
    }
}


 

