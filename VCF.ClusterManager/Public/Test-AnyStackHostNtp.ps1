function Test-AnyStackHostNtp {
    <#
    .SYNOPSIS
        Tests host NTP configuration.
    .DESCRIPTION
        Checks if NTP is configured and matches expected servers.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .PARAMETER ExpectedServers
        Array of expected NTP servers.
    .EXAMPLE
        PS> Test-AnyStackHostNtp -ExpectedServers 'time.apple.com'
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
        [string[]]$ExpectedServers = @()
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Testing host NTP on $($vi.Name)"
            $hosts = Get-AnyStackHostView -Server $vi -ClusterName $ClusterName -Property @('Name','Config.DateTimeInfo')
            
            foreach ($h in $hosts) {
                $ntp = $h.Config.DateTimeInfo.NtpConfig
                $servers = $ntp.Server
                $compliant = if ($ExpectedServers.Count -gt 0) {
                    $diff = Compare-Object $ExpectedServers $servers
                    $null -eq $diff
                } else {
                    $servers.Count -gt 0
                }
                
                [PSCustomObject]@{
                    PSTypeName        = 'AnyStack.HostNtp'
                    Timestamp         = (Get-Date)
                    Server            = $vi.Name
                    Host              = $h.Name
                    ConfiguredServers = $servers -join ','
                    ExpectedServers   = $ExpectedServers -join ','
                    Compliant         = $compliant
                    NtpEnabled        = ($null -ne $ntp)
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
