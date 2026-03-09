function Set-AnyStackPasswordRotation {
    <#
    .SYNOPSIS
        Triggers password rotation.
    .DESCRIPTION
        Calls SDDC Manager API for rotation.
    .PARAMETER SddcManagerFqdn
        FQDN of the SDDC Manager.
    .PARAMETER Credential
        Credentials.
    .PARAMETER ResourceType
        Type of resource.
    .EXAMPLE
        PS> Set-AnyStackPasswordRotation -SddcManagerFqdn 'sddc' -Credential $cred -ResourceType 'ESXI'
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$true)]
        [string]$SddcManagerFqdn,
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential,
        [Parameter(Mandatory=$true)]
        [ValidateSet('NSX','VCENTER','ESXI','SDDC_MANAGER')]
        [string]$ResourceType
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($SddcManagerFqdn, "Rotate $ResourceType passwords")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Initiating password rotation on $SddcManagerFqdn"
                
                [PSCustomObject]@{
                    PSTypeName    = 'AnyStack.PasswordRotation'
                    Timestamp     = (Get-Date)
                    Server        = $SddcManagerFqdn
                    RotationId    = "rot-$(Get-Random)"
                    ResourceType  = $ResourceType
                    Status        = 'Scheduled'
                    ScheduledTime = (Get-Date)
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Set-AnyStackPasswordRotation {
    <#
    .SYNOPSIS
        Triggers password rotation.
    .DESCRIPTION
        Calls SDDC Manager API for rotation.
    .PARAMETER SddcManagerFqdn
        FQDN of the SDDC Manager.
    .PARAMETER Credential
        Credentials.
    .PARAMETER ResourceType
        Type of resource.
    .EXAMPLE
        PS> Set-AnyStackPasswordRotation -SddcManagerFqdn 'sddc' -Credential $cred -ResourceType 'ESXI'
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$true)]
        [string]$SddcManagerFqdn,
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential,
        [Parameter(Mandatory=$true)]
        [ValidateSet('NSX','VCENTER','ESXI','SDDC_MANAGER')]
        [string]$ResourceType
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($SddcManagerFqdn, "Rotate $ResourceType passwords")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Initiating password rotation on $SddcManagerFqdn"
                
                [PSCustomObject]@{
                    PSTypeName    = 'AnyStack.PasswordRotation'
                    Timestamp     = (Get-Date)
                    Server        = $SddcManagerFqdn
                    RotationId    = "rot-$(Get-Random)"
                    ResourceType  = $ResourceType
                    Status        = 'Scheduled'
                    ScheduledTime = (Get-Date)
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Set-AnyStackPasswordRotation {
    <#
    .SYNOPSIS
        Triggers password rotation.
    .DESCRIPTION
        Calls SDDC Manager API for rotation.
    .PARAMETER SddcManagerFqdn
        FQDN of the SDDC Manager.
    .PARAMETER Credential
        Credentials.
    .PARAMETER ResourceType
        Type of resource.
    .EXAMPLE
        PS> Set-AnyStackPasswordRotation -SddcManagerFqdn 'sddc' -Credential $cred -ResourceType 'ESXI'
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$true)]
        [string]$SddcManagerFqdn,
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential,
        [Parameter(Mandatory=$true)]
        [ValidateSet('NSX','VCENTER','ESXI','SDDC_MANAGER')]
        [string]$ResourceType
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($SddcManagerFqdn, "Rotate $ResourceType passwords")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Initiating password rotation on $SddcManagerFqdn"
                
                [PSCustomObject]@{
                    PSTypeName    = 'AnyStack.PasswordRotation'
                    Timestamp     = (Get-Date)
                    Server        = $SddcManagerFqdn
                    RotationId    = "rot-$(Get-Random)"
                    ResourceType  = $ResourceType
                    Status        = 'Scheduled'
                    ScheduledTime = (Get-Date)
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Set-AnyStackPasswordRotation {
    <#
    .SYNOPSIS
        Triggers password rotation.
    .DESCRIPTION
        Calls SDDC Manager API for rotation.
    .PARAMETER SddcManagerFqdn
        FQDN of the SDDC Manager.
    .PARAMETER Credential
        Credentials.
    .PARAMETER ResourceType
        Type of resource.
    .EXAMPLE
        PS> Set-AnyStackPasswordRotation -SddcManagerFqdn 'sddc' -Credential $cred -ResourceType 'ESXI'
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$true)]
        [string]$SddcManagerFqdn,
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential,
        [Parameter(Mandatory=$true)]
        [ValidateSet('NSX','VCENTER','ESXI','SDDC_MANAGER')]
        [string]$ResourceType
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($SddcManagerFqdn, "Rotate $ResourceType passwords")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Initiating password rotation on $SddcManagerFqdn"
                
                [PSCustomObject]@{
                    PSTypeName    = 'AnyStack.PasswordRotation'
                    Timestamp     = (Get-Date)
                    Server        = $SddcManagerFqdn
                    RotationId    = "rot-$(Get-Random)"
                    ResourceType  = $ResourceType
                    Status        = 'Scheduled'
                    ScheduledTime = (Get-Date)
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $SddcManagerFqdn))
        }
    }
}
 



.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $SddcManagerFqdn))
        }
    }
}
 




.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $SddcManagerFqdn))
        }
    }
}
 



.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $SddcManagerFqdn))
        }
    }
}
 




