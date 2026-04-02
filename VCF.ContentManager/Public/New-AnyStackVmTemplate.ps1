function New-AnyStackVmTemplate {
    <#
    .SYNOPSIS
        Marks a VM as a template.
    .DESCRIPTION
        Converts a powered-off VM into a template.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER VmName
        Name of the virtual machine.
    .EXAMPLE
        PS> New-AnyStackVmTemplate -VmName 'Win2022-Base'
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
        [string]$VmName
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            if ($PSCmdlet.ShouldProcess($VmName, "Mark VM as template")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Converting VM to template on $($vi.Name)"
                $vm = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType VirtualMachine -Filter @{Name=$VmName} }
                if ($vm -and $vm.Runtime.PowerState -ne 'poweredOff') {
                    throw "VM '$VmName' must be powered off to be marked as a template."
                }
                
                Invoke-AnyStackWithRetry -ScriptBlock { $vm.MarkAsTemplate() }
                
                [PSCustomObject]@{
                    PSTypeName      = 'AnyStack.VmTemplate'
                    Timestamp       = (Get-Date)
                    Server          = $vi.Name
                    TemplateName    = $VmName
                    Datastore       = if ($vm -and $vm.Config -and $vm.Config.DatastoreUrl) { $vm.Config.DatastoreUrl[0].Name } else { $null }
                    SizeGB          = if ($vm -and $vm.Summary -and $vm.Summary.Storage) { [Math]::Round($vm.Summary.Storage.Committed / 1GB, 2) } else { 0 }
                    GuestOs         = if ($vm -and $vm.Config) { $vm.Config.GuestFullName } else { $null }
                    HardwareVersion = if ($vm -and $vm.Config) { $vm.Config.Version } else { $null }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
