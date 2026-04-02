function Get-AnyStackFailedScheduledTask {
    <#
    .SYNOPSIS
        Retrieves failed scheduled tasks in vCenter.
    .DESCRIPTION
        Queries the ScheduledTaskManager for tasks with an error state.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Get-AnyStackFailedScheduledTask
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
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching scheduled tasks on $($vi.Name)"
            $stMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.ScheduledTaskManager }
            
            if ($stMgr.ScheduledTask) {
                $tasks = Invoke-AnyStackWithRetry -ScriptBlock {
                    $stMgr.ScheduledTask | ForEach-Object { Get-View -Server $vi -Id $_ -Property Info }
                }
                
                $tasks | Where-Object { $_.Info.State -eq 'error' } | ForEach-Object {
                    [PSCustomObject]@{
                        PSTypeName     = 'AnyStack.FailedScheduledTask'
                        Timestamp      = (Get-Date)
                        Server         = $vi.Name
                        TaskName       = $_.Info.Name
                        LastRun        = $_.Info.LastModifiedTime
                        NextRun        = $_.Info.NextRunTime
                        ErrorMessage   = $_.Info.Error.LocalizedMessage
                        AffectedObject = $_.Info.Entity.Value
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
