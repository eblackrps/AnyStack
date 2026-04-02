# AnyStack Enterprise v1.7.9 PSScriptAnalyzerSettings
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
 

