$projectRoot = Resolve-Path "$PSScriptRoot\.."
$script:ModuleName = 'RundeckPS'
$moduleRoot = "$projectRoot\$ModuleName"

Describe "PSScriptAnalyzer rule-sets" -Tag Build {

    $Rules = Get-ScriptAnalyzerRule | Where {$PSItem.RuleName -ne 'PSAvoidUsingConvertToSecureStringWithPlainText' -AND $PSItem.RuleName -ne 'PSAvoidTrailingWhitespace' -AND $PSItem.RuleName -ne 'PSUseShouldProcessForStateChangingFunctions'}
    $scripts = Get-ChildItem $moduleRoot -Include *.ps1, *.psm1, *.psd1 -Recurse | where fullname -notmatch 'classes'

    foreach ( $Script in $scripts ) 
    {
        Context "Script '$($script.FullName)'" {

            foreach ( $rule in $rules )
            {
                It "Rule [$rule]" {

                    (Invoke-ScriptAnalyzer -Path $script.FullName -IncludeRule $rule.RuleName ).Count | Should Be 0
                }
            }
        }
    }
}


Describe "General project validation: $moduleName" -Tags Build {

    It "Module '$moduleName' can import cleanly" {
        {Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force } | Should Not Throw
    }
}