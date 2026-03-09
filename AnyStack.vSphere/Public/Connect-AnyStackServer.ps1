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
        VMware.VimAutomation.Types.VIServer
    .NOTES
        Author: The AnyStack Architect
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([VMware.VimAutomation.Types.VIServer])]
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
                
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Connected to $srv | Session: $($session.SessionId) | Version: $($session.Version) Build $($session.Build)"
                $session
            }
            catch {
                $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_.Exception, 'ConnectionFailed', [System.Management.Automation.ErrorCategory]::ConnectionError, $srv))
            }
        }
    }
}
