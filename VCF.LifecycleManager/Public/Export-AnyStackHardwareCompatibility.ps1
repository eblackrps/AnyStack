function Export-AnyStackHardwareCompatibility {
    <#
    .SYNOPSIS
        Exports an HCL report.
    .DESCRIPTION
        Gathers hardware data for VMware HCL checking.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .PARAMETER OutputPath
        Output HTML path.
    .EXAMPLE
        PS> Export-AnyStackHardwareCompatibility
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
        [string]$ClusterName,
        [Parameter(Mandatory=$false)]
        [string]$OutputPath = ".\HCL-$(Get-Date -f yyyyMMdd).html"
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Exporting HCL report on $($vi.Name)"
            $filter = if ($ClusterName) { @{Name="*$ClusterName*"} } else { $null }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter $filter -Property Name,Hardware.SystemInfo,Hardware.BiosInfo,Config.Product }
            
            $html = "<html><body><h1>HCL Report (Manual Verification Required)</h1><table border='1'>"
            $html += "<tr><th>Host</th><th>Vendor</th><th>Model</th><th>BIOS</th><th>ESXi Version</th></tr>"
            
            foreach ($h in $hosts) {
                $html += "<tr><td>$($h.Name)</td><td>$($h.Hardware.SystemInfo.Vendor)</td><td>$($h.Hardware.SystemInfo.Model)</td><td>$($h.Hardware.BiosInfo.BiosVersion)</td><td>$($h.Config.Product.Version)</td></tr>"
            }
            $html += "</table></body></html>"
            Set-Content -Path $OutputPath -Value $html
            
            [PSCustomObject]@{
                PSTypeName   = 'AnyStack.HardwareCompatibility'
                Timestamp    = (Get-Date)
                Server       = $vi.Name
                ReportPath   = (Resolve-Path $OutputPath).Path
                HostsChecked = if ($hosts) { $hosts.Count } else { 0 }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
