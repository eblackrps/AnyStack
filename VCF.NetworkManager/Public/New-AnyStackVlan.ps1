function New-AnyStackVlan {
    <#
    .SYNOPSIS
        Creates a new distributed portgroup.
    .DESCRIPTION
        Adds a portgroup to a DVS with a specific VLAN ID.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER PortGroupName
        Name of the new portgroup.
    .PARAMETER VlanId
        VLAN ID.
    .PARAMETER DvsName
        Name of the Distributed Virtual Switch.
    .PARAMETER NumPorts
        Number of ports (default 128).
    .EXAMPLE
        PS> New-AnyStackVlan -PortGroupName 'VLAN-100' -VlanId 100 -DvsName 'DVS-Prod'
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
        [string]$PortGroupName,
        [Parameter(Mandatory=$true)]
        [int]$VlanId,
        [Parameter(Mandatory=$true)]
        [string]$DvsName,
        [Parameter(Mandatory=$false)]
        [int]$NumPorts = 128
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            if ($PSCmdlet.ShouldProcess($DvsName, "Create Portgroup $PortGroupName (VLAN $VlanId)")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Creating VLAN on $($vi.Name)"
                $dvs = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType DistributedVirtualSwitch -Filter @{Name=$DvsName} }
                
                $spec = New-Object VMware.Vim.DVPortgroupConfigSpec
                $spec.Name = $PortGroupName
                $spec.NumPorts = $NumPorts
                $spec.Type = 'earlyBinding'
                
                $spec.DefaultPortConfig = New-Object VMware.Vim.VMwareDVSPortSetting
                $spec.DefaultPortConfig.Vlan = New-Object VMware.Vim.VmwareDistributedVirtualSwitchVlanIdSpec
                $spec.DefaultPortConfig.Vlan.VlanId = $VlanId
                
                Invoke-AnyStackWithRetry -ScriptBlock { $dvs.AddDVPortgroup_Task(@($spec)) }
                
                [PSCustomObject]@{
                    PSTypeName    = 'AnyStack.VlanConfig'
                    Timestamp     = (Get-Date)
                    Server        = $vi.Name
                    PortGroupName = $PortGroupName
                    VlanId        = $VlanId
                    DvsName       = $DvsName
                    NumPorts      = $NumPorts
                    Created       = $true
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
