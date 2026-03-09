function Set-AnyStackVlanTag {
    <#
    .SYNOPSIS
        Updates VLAN ID on an existing portgroup.
    .DESCRIPTION
        Reconfigures a DVPortgroup to use a new VLAN ID.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER PortGroupName
        Name of the portgroup.
    .PARAMETER NewVlanId
        The new VLAN ID.
    .EXAMPLE
        PS> Set-AnyStackVlanTag -PortGroupName 'VLAN-100' -NewVlanId 101
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
        [int]$NewVlanId
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($PortGroupName, "Update VLAN ID to $NewVlanId")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Updating VLAN on $($vi.Name)"
                $pg = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType DistributedVirtualPortgroup -Filter @{Name=$PortGroupName} }
                $oldVlan = if ($pg.Config.DefaultPortConfig.Vlan.VlanId) { $pg.Config.DefaultPortConfig.Vlan.VlanId } else { 0 }
                
                $spec = New-Object VMware.Vim.DVPortgroupConfigSpec
                $spec.ConfigVersion = $pg.Config.ConfigVersion
                $spec.DefaultPortConfig = New-Object VMware.Vim.VMwareDVSPortSetting
                $spec.DefaultPortConfig.Vlan = New-Object VMware.Vim.VmwareDistributedVirtualSwitchVlanIdSpec
                $spec.DefaultPortConfig.Vlan.VlanId = $NewVlanId
                
                Invoke-AnyStackWithRetry -ScriptBlock { $pg.ReconfigureDVPortgroup_Task($spec) }
                
                [PSCustomObject]@{
                    PSTypeName     = 'AnyStack.VlanUpdate'
                    Timestamp      = (Get-Date)
                    Server         = $vi.Name
                    PortGroupName  = $PortGroupName
                    PreviousVlanId = $oldVlan
                    NewVlanId      = $NewVlanId
                    Applied        = $true
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Set-AnyStackVlanTag {
    <#
    .SYNOPSIS
        Updates VLAN ID on an existing portgroup.
    .DESCRIPTION
        Reconfigures a DVPortgroup to use a new VLAN ID.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER PortGroupName
        Name of the portgroup.
    .PARAMETER NewVlanId
        The new VLAN ID.
    .EXAMPLE
        PS> Set-AnyStackVlanTag -PortGroupName 'VLAN-100' -NewVlanId 101
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
        [int]$NewVlanId
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($PortGroupName, "Update VLAN ID to $NewVlanId")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Updating VLAN on $($vi.Name)"
                $pg = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType DistributedVirtualPortgroup -Filter @{Name=$PortGroupName} }
                $oldVlan = if ($pg.Config.DefaultPortConfig.Vlan.VlanId) { $pg.Config.DefaultPortConfig.Vlan.VlanId } else { 0 }
                
                $spec = New-Object VMware.Vim.DVPortgroupConfigSpec
                $spec.ConfigVersion = $pg.Config.ConfigVersion
                $spec.DefaultPortConfig = New-Object VMware.Vim.VMwareDVSPortSetting
                $spec.DefaultPortConfig.Vlan = New-Object VMware.Vim.VmwareDistributedVirtualSwitchVlanIdSpec
                $spec.DefaultPortConfig.Vlan.VlanId = $NewVlanId
                
                Invoke-AnyStackWithRetry -ScriptBlock { $pg.ReconfigureDVPortgroup_Task($spec) }
                
                [PSCustomObject]@{
                    PSTypeName     = 'AnyStack.VlanUpdate'
                    Timestamp      = (Get-Date)
                    Server         = $vi.Name
                    PortGroupName  = $PortGroupName
                    PreviousVlanId = $oldVlan
                    NewVlanId      = $NewVlanId
                    Applied        = $true
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Set-AnyStackVlanTag {
    <#
    .SYNOPSIS
        Updates VLAN ID on an existing portgroup.
    .DESCRIPTION
        Reconfigures a DVPortgroup to use a new VLAN ID.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER PortGroupName
        Name of the portgroup.
    .PARAMETER NewVlanId
        The new VLAN ID.
    .EXAMPLE
        PS> Set-AnyStackVlanTag -PortGroupName 'VLAN-100' -NewVlanId 101
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
        [int]$NewVlanId
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($PortGroupName, "Update VLAN ID to $NewVlanId")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Updating VLAN on $($vi.Name)"
                $pg = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType DistributedVirtualPortgroup -Filter @{Name=$PortGroupName} }
                $oldVlan = if ($pg.Config.DefaultPortConfig.Vlan.VlanId) { $pg.Config.DefaultPortConfig.Vlan.VlanId } else { 0 }
                
                $spec = New-Object VMware.Vim.DVPortgroupConfigSpec
                $spec.ConfigVersion = $pg.Config.ConfigVersion
                $spec.DefaultPortConfig = New-Object VMware.Vim.VMwareDVSPortSetting
                $spec.DefaultPortConfig.Vlan = New-Object VMware.Vim.VmwareDistributedVirtualSwitchVlanIdSpec
                $spec.DefaultPortConfig.Vlan.VlanId = $NewVlanId
                
                Invoke-AnyStackWithRetry -ScriptBlock { $pg.ReconfigureDVPortgroup_Task($spec) }
                
                [PSCustomObject]@{
                    PSTypeName     = 'AnyStack.VlanUpdate'
                    Timestamp      = (Get-Date)
                    Server         = $vi.Name
                    PortGroupName  = $PortGroupName
                    PreviousVlanId = $oldVlan
                    NewVlanId      = $NewVlanId
                    Applied        = $true
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Set-AnyStackVlanTag {
    <#
    .SYNOPSIS
        Updates VLAN ID on an existing portgroup.
    .DESCRIPTION
        Reconfigures a DVPortgroup to use a new VLAN ID.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER PortGroupName
        Name of the portgroup.
    .PARAMETER NewVlanId
        The new VLAN ID.
    .EXAMPLE
        PS> Set-AnyStackVlanTag -PortGroupName 'VLAN-100' -NewVlanId 101
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
        [int]$NewVlanId
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($PortGroupName, "Update VLAN ID to $NewVlanId")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Updating VLAN on $($vi.Name)"
                $pg = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType DistributedVirtualPortgroup -Filter @{Name=$PortGroupName} }
                $oldVlan = if ($pg.Config.DefaultPortConfig.Vlan.VlanId) { $pg.Config.DefaultPortConfig.Vlan.VlanId } else { 0 }
                
                $spec = New-Object VMware.Vim.DVPortgroupConfigSpec
                $spec.ConfigVersion = $pg.Config.ConfigVersion
                $spec.DefaultPortConfig = New-Object VMware.Vim.VMwareDVSPortSetting
                $spec.DefaultPortConfig.Vlan = New-Object VMware.Vim.VmwareDistributedVirtualSwitchVlanIdSpec
                $spec.DefaultPortConfig.Vlan.VlanId = $NewVlanId
                
                Invoke-AnyStackWithRetry -ScriptBlock { $pg.ReconfigureDVPortgroup_Task($spec) }
                
                [PSCustomObject]@{
                    PSTypeName     = 'AnyStack.VlanUpdate'
                    Timestamp      = (Get-Date)
                    Server         = $vi.Name
                    PortGroupName  = $PortGroupName
                    PreviousVlanId = $oldVlan
                    NewVlanId      = $NewVlanId
                    Applied        = $true
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 




.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 




