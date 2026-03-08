function Get-AnyStackActiveAlarm {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    <#
    .SYNOPSIS
        Query TriggeredAlarmState from AlarmManager view.
    .EXAMPLE
        PS> Get-AnyStackActiveAlarm -Server 'vcenter.corp.local'
        Executes the Get-AnyStackActiveAlarm command.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false)]
        [string]$Server
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
    }
    process {
        try {
            Write-Verbose "Executing Get-AnyStackActiveAlarm"
            $result = Invoke-AnyStackWithRetry -ScriptBlock {
                $alarmManager = Get-View -Id $vi.ExtensionData.Content.AlarmManager -Server $vi
                $alarmManager.GetAlarmState($null) | ForEach-Object {
                    [PSCustomObject]@{
                        Entity = $_.Entity.Value
                        AlarmName = (Get-View -Id $_.Alarm -Property Info -Server $vi).Info.Name
                        Status = $_.OverallStatus
                        Time = $_.Time
                        AcknowledgedByUser = $_.AcknowledgedByUser
                    }
                }
            }
            $result
        }
        catch [VMware.VimAutomation.ViCore.Types.V1.ErrorHandling.InvalidLogin] {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'AuthenticationError', [System.Management.Automation.ErrorCategory]::AuthenticationError, $Server))
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $Server))
        }
    }
}

