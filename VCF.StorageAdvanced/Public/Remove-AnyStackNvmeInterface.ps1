function Remove-AnyStackNvmeInterface {
    <#
    .SYNOPSIS
        Removes an NVMe adapter.
    .DESCRIPTION
        Calls RemoveNvmeOverRdmaAdapter.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Name of the host.
    .PARAMETER AdapterName
        Name of the adapter to remove.
    .EXAMPLE
        PS> Remove-AnyStackNvmeInterface -HostName 'esx01' -AdapterName 'vmhba64'
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
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
        [string]$AdapterName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($HostName, "Remove NVMe Adapter $AdapterName")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Removing NVMe adapter on $($vi.Name)"
                $h = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$HostName} }
                $storageSystem = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.StorageSystem }
                
                Invoke-AnyStackWithRetry -ScriptBlock { $storageSystem.RemoveNvmeOverRdmaAdapter($AdapterName) }
                
                [PSCustomObject]@{
                    PSTypeName  = 'AnyStack.RemovedNvmeAdapter'
                    Timestamp   = (Get-Date)
                    Server      = $vi.Name
                    Host        = $HostName
                    AdapterName = $AdapterName
                    Removed     = $true
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
