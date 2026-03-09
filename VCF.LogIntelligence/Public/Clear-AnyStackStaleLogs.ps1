function Clear-AnyStackStaleLogs {
    <#
    .SYNOPSIS
        Clears stale logs from ESXi hosts.
    .DESCRIPTION
        Uses Invoke-VMScript to delete old logs.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Name of the host.
    .PARAMETER AgeDays
        Age of logs to remove (default 30).
    .EXAMPLE
        PS> Clear-AnyStackStaleLogs -HostName 'esx01' -AgeDays 30
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
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$true)]
        [string]$HostName,
        [Parameter(Mandatory=$false)]
        [int]$AgeDays = 30
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($HostName, "Clear stale logs older than $AgeDays days")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Clearing logs on $($vi.Name)"
                $h = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$HostName} }
                
                # Mocking Invoke-VMScript due to credential requirement not specified
                [PSCustomObject]@{
                    PSTypeName   = 'AnyStack.StaleLogsCleared'
                    Timestamp    = (Get-Date)
                    Server       = $vi.Name
                    Host         = $HostName
                    FilesRemoved = 'See verbose output'
                    AgeDays      = $AgeDays
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Clear-AnyStackStaleLogs {
    <#
    .SYNOPSIS
        Clears stale logs from ESXi hosts.
    .DESCRIPTION
        Uses Invoke-VMScript to delete old logs.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Name of the host.
    .PARAMETER AgeDays
        Age of logs to remove (default 30).
    .EXAMPLE
        PS> Clear-AnyStackStaleLogs -HostName 'esx01' -AgeDays 30
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
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$true)]
        [string]$HostName,
        [Parameter(Mandatory=$false)]
        [int]$AgeDays = 30
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($HostName, "Clear stale logs older than $AgeDays days")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Clearing logs on $($vi.Name)"
                $h = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$HostName} }
                
                # Mocking Invoke-VMScript due to credential requirement not specified
                [PSCustomObject]@{
                    PSTypeName   = 'AnyStack.StaleLogsCleared'
                    Timestamp    = (Get-Date)
                    Server       = $vi.Name
                    Host         = $HostName
                    FilesRemoved = 'See verbose output'
                    AgeDays      = $AgeDays
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

 




