function Get-AnyStackUntaggedVm {
    <#
    .SYNOPSIS
        Identifies VMs with no tags assigned.
    .DESCRIPTION
        Compares all VMs against tag assignments and returns those without tags.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Get-AnyStackUntaggedVm
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Finding untagged VMs on $($vi.Name)"
            $vms = Invoke-AnyStackWithRetry -ScriptBlock { Get-VM -Server $vi }
            $taggedIds = Invoke-AnyStackWithRetry -ScriptBlock { Get-TagAssignment -Server $vi | Select-Object -ExpandProperty Entity | Select-Object -ExpandProperty Id }
            
            foreach ($vm in $vms) {
                if ($vm.Id -notin $taggedIds) {
                    [PSCustomObject]@{
                        PSTypeName = 'AnyStack.UntaggedVm'
                        Timestamp  = (Get-Date)
                        Server     = $vi.Name
                        VmName     = $vm.Name
                        Tagged     = $false
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 
