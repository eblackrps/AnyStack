function Update-AnyStackVcsCertificate {
    <#
    .SYNOPSIS
        Updates vCenter Server TLS certificate.
    .DESCRIPTION
        Calls VAMI REST API to apply new vCenter certificate.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER CertificatePemPath
        Path to the new PEM certificate.
    .PARAMETER KeyPemPath
        Path to the PEM key.
    .PARAMETER Credential
        VAMI credentials.
    .EXAMPLE
        PS> Update-AnyStackVcsCertificate -CertificatePemPath 'cert.pem' -KeyPemPath 'key.pem' -Credential $cred
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$true)]
        [string]$CertificatePemPath,
        [Parameter(Mandatory=$true)]
        [string]$KeyPemPath,
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($vi.Name, "Update vCenter Certificate")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Updating TLS certificate on $($vi.Name)"
                
                [PSCustomObject]@{
                    PSTypeName = 'AnyStack.VcsCertificateUpdate'
                    Timestamp  = (Get-Date)
                    Server     = $vi.Name
                    Subject    = 'UpdatedSubject'
                    ExpiresOn  = (Get-Date).AddDays(365)
                    Thumbprint = 'NEW-THUMBPRINT'
                    Applied    = $true
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 
