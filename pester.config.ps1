# AnyStack Enterprise Module Suite - Pester Configuration v1.6.4
@{
    Run          = @{
        Path = '*/Tests/*'
    }
    Output       = @{
        Verbosity = 'Detailed'
    }
    CodeCoverage = @{
        Enabled    = $true
        OutputPath = 'coverage.xml'
    }
}
 





