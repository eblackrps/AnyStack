function Test-AnyStackCertificates {
    <#
    .SYNOPSIS
        Audits ESXi Host certificate expiration dates.
    .DESCRIPTION
        Round 7: VCF.CertificateManager. Gathers SSL certificate data across all hosts 
        to warn administrators of impending expirations before an outage occurs.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] $Server,
        [Parameter(Mandatory=$true)] [string]$ClusterName,
        [Parameter(Mandatory=$false)] [int]$WarningDays = 60
    )
    process {
        $ErrorActionPreference = 'Stop'
        # Note: Using standard PowerCLI Get-VMHostCertificate due to complex Get-View parsing for certs.
        $hosts = Get-VMHost -Server $Server -Location $ClusterName
        
        foreach ($h in $hosts) {
            $certs = Get-VMHostCertificate -VMHost $h -ErrorAction SilentlyContinue
            foreach ($cert in $certs) {
                $daysLeft = ($cert.NotAfter - (Get-Date)).Days
                [PSCustomObject]@{
                    Host       = $h.Name
                    Thumbprint = $cert.Thumbprint
                    Issuer     = $cert.Issuer
                    Expires    = $cert.NotAfter
                    DaysLeft   = $daysLeft
                    Alert      = if ($daysLeft -le $WarningDays) { "WARNING: Expiring Soon" } else { "OK" }
                }
            }
        }
    }
}
