function Add-AnyStackNvmeInterface {
    <#
    .SYNOPSIS
        Adds an NVMe adapter.
    .DESCRIPTION
        Adds NVMe over RDMA or TCP adapter on Host.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Name of the host.
    .PARAMETER Protocol
        Protocol: RDMA or TCP.
    .PARAMETER TargetAddress
        Address of target.
    .EXAMPLE
        PS> Add-AnyStackNvmeInterface -HostName 'esx01' -Protocol TCP -TargetAddress '10.0.0.1'
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
        [ValidateSet('RDMA','TCP')]
        [string]$Protocol,
        [Parameter(Mandatory=$true)]
        [string]$TargetAddress
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($HostName, "Add NVMe $Protocol Adapter to $TargetAddress")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Adding NVMe adapter on $($vi.Name)"
                $h = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$HostName} }
                $storageSystem = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.StorageSystem }
                
                Invoke-AnyStackWithRetry -ScriptBlock {
                    if ($Protocol -eq 'RDMA') { $storageSystem.AddNvmeOverRdmaAdapter($TargetAddress) }
                    else { $storageSystem.AddNvmeTcpAdapter($TargetAddress) }
                }
                
                [PSCustomObject]@{
                    PSTypeName    = 'AnyStack.NvmeAdapter'
                    Timestamp     = (Get-Date)
                    Server        = $vi.Name
                    Host          = $HostName
                    AdapterType   = $Protocol
                    TargetAddress = $TargetAddress
                    Status        = 'Added'
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

