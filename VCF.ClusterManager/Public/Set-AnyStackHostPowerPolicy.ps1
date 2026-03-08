function Set-AnyStackHostPowerPolicy {
    <#
    .SYNOPSIS
        Configures host power policy.
    .DESCRIPTION
        Sets power policy to HighPerformance, Balanced, or LowPower.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Name of the ESXi host.
    .PARAMETER Policy
        Power policy to apply.
    .EXAMPLE
        PS> Set-AnyStackHostPowerPolicy -HostName 'esx01' -Policy HighPerformance
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
        [ValidateSet('HighPerformance','Balanced','LowPower')]
        [string]$Policy
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($HostName, "Set Power Policy to $Policy")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Setting power policy on $($vi.Name)"
                $policyMap = @{HighPerformance=1; Balanced=2; LowPower=3}
                $h = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$HostName} }
                $powerSystem = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.PowerSystem }
                
                Invoke-AnyStackWithRetry -ScriptBlock { $powerSystem.ConfigurePowerPolicy($policyMap[$Policy]) }
                
                [PSCustomObject]@{
                    PSTypeName     = 'AnyStack.HostPowerPolicy'
                    Timestamp      = (Get-Date)
                    Server         = $vi.Name
                    Host           = $HostName
                    PreviousPolicy = 'Unknown'
                    NewPolicy      = $Policy
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
