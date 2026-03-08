function Set-AnyStackEventWebhook {
    <#
    .SYNOPSIS
        Configures an event webhook in vCenter.
    .DESCRIPTION
        Stores webhook configuration via OptionManager.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER WebhookUrl
        The destination URL for events.
    .PARAMETER EventTypes
        Array of event types to monitor.
    .EXAMPLE
        PS> Set-AnyStackEventWebhook -WebhookUrl 'https://webhook.internal'
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
        [string]$WebhookUrl,
        [Parameter(Mandatory=$false)]
        [string[]]$EventTypes = @('VmPoweredOnEvent','VmPoweredOffEvent')
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($vi.Name, "Set Event Webhook to $WebhookUrl")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Updating OptionManager for webhooks on $($vi.Name)"
                $optMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.Setting }
                
                $values = @(
                    [VMware.Vim.OptionValue]@{ Key = 'AnyStack.EventWebhook.Url'; Value = $WebhookUrl },
                    [VMware.Vim.OptionValue]@{ Key = 'AnyStack.EventWebhook.Types'; Value = ($EventTypes -join ',') }
                )
                
                Invoke-AnyStackWithRetry -ScriptBlock { $optMgr.UpdateValues($values) }
                
                [PSCustomObject]@{
                    PSTypeName    = 'AnyStack.EventWebhook'
                    Timestamp     = (Get-Date)
                    Server        = $vi.Name
                    WebhookUrl    = $WebhookUrl
                    EventTypes    = $EventTypes
                    FilterApplied = $true
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 
