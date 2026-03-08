function Get-AnyStackVmUptime {
    <#
    .SYNOPSIS
        Calculates VM uptime.
    .DESCRIPTION
        Uses Runtime.BootTime to calculate uptime.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER VmName
        Filter by VM name.
    .PARAMETER ClusterName
        Filter by cluster name.
    .EXAMPLE
        PS> Get-AnyStackVmUptime
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
        [string]$VmName,
        [Parameter(Mandatory=$false)]
        [string]$ClusterName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Calculating VM uptimes on $($vi.Name)"
            $filter = if ($VmName) { @{Name="*$VmName*"} } else { $null }
            $vms = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType VirtualMachine -Filter $filter -Property Name,Runtime.BootTime,Runtime.PowerState }
            
            foreach ($vm in $vms) {
                if ($vm.Runtime.PowerState -eq 'poweredOn') {
                    $uptime = (Get-Date) - $vm.Runtime.BootTime
                    [PSCustomObject]@{
                        PSTypeName  = 'AnyStack.VmUptime'
                        Timestamp   = (Get-Date)
                        Server      = $vi.Name
                        VmName      = $vm.Name
                        BootTime    = $vm.Runtime.BootTime
                        UptimeDays  = [Math]::Round($uptime.TotalDays, 1)
                        UptimeHours = [Math]::Round($uptime.TotalHours, 1)
                        PowerState  = $vm.Runtime.PowerState
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

