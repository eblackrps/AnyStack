function Get-AnyStackNvmeDevice {
    <#
    .SYNOPSIS
        Gets NVMe devices.
    .DESCRIPTION
        Queries StorageSystem for NVMe disks.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Filter by host name.
    .EXAMPLE
        PS> Get-AnyStackNvmeDevice
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
        $Server,
        [Parameter(Mandatory=$false)]
        [string]$HostName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching NVMe devices on $($vi.Name)"
            $filter = if ($HostName) { @{Name="*$HostName*"} } else { $null }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter $filter -Property Name,ConfigManager }
            
            foreach ($h in $hosts) {
                $storageSystem = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.StorageSystem }
                $disks = $storageSystem.StorageDeviceInfo.ScsiLun | Where-Object { $_.LunType -eq 'disk' -and $_.Vendor -match 'NVMe' }
                
                foreach ($d in $disks) {
                    [PSCustomObject]@{
                        PSTypeName    = 'AnyStack.NvmeDevice'
                        Timestamp     = (Get-Date)
                        Server        = $vi.Name
                        Host          = $h.Name
                        DeviceName    = $d.DeviceName
                        Model         = $d.Model
                        Firmware      = $d.Revision
                        Protocol      = 'NVMe'
                        CanonicalName = $d.CanonicalName
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 


