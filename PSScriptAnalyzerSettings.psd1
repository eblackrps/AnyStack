# AnyStack Enterprise v1.5.0 PSScriptAnalyzerSettings
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
