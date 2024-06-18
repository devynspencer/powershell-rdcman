BeforeAll {
    Import-Module -Force "$PSScriptRoot/../RDCMan/RDCMan.psd1"

    $MockParams = @{
        ModuleName = 'RDCMan'
        CommandName = 'Get-Content'
        ParameterFilter = { $Path -like '*.rdg' }
        MockWith = { Import-Clixml -Path "$PSScriptRoot/../Tests/TestConfig.xml" }
    }

    Mock @MockParams
}

Describe 'Get-RDCManConfiguration' {

    It 'Should return a configuration object' {

    }
}
