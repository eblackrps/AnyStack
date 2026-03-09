function New-AnyStackHostProfile {
    <#
    .SYNOPSIS
        Creates a new Host Profile.
    .DESCRIPTION
        Uses a reference host to create a new profile.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ProfileName
        Name of the new host profile.
    .PARAMETER ReferenceHostName
        Name of the reference ESXi host.
    .PARAMETER Description
        Description of the profile.
    .EXAMPLE
        PS> New-AnyStackHostProfile -ProfileName 'Prod-Baseline' -ReferenceHostName 'esx01'
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
        [string]$ProfileName,
        [Parameter(Mandatory=$true)]
        [string]$ReferenceHostName,
        [Parameter(Mandatory=$false)]
        [string]$Description = ''
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($ProfileName, "Create Host Profile from $ReferenceHostName")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Creating host profile on $($vi.Name)"
                $hpMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.HostProfileManager }
                $refHost = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$ReferenceHostName} }
                
                $spec = New-Object VMware.Vim.HostProfileCompleteConfigSpec
                $spec.Annotation = $Description
                $spec.Name = $ProfileName
                
                Invoke-AnyStackWithRetry -ScriptBlock { $hpMgr.CreateProfile($spec) }
                
                [PSCustomObject]@{
                    PSTypeName    = 'AnyStack.HostProfile'
                    Timestamp     = (Get-Date)
                    Server        = $vi.Name
                    ProfileName   = $ProfileName
                    ReferenceHost = $ReferenceHostName
                    Description   = $Description
                    Created       = (Get-Date)
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



