function Update-AnyStackEsxCertificate {
    <#
    .SYNOPSIS
        Renews the SSL certificate for an ESXi Host via vCenter VMCA.
    .DESCRIPTION
        Round 4: VCF.CertificateManager. Uses the HostCertificateManager on the host 
        to request a new certificate from the VMCA. One host at a time with confirmation.
    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory=$true)] $Server,
        [Parameter(Mandatory=$true)] [string]$HostName
    )
    process {
        $ErrorActionPreference = 'Stop'
        if ($PSCmdlet.ShouldProcess($HostName, "Renew ESXi SSL Certificate via VMCA")) {
            try {
                $hostView = Get-View -Server $Server -ViewType HostSystem -Filter @{"Name"="^$HostName$"} -Property Name,ConfigManager
                $certManager = Get-View $hostView.ConfigManager.CertificateManager -Server $Server
                
                Write-Host "[CERT-MGMT] Requesting certificate renewal for $HostName..." -ForegroundColor Cyan
                # VMware API call: CertMgrRefreshCertificates()
                $certManager.CertMgrRefreshCertificates()
                
                Write-Host "[SUCCESS] Certificate refreshed for $HostName." -ForegroundColor Green
            }
            catch {
                Write-Error "Failed to refresh certificate for $HostName : $($_.Exception.Message)"
            }
        }
    }
}
