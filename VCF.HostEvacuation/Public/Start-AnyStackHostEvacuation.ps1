function Start-AnyStackHostEvacuation {
    <#
    .SYNOPSIS
        Starts host evacuation (Maintenance Mode).
    .DESCRIPTION
        Enters maintenance mode with specified vSAN migration mode.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Name of the host.
    .PARAMETER VsanMode
        vSAN migration mode (full, ensureAccessibility, noAction).
    .PARAMETER TimeoutSeconds
        Wait timeout.
    .EXAMPLE
        PS> Start-AnyStackHostEvacuation -HostName 'esx01'
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
        [ValidateSet('full','ensureAccessibility','noAction')]
        [string]$VsanMode = 'ensureAccessibility',
        [Parameter(Mandatory=$false)]
        [int]$TimeoutSeconds = 3600
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            if ($PSCmdlet.ShouldProcess($HostName, "Enter Maintenance Mode with $VsanMode")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Evacuating host on $($vi.Name)"
                $h = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$HostName} }
                
                $taskRef = Invoke-AnyStackWithRetry -ScriptBlock {
                    $spec = New-Object VMware.Vim.MaintenanceSpec
                    $spec.VsanMode = New-Object VMware.Vim.VsanHostDecommissionMode
                    $spec.VsanMode.ObjectAction = $VsanMode
                    if ($h) { $h.EnterMaintenanceMode_Task(15, $true, $spec) } else { $null }
                }
                if ($taskRef) {
                    $task = Get-Task -Id $taskRef.Value -Server $vi
                    $task | Wait-Task -TimeoutSeconds $TimeoutSeconds | Out-Null
                }
                
                [PSCustomObject]@{
                    PSTypeName        = 'AnyStack.HostEvacuation'
                    Timestamp         = (Get-Date)
                    Server            = $vi.Name
                    Host              = $HostName
                    MaintenanceMode   = $true
                    vSanMigrationMode = $VsanMode
                    Duration          = 'Completed'
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
