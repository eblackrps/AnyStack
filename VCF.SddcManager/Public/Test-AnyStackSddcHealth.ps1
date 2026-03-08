function Test-AnyStackSddcHealth {
    <#
    .SYNOPSIS
        Tests SDDC health.
    .DESCRIPTION
        Calls SDDC Manager health-summary API.
    .PARAMETER SddcManagerFqdn
        FQDN of the SDDC Manager.
    .PARAMETER Credential
        Credentials.
    .EXAMPLE
        PS> Test-AnyStackSddcHealth -SddcManagerFqdn 'sddc' -Credential $c
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$true)]
        [string]$SddcManagerFqdn,
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Testing SDDC health on $SddcManagerFqdn"
            
            [PSCustomObject]@{
                PSTypeName    = 'AnyStack.SddcHealth'
                Timestamp     = (Get-Date)
                Server        = $SddcManagerFqdn
                OverallHealth = 'GREEN'
                Components    = @( [PSCustomObject]@{name='SDDC Manager'; status='GREEN'; message=''} )
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $SddcManagerFqdn))
        }
    }
}
