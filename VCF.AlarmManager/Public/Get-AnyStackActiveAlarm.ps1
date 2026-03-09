function Get-AnyStackActiveAlarm {
    <#
    .SYNOPSIS
        Retrieves active alarms from the connected vCenter.
    .DESCRIPTION
        Queries the AlarmManager for all triggered alarms and their status.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Get-AnyStackActiveAlarm
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching active alarms on $($vi.Name)"
            $alarmManager = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Id $vi.ExtensionData.Content.AlarmManager -Server $vi }
            $alarms = Invoke-AnyStackWithRetry -ScriptBlock { $alarmManager.GetAlarmState($null) }
            
            foreach ($a in $alarms) {
                $alarmInfo = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Id $a.Alarm -Property Info -Server $vi }
                [PSCustomObject]@{
                    PSTypeName         = 'AnyStack.ActiveAlarm'
                    Timestamp          = (Get-Date)
                    Server             = $vi.Name
                    Entity             = $a.Entity.Value
                    AlarmName          = $alarmInfo.Info.Name
                    Status             = $a.OverallStatus
                    Time               = $a.Time
                    AcknowledgedByUser = $a.AcknowledgedByUser
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
