function Get-AnyStackActiveAlarm {
    <#
    .SYNOPSIS
        Retrieves actively triggered vCenter Alarms across the hierarchy.
    .DESCRIPTION
        Round 8: VCF.AlarmManager. Uses the vCenter AlarmManager ExtensionData to 
        rapidly fetch triggered alarms (Red/Yellow states) without crawling individual entities.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] $Server
    )
    process {
        $ErrorActionPreference = 'Stop'
        Write-Verbose "Fetching triggered alarms from AlarmManager..."
        
        # Access the root folder and AlarmManager
        $si = Get-View ServiceInstance -Server $Server
        $alarmManager = Get-View $si.Content.AlarmManager -Server $Server
        
        # Get alarmed entities starting from Root
        $triggered = $alarmManager.GetAlarmState($si.Content.RootFolder)
        
        foreach ($alarmState in $triggered) {
            if ($alarmState.OverallStatus -ne "green") {
                $entity = Get-View -Id $alarmState.Entity -Property Name
                $alarmDef = Get-View -Id $alarmState.Alarm -Property Info
                
                [PSCustomObject]@{
                    EntityName   = $entity.Name
                    EntityType   = $alarmState.Entity.Type
                    AlarmName    = $alarmDef.Info.Name
                    Status       = $alarmState.OverallStatus
                    TriggerTime  = $alarmState.Time
                    Acknowledged = $alarmState.Acknowledged
                }
            }
        }
    }
}
