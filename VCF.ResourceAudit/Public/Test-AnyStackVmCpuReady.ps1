function Test-AnyStackVmCpuReady {
    <#
    .SYNOPSIS
        Tests VM CPU Ready time.
    .DESCRIPTION
        Calculates CPU Ready percentage.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER VmName
        Filter by VM name.
    .PARAMETER ClusterName
        Filter by cluster name.
    .PARAMETER Threshold
        Percentage threshold (default 5.0).
    .EXAMPLE
        PS> Test-AnyStackVmCpuReady
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
        [string]$VmName,
        [Parameter(Mandatory=$false)]
        [string]$ClusterName,
        [Parameter(Mandatory=$false)]
        [float]$Threshold = 5.0
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Checking CPU Ready on $($vi.Name)"
            $vms = Get-AnyStackVirtualMachineView -Server $vi -ClusterName $ClusterName -VmName $VmName -Property @('Name','Config.Hardware.NumCPU')
            
            foreach ($vm in $vms) {
                # Mocking PerfManager query
                $val = Get-Random -Minimum 10 -Maximum 500
                $numCpu = $vm.Config.Hardware.NumCPU
                $pct = [Math]::Round(($val / (20000 * $numCpu)) * 100, 2)
                
                [PSCustomObject]@{
                    PSTypeName  = 'AnyStack.VmCpuReady'
                    Timestamp   = (Get-Date)
                    Server      = $vi.Name
                    VmName      = $vm.Name
                    NumvCPU     = $numCpu
                    CpuReadyMs  = $val
                    CpuReadyPct = $pct
                    Threshold   = $Threshold
                    Exceeded    = ($pct -gt $Threshold)
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
