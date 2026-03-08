@{
    Severity     = @('Error', 'Warning')
    ExcludeRules = @()
    Rules        = @{
        PSUseConsistentIndentation = @{ Enable = $true; IndentationSize = 4 }
        PSUseConsistentWhitespace = @{ Enable = $true }
        PSAlignAssignmentStatement = @{ Enable = $true }
        PSAvoidUsingWriteHost = @{ Enable = $true }
    }
}
