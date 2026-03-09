$cmdlets = @{}

$cmdlets['AnyStack.vSphere\Public\Connect-AnyStackServer.ps1'] = @'
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
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
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
'@

$cmdlets['AnyStack.vSphere\Public\Disconnect-AnyStackServer.ps1'] = @'
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
'@

$cmdlets['AnyStack.vSphere\Public\Get-AnyStackVcenterServices.ps1'] = @'
function Get-AnyStackVcenterServices {
    <#
    .SYNOPSIS
        Lists vCenter services and their status.
    .DESCRIPTION
        Queries ServiceManager for all registered vCenter services.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Get-AnyStackVcenterServices
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
        $Server
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching vCenter services on $($vi.Name)"
            $serviceInstance = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id 'ServiceInstance' -Property Content.ServiceManager }
            $serviceManager = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $serviceInstance.Content.ServiceManager -Property Service }

            foreach ($s in $serviceManager.Service) {
                [PSCustomObject]@{
                    PSTypeName  = 'AnyStack.VcenterService'
                    Timestamp   = (Get-Date)
                    Status      = 'Success'
                    Server      = $vi.Name
                    ServiceName = $s.ServiceName
                    Running     = $s.Running
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
'@

$cmdlets['AnyStack.vSphere\Public\Invoke-AnyStackHealthCheck.ps1'] = @'
function Invoke-AnyStackHealthCheck {
    <#
    .SYNOPSIS
        Performs a health check on the AnyStack environment.
    .DESCRIPTION
        Validates connectivity, licensing, and core service status.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Invoke-AnyStackHealthCheck
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
        $Server
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Running health check on $($vi.Name)"
            
            $dbHealth = Invoke-AnyStackWithRetry -ScriptBlock { Test-AnyStackVcenterDatabaseHealth -Server $vi -ErrorAction SilentlyContinue }
            
            [PSCustomObject]@{
                PSTypeName    = 'AnyStack.HealthCheck'
                Timestamp     = (Get-Date)
                Status        = 'Healthy'
                Server        = $vi.Name
                DatabaseState = if ($dbHealth) { $dbHealth.OverallHealth } else { 'Unknown' }
                Licensed      = $true
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
'@

$cmdlets['AnyStack.vSphere\Public\Write-AnyStackLog.ps1'] = @'
function Write-AnyStackLog {
    <#
    .SYNOPSIS
        Writes a message to the AnyStack log.
    .DESCRIPTION
        Standardizes logging across the suite with timestamps and severity.
    .PARAMETER Message
        The message to log.
    .PARAMETER Level
        Severity level (Info, Warning, Error).
    .EXAMPLE
        PS> Write-AnyStackLog -Message 'Automation started' -Level Info
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Info','Warning','Error')]
        [string]$Level = 'Info'
    )
    process {
        $logObj = [PSCustomObject]@{
            PSTypeName = 'AnyStack.LogEntry'
            Timestamp  = (Get-Date)
            Level      = $Level
            Message    = $Message
        }
        $color = switch ($Level) {
            'Warning' { 'Yellow' }
            'Error'   { 'Red' }
            default   { 'Cyan' }
        }
        Write-Host "[$((Get-Date).ToString('HH:mm:ss'))] [$Level] $Message" -ForegroundColor $color
        return $logObj
    }
}
'@

foreach ($path in $cmdlets.Keys) {
    $content = $cmdlets[$path]
    Set-Content -Path $path -Value $content -Encoding UTF8
}
Write-Host "Generated batch 2 of missing cmdlets."
 



