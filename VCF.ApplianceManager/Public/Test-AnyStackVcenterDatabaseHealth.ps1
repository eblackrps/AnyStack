function Test-AnyStackVcenterDatabaseHealth {
    <#
    .SYNOPSIS
        Tests the health of the vCenter Server database.
    .DESCRIPTION
        Queries the HealthStatusManager for vCenter DB health.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Test-AnyStackVcenterDatabaseHealth
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Querying HealthStatusManager on $($vi.Name)"
            $healthMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.HealthStatusManager }
            $status = Invoke-AnyStackWithRetry -ScriptBlock { $healthMgr.QueryHealthStatus() }
            
            [PSCustomObject]@{
                PSTypeName    = 'AnyStack.VcenterDatabaseHealth'
                Timestamp     = (Get-Date)
                Server        = $vi.Name
                OverallHealth = $status.OverallHealth
                Components    = $status.RuntimeInfo | Select-Object Name, Status, Message
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

