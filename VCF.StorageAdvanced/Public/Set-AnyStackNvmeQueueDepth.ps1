function Set-AnyStackNvmeQueueDepth {
    <#
    .SYNOPSIS
        Sets NVMe queue depth.
    .DESCRIPTION
        Updates advanced option Disk.SchedNumReqOutstanding.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Name of the host.
    .PARAMETER DeviceName
        Name of the device.
    .PARAMETER QueueDepth
        New queue depth.
    .EXAMPLE
        PS> Set-AnyStackNvmeQueueDepth -HostName 'esx01' -DeviceName 'nvme0n1' -QueueDepth 64
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
        [Parameter(Mandatory=$true)]
        [string]$DeviceName,
        [Parameter(Mandatory=$true)]
        [int]$QueueDepth
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            if ($PSCmdlet.ShouldProcess($HostName, "Set Queue Depth $QueueDepth on $DeviceName")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Updating queue depth on $($vi.Name)"
                $h = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$HostName} }
                $optMgr = if ($h) { Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.AdvancedOption } } else { $null }
                
                $key = "Disk.SchedNumReqOutstanding"
                $prev = if ($optMgr) { ($optMgr.QueryView() | Where-Object { $_.Key -eq $key }).Value } else { $null }
                
                Invoke-AnyStackWithRetry -ScriptBlock { 
                    if ($optMgr) { $optMgr.UpdateValues(@([VMware.Vim.OptionValue]@{Key=$key; Value=[string]$QueueDepth})) }
                }
                
                [PSCustomObject]@{
                    PSTypeName         = 'AnyStack.NvmeQueueDepth'
                    Timestamp          = (Get-Date)
                    Server             = $vi.Name
                    Host               = $HostName
                    Device             = $DeviceName
                    PreviousQueueDepth = $prev
                    NewQueueDepth      = $QueueDepth
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
