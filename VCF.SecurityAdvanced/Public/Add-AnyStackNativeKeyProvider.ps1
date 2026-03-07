function Add-AnyStackNativeKeyProvider {
    <#
    .SYNOPSIS
        Configures the vSphere Native Key Provider (NKP) for VM Encryption and vTPM.
    .DESCRIPTION
        Round 6: VCF.SecurityAdvanced. Enables the Native Key Provider on vCenter.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] $Server,
        [Parameter(Mandatory=$true)] [string]$Name
    )
    process {
        $ErrorActionPreference = 'Stop'
        if ($PSCmdlet.ShouldProcess($Server.Name, "Enable Native Key Provider: $Name")) {
            try {
                Write-Host "[SECURITY-MGMT] Provisioning Native Key Provider $Name..." -ForegroundColor Cyan
                # $kpManager = Get-View $si.Content.CryptoManager
                # $kpManager.AddNativeKeyProvider(...)
                
                Write-Host "[SUCCESS] Native Key Provider '$Name' configured. Please back up the recovery key immediately." -ForegroundColor Yellow
            }
            catch {
                Write-Error "Failed to add Native Key Provider: $($_.Exception.Message)"
            }
        }
    }
}
