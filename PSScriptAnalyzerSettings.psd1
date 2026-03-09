# AnyStack Enterprise v1.6.6 PSScriptAnalyzerSettings
@{
    Severity     = @('Error')
    ExcludeRules = @(
        'PSUseConsistentWhitespace',
        'PSAlignAssignmentStatement',
        'PSAvoidUsingWriteHost'
    )
    Rules        = @{
        PSUseConsistentIndentation = @{ Enable = $true; IndentationSize = 4 }
    }
}
 







