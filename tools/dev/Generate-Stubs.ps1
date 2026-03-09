$specs = Get-Content -Path "C:\Gem\specs.txt" -Raw
$modules = $specs -split "(?m)^(?=VCF\.|AnyStack\.)"

foreach ($mod in $modules) {
    if ([string]::IsNullOrWhiteSpace($mod)) { continue }
    $lines = $mod -split "`r`n"
    $moduleName = $lines[0].Trim()

    $cmdlets = $mod -split "(?m)^- "
    for ($i = 1; $i -lt $cmdlets.Count; $i++) {
        $cmdLines = $cmdlets[$i] -split "`r`n"
        $cmdName = $cmdLines[0].Trim() -replace '\r|\n',''

        $desc = ""
        $returns = ""
        foreach ($line in $cmdLines) {
            if ($line -match "^  Return: (.*)") {
                $returns = $matches[1]
            } elseif ($line.Trim() -ne "" -and $line.Trim() -ne $cmdName) {
                $desc += $line.Trim() + " "
            }
        }

        $verb = $cmdName.Split('-')[0]
        $isStateModifying = ($verb -notin @('Get','Test','Export'))

        $supportsShouldProcess = ""
        if ($isStateModifying) {
            $supportsShouldProcess = "SupportsShouldProcess = `$true"
        }

        $returnProps = $returns -split "," | ForEach-Object { $_.Trim() -replace '\(.*','' -replace ' ','_' }
        $propsString = ""
        foreach ($p in $returnProps) {
            if ($p) {
                # Handle cases like "Groups (array of GroupName/Health/Tests)" -> "Groups"
                $pClean = $p -replace ' .*',''
                $propsString += "`n                    $pClean = `$null"
            }
        }

        # Build the function content
        $funcContent = @"
function $cmdName {
    <#
    .SYNOPSIS
        $desc
    .EXAMPLE
        PS> $cmdName -Server 'vcenter.corp.local'
        Executes the $cmdName command.
    #>
    [CmdletBinding($supportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=`$false)]
        [string]`$Server
    )
    begin {
        `$vi = Get-AnyStackConnection -Server `$Server
    }
    process {
        try {
            Write-Verbose `"Executing $cmdName`"
"@

        if ($isStateModifying) {
            $funcContent += @"

            if (`$PSCmdlet.ShouldProcess(`$Server, '$cmdName')) {
                `$result = Invoke-AnyStackWithRetry -ScriptBlock {
                    # Stub for $cmdName
                    # $desc
                }
                [PSCustomObject]@{ $propsString
                }
            }
"@
        } else {
            $funcContent += @"

            `$result = Invoke-AnyStackWithRetry -ScriptBlock {
                # Stub for $cmdName
                # $desc
            }
            [PSCustomObject]@{ $propsString
            }
"@
        }

        $funcContent += @"

        }
        catch [VMware.VimAutomation.ViCore.Types.V1.ErrorHandling.InvalidLogin] {
            `$PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    `$_, 'AuthenticationError',
                    [System.Management.Automation.ErrorCategory]::AuthenticationError,
                    `$Server))
        }
        catch {
            `$PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    `$_, 'UnexpectedError',
                    [System.Management.Automation.ErrorCategory]::NotSpecified,
                    `$Server))
        }
    }
}
"@

        # Write function
        $pubPath = "C:\Gem\$moduleName\Public\$cmdName.ps1"
        if (Test-Path "C:\Gem\$moduleName\Public") {
            Set-Content -Path $pubPath -Value $funcContent
        }

        # Tests appending
        $testPath = "C:\Gem\$moduleName\Tests\$moduleName.Tests.ps1"
        if (Test-Path $testPath) {
            $testContent = Get-Content $testPath -Raw
            if ($testContent -notmatch "Context `"$cmdName`"") {
                $testAddition = @"

    Context `"$cmdName`" {
        It `"Function file exists`" {
            Test-Path "`$PSScriptRoot/../Public/$cmdName.ps1" | Should -Be `$true
        }
        It `"Should handle connection failure gracefully (Mock)`" {
            Mock Invoke-AnyStackWithRetry { throw `"Connection lost`" }
            . "`$PSScriptRoot/../Public/$cmdName.ps1"
            { & `"$cmdName`" -Server 'fake' -ErrorAction Stop } | Should -Throw
        }
    }
"@
                $lastBrace = $testContent.LastIndexOf("}")
                if ($lastBrace -ge 0) {
                    $testContent = $testContent.Insert($lastBrace, $testAddition)
                    Set-Content -Path $testPath -Value $testContent
                }
            }
        }
    }
}

Write-Output "Generation Complete."
 

