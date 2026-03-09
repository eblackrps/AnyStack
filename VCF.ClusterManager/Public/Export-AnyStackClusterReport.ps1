function Export-AnyStackClusterReport {
    <#
    .SYNOPSIS
        Exports a cluster summary report.
    .DESCRIPTION
        Builds HTML with cluster summary data.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .PARAMETER OutputPath
        Output HTML path.
    .EXAMPLE
        PS> Export-AnyStackClusterReport
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
        [string]$OutputPath = ".\ClusterReport-$(Get-Date -f yyyyMMdd).html"
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Exporting cluster report on $($vi.Name)"
            $filter = if ($ClusterName) { @{Name="*$ClusterName*"} } else { $null }
            $clusters = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType ClusterComputeResource -Filter $filter -Property Name,Summary,Configuration,Host }
            
            $html = "<html><body><h1>Cluster Report</h1><table border='1'>"
            foreach ($c in $clusters) {
                $html += "<tr><td>$($c.Name)</td><td>Hosts: $($c.Host.Count)</td><td>HA: $($c.Configuration.DasConfig.Enabled)</td></tr>"
            }
            $html += "</table></body></html>"
            Set-Content -Path $OutputPath -Value $html
            
            foreach ($c in $clusters) {
                [PSCustomObject]@{
                    PSTypeName  = 'AnyStack.ClusterReport'
                    Timestamp   = (Get-Date)
                    Server      = $vi.Name
                    ReportPath  = (Resolve-Path $OutputPath).Path
                    ClusterName = $c.Name
                    HostCount   = $c.Host.Count
                    VmCount     = $c.Summary.NumVmotions # Rough indicator
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Export-AnyStackClusterReport {
    <#
    .SYNOPSIS
        Exports a cluster summary report.
    .DESCRIPTION
        Builds HTML with cluster summary data.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .PARAMETER OutputPath
        Output HTML path.
    .EXAMPLE
        PS> Export-AnyStackClusterReport
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
        [string]$OutputPath = ".\ClusterReport-$(Get-Date -f yyyyMMdd).html"
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Exporting cluster report on $($vi.Name)"
            $filter = if ($ClusterName) { @{Name="*$ClusterName*"} } else { $null }
            $clusters = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType ClusterComputeResource -Filter $filter -Property Name,Summary,Configuration,Host }
            
            $html = "<html><body><h1>Cluster Report</h1><table border='1'>"
            foreach ($c in $clusters) {
                $html += "<tr><td>$($c.Name)</td><td>Hosts: $($c.Host.Count)</td><td>HA: $($c.Configuration.DasConfig.Enabled)</td></tr>"
            }
            $html += "</table></body></html>"
            Set-Content -Path $OutputPath -Value $html
            
            foreach ($c in $clusters) {
                [PSCustomObject]@{
                    PSTypeName  = 'AnyStack.ClusterReport'
                    Timestamp   = (Get-Date)
                    Server      = $vi.Name
                    ReportPath  = (Resolve-Path $OutputPath).Path
                    ClusterName = $c.Name
                    HostCount   = $c.Host.Count
                    VmCount     = $c.Summary.NumVmotions # Rough indicator
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Export-AnyStackClusterReport {
    <#
    .SYNOPSIS
        Exports a cluster summary report.
    .DESCRIPTION
        Builds HTML with cluster summary data.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .PARAMETER OutputPath
        Output HTML path.
    .EXAMPLE
        PS> Export-AnyStackClusterReport
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
        [string]$OutputPath = ".\ClusterReport-$(Get-Date -f yyyyMMdd).html"
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Exporting cluster report on $($vi.Name)"
            $filter = if ($ClusterName) { @{Name="*$ClusterName*"} } else { $null }
            $clusters = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType ClusterComputeResource -Filter $filter -Property Name,Summary,Configuration,Host }
            
            $html = "<html><body><h1>Cluster Report</h1><table border='1'>"
            foreach ($c in $clusters) {
                $html += "<tr><td>$($c.Name)</td><td>Hosts: $($c.Host.Count)</td><td>HA: $($c.Configuration.DasConfig.Enabled)</td></tr>"
            }
            $html += "</table></body></html>"
            Set-Content -Path $OutputPath -Value $html
            
            foreach ($c in $clusters) {
                [PSCustomObject]@{
                    PSTypeName  = 'AnyStack.ClusterReport'
                    Timestamp   = (Get-Date)
                    Server      = $vi.Name
                    ReportPath  = (Resolve-Path $OutputPath).Path
                    ClusterName = $c.Name
                    HostCount   = $c.Host.Count
                    VmCount     = $c.Summary.NumVmotions # Rough indicator
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Export-AnyStackClusterReport {
    <#
    .SYNOPSIS
        Exports a cluster summary report.
    .DESCRIPTION
        Builds HTML with cluster summary data.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .PARAMETER OutputPath
        Output HTML path.
    .EXAMPLE
        PS> Export-AnyStackClusterReport
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
        [string]$OutputPath = ".\ClusterReport-$(Get-Date -f yyyyMMdd).html"
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Exporting cluster report on $($vi.Name)"
            $filter = if ($ClusterName) { @{Name="*$ClusterName*"} } else { $null }
            $clusters = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType ClusterComputeResource -Filter $filter -Property Name,Summary,Configuration,Host }
            
            $html = "<html><body><h1>Cluster Report</h1><table border='1'>"
            foreach ($c in $clusters) {
                $html += "<tr><td>$($c.Name)</td><td>Hosts: $($c.Host.Count)</td><td>HA: $($c.Configuration.DasConfig.Enabled)</td></tr>"
            }
            $html += "</table></body></html>"
            Set-Content -Path $OutputPath -Value $html
            
            foreach ($c in $clusters) {
                [PSCustomObject]@{
                    PSTypeName  = 'AnyStack.ClusterReport'
                    Timestamp   = (Get-Date)
                    Server      = $vi.Name
                    ReportPath  = (Resolve-Path $OutputPath).Path
                    ClusterName = $c.Name
                    HostCount   = $c.Host.Count
                    VmCount     = $c.Summary.NumVmotions # Rough indicator
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

 




