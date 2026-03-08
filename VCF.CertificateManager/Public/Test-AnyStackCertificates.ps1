function Test-AnyStackCertificates {
    <#
    .SYNOPSIS
        Tests host certificate validity.
    .DESCRIPTION
        Checks expiration dates of ESXi host certificates.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .PARAMETER WarnDays
        Warning threshold in days (default 60).
    .EXAMPLE
        PS> Test-AnyStackCertificates
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
        [string]$ClusterName,
        [Parameter(Mandatory=$false)]
        [int]$WarnDays = 60
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Checking certificates on $($vi.Name)"
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Property Name,Config.Certificate }
            
            foreach ($h in $hosts) {
                if ($h.Config.Certificate) {
                    $certBytes = $h.Config.Certificate[0]
                    $cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($certBytes)
                    $days = [int]($cert.NotAfter - (Get-Date)).TotalDays
                    
                    [PSCustomObject]@{
                        PSTypeName    = 'AnyStack.CertificateStatus'
                        Timestamp     = (Get-Date)
                        Server        = $vi.Name
                        Host          = $h.Name
                        Subject       = $cert.Subject
                        Issuer        = $cert.Issuer
                        ExpiresOn     = $cert.NotAfter
                        DaysRemaining = $days
                        Status        = if ($days -lt $WarnDays) { 'WARNING' } else { 'OK' }
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
