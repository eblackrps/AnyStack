function Remove-AnyStackOldTemplates {
    <#
    .SYNOPSIS
        Removes old VM templates.
    .DESCRIPTION
        Finds and deletes templates not modified in AgeDays.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER AgeDays
        Age threshold in days (default 180).
    .EXAMPLE
        PS> Remove-AnyStackOldTemplates
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
        [Parameter(Mandatory=$false)]
        [int]$AgeDays = 180
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Finding old templates on $($vi.Name)"
            $templates = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType VirtualMachine -Property Name,Config.Modified,Summary.Storage.Committed -Filter @{'Config.Template'='True'} }
            
            $threshold = (Get-Date).AddDays(-$AgeDays)
            foreach ($t in $templates) {
                if ($t.Config.Modified -lt $threshold) {
                    if ($PSCmdlet.ShouldProcess($t.Name, "Delete Old Template")) {
                        Invoke-AnyStackWithRetry -ScriptBlock { $t.Destroy_Task() }
                        
                        [PSCustomObject]@{
                            PSTypeName   = 'AnyStack.RemovedTemplate'
                            Timestamp    = (Get-Date)
                            Server       = $vi.Name
                            TemplateName = $t.Name
                            LastModified = $t.Config.Modified
                            SizeGB       = [Math]::Round($t.Summary.Storage.Committed / 1GB, 2)
                            Removed      = $true
                        }
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 
