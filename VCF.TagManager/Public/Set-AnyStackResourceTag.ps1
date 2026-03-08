function Set-AnyStackResourceTag {
    <#
    .SYNOPSIS
        Applies a tag to an object.
    .DESCRIPTION
        Calls New-TagAssignment.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ObjectName
        Name of the object.
    .PARAMETER ObjectType
        VirtualMachine, Datastore, Cluster, or Host.
    .PARAMETER TagName
        Tag name.
    .PARAMETER CategoryName
        Category name.
    .EXAMPLE
        PS> Set-AnyStackResourceTag -ObjectName 'VM1' -ObjectType VirtualMachine -TagName 'Prod' -CategoryName 'Env'
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
        [string]$ObjectName,
        [Parameter(Mandatory=$true)]
        [ValidateSet('VirtualMachine','Datastore','Cluster','Host')]
        [string]$ObjectType,
        [Parameter(Mandatory=$true)]
        [string]$TagName,
        [Parameter(Mandatory=$true)]
        [string]$CategoryName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($ObjectName, "Set Tag $TagName ($CategoryName)")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Applying tag on $($vi.Name)"
                $tag = Invoke-AnyStackWithRetry -ScriptBlock { Get-Tag -Name $TagName -Category $CategoryName -Server $vi }
                $entity = Invoke-AnyStackWithRetry -ScriptBlock {
                    switch ($ObjectType) {
                        'VirtualMachine' { Get-VM -Name $ObjectName -Server $vi }
                        'Datastore'      { Get-Datastore -Name $ObjectName -Server $vi }
                        'Cluster'        { Get-Cluster -Name $ObjectName -Server $vi }
                        'Host'           { Get-VMHost -Name $ObjectName -Server $vi }
                    }
                }
                
                Invoke-AnyStackWithRetry -ScriptBlock { New-TagAssignment -Tag $tag -Entity $entity -Server $vi }
                
                [PSCustomObject]@{
                    PSTypeName = 'AnyStack.ResourceTag'
                    Timestamp  = (Get-Date)
                    Server     = $vi.Name
                    ObjectName = $ObjectName
                    ObjectType = $ObjectType
                    TagName    = $TagName
                    Category   = $CategoryName
                    Applied    = $true
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

