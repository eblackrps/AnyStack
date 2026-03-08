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
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
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
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($VmName, "Mark VM as template")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Converting VM to template on $($vi.Name)"
                $vm = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType VirtualMachine -Filter @{Name=$VmName} }
                if ($vm.Runtime.PowerState -ne 'poweredOff') {
                    throw "VM '$VmName' must be powered off to be marked as a template."
                }
                
                Invoke-AnyStackWithRetry -ScriptBlock { $vm.MarkAsTemplate() }
                
                [PSCustomObject]@{
                    PSTypeName      = 'AnyStack.VmTemplate'
                    Timestamp       = (Get-Date)
                    Server          = $vi.Name
                    TemplateName    = $VmName
                    Datastore       = $vm.Config.DatastoreUrl[0].Name
                    SizeGB          = [Math]::Round($vm.Summary.Storage.Committed / 1GB, 2)
                    GuestOs         = $vm.Config.GuestFullName
                    HardwareVersion = $vm.Config.Version
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 

