function Test-AnyStackAdIntegration {
    <#
    .SYNOPSIS
        Tests AD integration on host.
    .DESCRIPTION
        Checks AuthManager info for AD membership.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster.
    .PARAMETER HostName
        Filter by host name.
    .EXAMPLE
        PS> Test-AnyStackAdIntegration
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
        [string]$HostName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Testing AD integration on $($vi.Name)"
            $filter = if ($HostName) { @{Name="*$HostName*"} } else { $null }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter $filter -Property Name,Config.AuthenticationManagerInfo }
            
            foreach ($h in $hosts) {
                $adInfo = $h.Config.AuthenticationManagerInfo.AuthConfig | Where-Object { $_ -is [VMware.Vim.HostActiveDirectoryInfo] } | Select-Object -First 1
                
                [PSCustomObject]@{
                    PSTypeName      = 'AnyStack.AdIntegration'
                    Timestamp       = (Get-Date)
                    Server          = $vi.Name
                    Host            = $h.Name
                    AdDomain        = if ($adInfo) { $adInfo.JoinedDomain } else { $null }
                    JoinState       = if ($adInfo) { $adInfo.MembershipStatus } else { 'NotJoined' }
                    MembershipValid = if ($adInfo) { $adInfo.MembershipStatus -eq 'ok' } else { $false }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



