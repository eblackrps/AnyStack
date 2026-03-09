# AnyStack Enterprise Module Suite - Pester Configuration v1.6.8
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
 









