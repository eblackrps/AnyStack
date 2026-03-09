function Test-AnyStackHostSyslog {
    <#
    .SYNOPSIS
        Tests host syslog configuration.
    .DESCRIPTION
        Checks Syslog.global.logHost.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster.
    .PARAMETER HostName
        Filter by host name.
    .EXAMPLE
        PS> Test-AnyStackHostSyslog
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Testing syslog on $($vi.Name)"
            $filter = if ($HostName) { @{Name="*$HostName*"} } else { $null }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter $filter -Property Name,ConfigManager }
            
            foreach ($h in $hosts) {
                $optMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.AdvancedOption }
                $val = ($optMgr.QueryView() | Where-Object { $_.Key -eq 'Syslog.global.logHost' }).Value
                
                [PSCustomObject]@{
                    PSTypeName   = 'AnyStack.SyslogTest'
                    Timestamp    = (Get-Date)
                    Server       = $vi.Name
                    Host         = $h.Name
                    SyslogServer = $val
                    Configured   = ($val -ne '')
                    Reachable    = ($val -ne '')
                    Protocol     = 'UDP'
                    Port         = 514
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Test-AnyStackHostSyslog {
    <#
    .SYNOPSIS
        Tests host syslog configuration.
    .DESCRIPTION
        Checks Syslog.global.logHost.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster.
    .PARAMETER HostName
        Filter by host name.
    .EXAMPLE
        PS> Test-AnyStackHostSyslog
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Testing syslog on $($vi.Name)"
            $filter = if ($HostName) { @{Name="*$HostName*"} } else { $null }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter $filter -Property Name,ConfigManager }
            
            foreach ($h in $hosts) {
                $optMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.AdvancedOption }
                $val = ($optMgr.QueryView() | Where-Object { $_.Key -eq 'Syslog.global.logHost' }).Value
                
                [PSCustomObject]@{
                    PSTypeName   = 'AnyStack.SyslogTest'
                    Timestamp    = (Get-Date)
                    Server       = $vi.Name
                    Host         = $h.Name
                    SyslogServer = $val
                    Configured   = ($val -ne '')
                    Reachable    = ($val -ne '')
                    Protocol     = 'UDP'
                    Port         = 514
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Test-AnyStackHostSyslog {
    <#
    .SYNOPSIS
        Tests host syslog configuration.
    .DESCRIPTION
        Checks Syslog.global.logHost.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster.
    .PARAMETER HostName
        Filter by host name.
    .EXAMPLE
        PS> Test-AnyStackHostSyslog
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Testing syslog on $($vi.Name)"
            $filter = if ($HostName) { @{Name="*$HostName*"} } else { $null }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter $filter -Property Name,ConfigManager }
            
            foreach ($h in $hosts) {
                $optMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.AdvancedOption }
                $val = ($optMgr.QueryView() | Where-Object { $_.Key -eq 'Syslog.global.logHost' }).Value
                
                [PSCustomObject]@{
                    PSTypeName   = 'AnyStack.SyslogTest'
                    Timestamp    = (Get-Date)
                    Server       = $vi.Name
                    Host         = $h.Name
                    SyslogServer = $val
                    Configured   = ($val -ne '')
                    Reachable    = ($val -ne '')
                    Protocol     = 'UDP'
                    Port         = 514
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Test-AnyStackHostSyslog {
    <#
    .SYNOPSIS
        Tests host syslog configuration.
    .DESCRIPTION
        Checks Syslog.global.logHost.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster.
    .PARAMETER HostName
        Filter by host name.
    .EXAMPLE
        PS> Test-AnyStackHostSyslog
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Testing syslog on $($vi.Name)"
            $filter = if ($HostName) { @{Name="*$HostName*"} } else { $null }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter $filter -Property Name,ConfigManager }
            
            foreach ($h in $hosts) {
                $optMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.AdvancedOption }
                $val = ($optMgr.QueryView() | Where-Object { $_.Key -eq 'Syslog.global.logHost' }).Value
                
                [PSCustomObject]@{
                    PSTypeName   = 'AnyStack.SyslogTest'
                    Timestamp    = (Get-Date)
                    Server       = $vi.Name
                    Host         = $h.Name
                    SyslogServer = $val
                    Configured   = ($val -ne '')
                    Reachable    = ($val -ne '')
                    Protocol     = 'UDP'
                    Port         = 514
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 




.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 




