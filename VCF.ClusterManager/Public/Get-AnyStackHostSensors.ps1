function Get-AnyStackHostSensors {
    <#
    .SYNOPSIS
        Retrieves hardware sensors for a host.
    .DESCRIPTION
        Queries SystemHealthInfo numeric sensors.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Filter by host name.
    .EXAMPLE
        PS> Get-AnyStackHostSensors
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching host sensors on $($vi.Name)"
            $filter = if ($HostName) { @{Name="*$HostName*"} } else { $null }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter $filter -Property Name,Runtime.HealthSystemRuntime }
            
            foreach ($h in $hosts) {
                $sensors = $h.Runtime.HealthSystemRuntime.SystemHealthInfo.NumericSensorInfo
                foreach ($s in $sensors) {
                    [PSCustomObject]@{
                        PSTypeName  = 'AnyStack.HostSensor'
                        Timestamp   = (Get-Date)
                        Server      = $vi.Name
                        Host        = $h.Name
                        SensorName  = $s.Name
                        Value       = $s.CurrentReading
                        Units       = $s.BaseUnits
                        SensorType  = $s.SensorType
                        Health      = if ($s.HealthState.Key -eq 'green') { 'Healthy' } else { $s.HealthState.Key }
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 


