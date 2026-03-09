# AnyStack Enterprise Module Suite - Pester Configuration v1.7.1
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
 










