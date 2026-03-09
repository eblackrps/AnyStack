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
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



