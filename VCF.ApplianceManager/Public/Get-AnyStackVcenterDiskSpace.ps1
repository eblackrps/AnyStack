function Get-AnyStackVcenterDiskSpace {
    <#
    .SYNOPSIS
        Retrieves disk space usage for vCenter partitions via VAMI API.
    .DESCRIPTION
        Calls the vCenter Appliance Management Interface (VAMI) REST API to fetch partition space.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER Credential
        PSCredential for VAMI authentication.
    .EXAMPLE
        PS> Get-AnyStackVcenterDiskSpace -Server 'vcenter.corp.local' -Credential $cred
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
        $Server,
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching vCenter Disk Space via VAMI on $($vi.Name)"
            $user = $Credential.UserName
            $pass = $Credential.GetNetworkCredential().Password
            $auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${user}:${pass}"))
            
            $url = "https://$($vi.Name):5480/api/appliance/system/storage"
            $response = Invoke-AnyStackWithRetry -ScriptBlock {
                Invoke-RestMethod -Method Get -Uri $url -Headers @{Authorization="Basic $auth"} -SkipCertificateCheck
            }
            
            foreach ($kv in $response.PSObject.Properties) {
                $partition = $kv.Name
                $data = $kv.Value
                [PSCustomObject]@{
                    PSTypeName = 'AnyStack.VcenterDiskSpace'
                    Timestamp  = (Get-Date)
                    Server     = $vi.Name
                    Partition  = $partition
                    UsedGB     = [Math]::Round($data.used / 1024, 2)
                    TotalGB    = [Math]::Round($data.total / 1024, 2)
                    FreeGB     = [Math]::Round($data.free / 1024, 2)
                    UsedPct    = if ($data.total -gt 0) { [Math]::Round(($data.used / $data.total) * 100, 1) } else { 0 }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 
