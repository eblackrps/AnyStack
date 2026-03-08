$cmdlets = @{}

$cmdlets['VCF.AlarmManager\Public\Get-AnyStackActiveAlarm.ps1'] = @'
function Get-AnyStackActiveAlarm {
    <#
    .SYNOPSIS
        Retrieves active alarms from the connected vCenter.
    .DESCRIPTION
        Queries the AlarmManager for all triggered alarms and their status.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Get-AnyStackActiveAlarm
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching active alarms on $($vi.Name)"
            $alarmManager = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Id $vi.ExtensionData.Content.AlarmManager -Server $vi }
            $alarms = Invoke-AnyStackWithRetry -ScriptBlock { $alarmManager.GetAlarmState($null) }
            
            foreach ($a in $alarms) {
                $alarmInfo = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Id $a.Alarm -Property Info -Server $vi }
                [PSCustomObject]@{
                    PSTypeName         = 'AnyStack.ActiveAlarm'
                    Timestamp          = (Get-Date)
                    Server             = $vi.Name
                    Entity             = $a.Entity.Value
                    AlarmName          = $alarmInfo.Info.Name
                    Status             = $a.OverallStatus
                    Time               = $a.Time
                    AcknowledgedByUser = $a.AcknowledgedByUser
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
'@

$cmdlets['VCF.ContentManager\Public\Get-AnyStackLibraryItem.ps1'] = @'
function Get-AnyStackLibraryItem {
    <#
    .SYNOPSIS
        Lists items in a Content Library.
    .DESCRIPTION
        Retrieves all items from the specified Content Library.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER LibraryName
        Name of the library to query.
    .EXAMPLE
        PS> Get-AnyStackLibraryItem -LibraryName 'Templates'
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$true)]
        [string]$LibraryName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching library items from $LibraryName on $($vi.Name)"
            $lib = Invoke-AnyStackWithRetry -ScriptBlock { Get-ContentLibrary -Name $LibraryName -Server $vi }
            $items = Invoke-AnyStackWithRetry -ScriptBlock { Get-ContentLibraryItem -ContentLibrary $lib -Server $vi }
            
            foreach ($i in $items) {
                [PSCustomObject]@{
                    PSTypeName  = 'AnyStack.LibraryItem'
                    Timestamp   = (Get-Date)
                    Server      = $vi.Name
                    LibraryName = $LibraryName
                    ItemName    = $i.Name
                    ItemType    = $i.ItemType
                    SizeGB      = [Math]::Round($i.Size / 1GB, 2)
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
'@

$cmdlets['VCF.IdentityManager\Public\Get-AnyStackGlobalPermission.ps1'] = @'
function Get-AnyStackGlobalPermission {
    <#
    .SYNOPSIS
        Retrieves global permissions in vCenter.
    .DESCRIPTION
        Queries AuthorizationManager for permissions applied at the root level.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Get-AnyStackGlobalPermission
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching global permissions on $($vi.Name)"
            $authMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.AuthorizationManager }
            $perms = Invoke-AnyStackWithRetry -ScriptBlock { $authMgr.RetrieveAllPermissions() }
            
            $globalPerms = $perms | Where-Object { $_.Entity.Type -eq 'Folder' -and $_.Entity.Value -match 'group-d' }
            
            foreach ($p in $globalPerms) {
                [PSCustomObject]@{
                    PSTypeName = 'AnyStack.GlobalPermission'
                    Timestamp  = (Get-Date)
                    Server     = $vi.Name
                    Principal  = $p.Principal
                    RoleId     = $p.RoleId
                    Propagate  = $p.Propagate
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
'@

$cmdlets['VCF.NetworkAudit\Public\Get-AnyStackMacAddressConflict.ps1'] = @'
function Get-AnyStackMacAddressConflict {
    <#
    .SYNOPSIS
        Detects duplicate MAC addresses in the environment.
    .DESCRIPTION
        Scans all VM virtual NICs and identifies overlapping MAC addresses.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Get-AnyStackMacAddressConflict
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Scanning for MAC conflicts on $($vi.Name)"
            $vms = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType VirtualMachine -Property Name,Config.Hardware.Device }
            
            $macs = @{}
            foreach ($vm in $vms) {
                $nics = $vm.Config.Hardware.Device | Where-Object { $_ -is [VMware.Vim.VirtualEthernetCard] }
                foreach ($nic in $nics) {
                    if (-not $macs.ContainsKey($nic.MacAddress)) { $macs[$nic.MacAddress] = @() }
                    $macs[$nic.MacAddress] += $vm.Name
                }
            }
            
            foreach ($mac in $macs.Keys) {
                if ($macs[$mac].Count -gt 1) {
                    [PSCustomObject]@{
                        PSTypeName   = 'AnyStack.MacConflict'
                        Timestamp    = (Get-Date)
                        Server       = $vi.Name
                        MacAddress   = $mac
                        AffectedVMs  = $macs[$mac] -join ','
                        ConflictType = 'Duplicate'
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
'@

$cmdlets['VCF.NetworkManager\Public\Get-AnyStackDistributedPortgroup.ps1'] = @'
function Get-AnyStackDistributedPortgroup {
    <#
    .SYNOPSIS
        Lists Distributed Portgroups and their configuration.
    .DESCRIPTION
        Retrieves all portgroups from distributed switches.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Get-AnyStackDistributedPortgroup
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching portgroups on $($vi.Name)"
            $pgs = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType DistributedVirtualPortgroup -Property Name,Config }
            
            foreach ($pg in $pgs) {
                [PSCustomObject]@{
                    PSTypeName    = 'AnyStack.Portgroup'
                    Timestamp     = (Get-Date)
                    Server        = $vi.Name
                    PortgroupName = $pg.Name
                    VlanId        = $pg.Config.DefaultPortConfig.Vlan.VlanId
                    NumPorts      = $pg.Config.NumPorts
                    Switch        = $pg.Config.DistributedVirtualSwitch.Value
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
'@

$cmdlets['VCF.SecurityAdvanced\Public\Set-AnyStackEsxiLockdownMode.ps1'] = @'
function Set-AnyStackEsxiLockdownMode {
    <#
    .SYNOPSIS
        Configures Lockdown Mode on an ESXi host.
    .DESCRIPTION
        Sets lockdown mode to disabled, normal, or strict.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Name of the host.
    .PARAMETER Mode
        Lockdown mode: lockdownDisabled, lockdownNormal, lockdownStrict.
    .EXAMPLE
        PS> Set-AnyStackEsxiLockdownMode -HostName 'esx01' -Mode lockdownNormal
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
        [ValidateSet('lockdownDisabled','lockdownNormal','lockdownStrict')]
        [string]$Mode
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($HostName, "Set Lockdown Mode to $Mode")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Updating lockdown mode on $($vi.Name)"
                $h = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$HostName} }
                $accessMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.HostAccessManager }
                
                Invoke-AnyStackWithRetry -ScriptBlock { $accessMgr.ChangeLockdownMode($Mode) }
                
                [PSCustomObject]@{
                    PSTypeName = 'AnyStack.LockdownModeUpdate'
                    Timestamp  = (Get-Date)
                    Server     = $vi.Name
                    Host       = $HostName
                    NewMode    = $Mode
                    Applied    = $true
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
'@

$cmdlets['VCF.SecurityBaseline\Public\Get-AnyStackEsxiLockdownMode.ps1'] = @'
function Get-AnyStackEsxiLockdownMode {
    <#
    .SYNOPSIS
        Retrieves the current Lockdown Mode status for ESXi hosts.
    .DESCRIPTION
        Queries host configuration for lockdown mode status.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Filter by host name.
    .EXAMPLE
        PS> Get-AnyStackEsxiLockdownMode
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching lockdown status on $($vi.Name)"
            $filter = if ($HostName) { @{Name="*$HostName*"} } else { $null }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter $filter -Property Name,Config.LockdownMode }
            
            foreach ($h in $hosts) {
                [PSCustomObject]@{
                    PSTypeName   = 'AnyStack.LockdownStatus'
                    Timestamp    = (Get-Date)
                    Server       = $vi.Name
                    Host         = $h.Name
                    LockdownMode = $h.Config.LockdownMode
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
'@

$cmdlets['VCF.TagManager\Public\Get-AnyStackUntaggedVm.ps1'] = @'
function Get-AnyStackUntaggedVm {
    <#
    .SYNOPSIS
        Identifies VMs with no tags assigned.
    .DESCRIPTION
        Compares all VMs against tag assignments and returns those without tags.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Get-AnyStackUntaggedVm
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Finding untagged VMs on $($vi.Name)"
            $vms = Invoke-AnyStackWithRetry -ScriptBlock { Get-VM -Server $vi }
            $taggedIds = Invoke-AnyStackWithRetry -ScriptBlock { Get-TagAssignment -Server $vi | Select-Object -ExpandProperty Entity | Select-Object -ExpandProperty Id }
            
            foreach ($vm in $vms) {
                if ($vm.Id -notin $taggedIds) {
                    [PSCustomObject]@{
                        PSTypeName = 'AnyStack.UntaggedVm'
                        Timestamp  = (Get-Date)
                        Server     = $vi.Name
                        VmName     = $vm.Name
                        Tagged     = $false
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
'@

foreach ($path in $cmdlets.Keys) {
    $content = $cmdlets[$path]
    Set-Content -Path $path -Value $content -Encoding UTF8
}
Write-Host "Generated batch 3 of missing cmdlets."
