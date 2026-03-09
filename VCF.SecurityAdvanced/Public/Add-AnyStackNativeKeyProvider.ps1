function Add-AnyStackNativeKeyProvider {
    <#
    .SYNOPSIS
        Registers a Native Key Provider.
    .DESCRIPTION
        Uses CryptoManager to register KMS.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ProviderName
        Name of the provider.
    .EXAMPLE
        PS> Add-AnyStackNativeKeyProvider -ProviderName 'AnyStack-NKP'
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$true)]
        [string]$ProviderName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($vi.Name, "Add Key Provider $ProviderName")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Adding KMS on $($vi.Name)"
                $cryptoMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.CryptoManager }
                
                $spec = New-Object VMware.Vim.CryptoManagerKmipServerSpec
                $spec.Info = New-Object VMware.Vim.KmipServerInfo
                $spec.Info.Name = $ProviderName
                
                Invoke-AnyStackWithRetry -ScriptBlock { $cryptoMgr.RegisterKmipServer($spec) }
                
                [PSCustomObject]@{
                    PSTypeName   = 'AnyStack.NativeKeyProvider'
                    Timestamp    = (Get-Date)
                    Server       = $vi.Name
                    ProviderName = $ProviderName
                    Status       = 'Registered'
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
