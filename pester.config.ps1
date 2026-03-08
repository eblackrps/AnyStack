# AnyStack Enterprise Module Suite - Pester Configuration v1.5.0
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


 

