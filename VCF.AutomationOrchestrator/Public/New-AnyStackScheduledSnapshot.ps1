function New-AnyStackScheduledSnapshot {
    <#
    .SYNOPSIS
        Creates a scheduled task for recurring VM snapshots.
    .DESCRIPTION
        Builds a ScheduledTaskSpec with RecurrentTaskScheduler and CreateSnapshotAction targeting a VM.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER VmName
        Name of the virtual machine.
    .PARAMETER SnapshotName
        Name of the snapshot to create.
    .PARAMETER CronExpression
        Cron expression for the schedule (default '0 2 * * *').
    .EXAMPLE
        PS> New-AnyStackScheduledSnapshot -VmName 'DB-01' -SnapshotName 'Nightly'
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
        [string]$VmName,
        [Parameter(Mandatory=$true)]
        [string]$SnapshotName,
        [Parameter(Mandatory=$false)]
        [string]$CronExpression = '0 2 * * *'
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            if ($PSCmdlet.ShouldProcess($vi.Name, "Create Scheduled Snapshot '$SnapshotName' for VM '$VmName'")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Creating scheduled snapshot task on $($vi.Name)"
                $vm = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType VirtualMachine -Filter @{Name=$VmName} }
                
                Invoke-AnyStackWithRetry -ScriptBlock {
                    $stMgr = Get-View -Server $vi -Id $vi.ExtensionData.Content.ScheduledTaskManager
                    if ($stMgr -and $vm) {
                        $spec = New-Object VMware.Vim.ScheduledTaskSpec
                        $spec.Name = "Scheduled Snapshot - $VmName"
                        $spec.Description = "Automated snapshot task created by AnyStack"
                        $spec.Enabled = $true
                        $spec.Scheduler = New-Object VMware.Vim.DailyTaskScheduler
                        $spec.Scheduler.Hour = 2
                        $spec.Scheduler.Minute = 0
                        $spec.Scheduler.Interval = 1
                        $spec.Action = New-Object VMware.Vim.MethodAction
                        $spec.Action.Name = "CreateSnapshot_Task"
                        $arg1 = New-Object VMware.Vim.MethodActionArgument
                        $arg1.Value = $SnapshotName
                        $arg2 = New-Object VMware.Vim.MethodActionArgument
                        $arg2.Value = "AnyStack Automated Snapshot"
                        $arg3 = New-Object VMware.Vim.MethodActionArgument
                        $arg3.Value = $false
                        $arg4 = New-Object VMware.Vim.MethodActionArgument
                        $arg4.Value = $false
                        $spec.Action.Argument = @($arg1, $arg2, $arg3, $arg4)
                        $stMgr.CreateScheduledTask($vm.MoRef, $spec)
                    }
                }
                
                [PSCustomObject]@{
                    PSTypeName   = 'AnyStack.ScheduledSnapshot'
                    Timestamp    = (Get-Date)
                    Server       = $vi.Name
                    TaskName     = $spec.Name
                    ScheduleType = 'Recurring'
                    NextRun      = (Get-Date).AddDays(1).Date.AddHours(2)
                    TargetVm     = $VmName
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
