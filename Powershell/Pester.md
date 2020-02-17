## Pester and modules
Pester is the most popular Powershell unit test and mock framework. It is so popular that it became the part of Powershell 5 by default. It is similar to Javascript Mocha and Chai frameworks. Tests written with Pester have rather Behaviour-Driven Development style and tend to be more human-readable.<br />
Unit testing is a great mix with powershell modules which allows to group functions, variables into packages that can be imported by a script or into Powershell console. Modules are easily testable and encourage a better approach for writing Powershell code.

## Table of contents
* [Pester](#pester)
* [Modules](#modules)

## Pester

### Pester usage example
Here is an example of a unit test. As you can see the result of some statement is piped to **Should** statement and if the result is as it should, the test is passed. Simple as that.
```powershell
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe 'Get-User' {
     It 'Gets user with specified name' {
          Get-User -Name "a.kozak" | Should Not Be $false
     }
}

Invoke-Pester
```
**Should** can be used with dozens of other operators, here is the list:
* Be
* BeExactly
* BeGreaterThen
* BeLessThan
* BeLike
* BeLikeExactly
* BeOfType
* Exist
* Containt
* ContainExactly
* Match
* MatchExactly
* Throw (function call should be put in {})
* BeNullOrEmpty
* Not

### Create unit test
You can create unit tests with the following cmdlet:
```powershell
New-Fixture -Path SampleDir -Name Get-Sample
```

### Mocking
Sometimes while testing you need to provide some temporary value or make functions to return some predefined values. Pester has built-in **mock** command so you can start using it right now:
```powershell
Mock -Command xyz -MockWith xyz
Mock Get-Item { [PSCustomObject]@{ Name="a.txt" } } -ParameterFilter { $Include -match 'txt' }
Mock Get-Item 
```

### Test drive
Pester allows you to use a **TestDrive** to create some temporary files for unit tests.
```powershell
$testPath = "TestDrive:\some.txt"
Set-Content $testPath -value "my test text."

'TestDrive:\some.txt'
"$TestDrive\some.txt"
```

### Hide function output
```powershell
function global:Write-Host() {}
```

## Modules

### Testable Powershell modules
If you want to use Pester for TDD or BDD it is good to properly structure your project and make it modular. Follow the steps to achieve it:
1. Create files with unit tests and implementations (that will be tested)
```powershell
New-Fixture -Name Add-User 
```
2. Add module manifest - especially important is the **NestedModules** parameter - it contains the list of exported functions. Here you can see how to create module manifest
```powershell
New-ModuleManifest -Path UserManagement.psd1 -NestedModules @('.\Add-User.psm1') `
    -Author 'Albert Kozak' -ModuleVersion '1.0.0.0' ` 
    -DotNetFrameworkVersion = '3.5' -PowerShellVersion '5.0' `
    -ScriptToProcess @('.\init.ps1')
```
3. Run tests and import the module if they will succeed
```powershell
Invoke-Pester
Import-Module UserManagement
```

### Exporting variables
A module in Powershell can export not only functions, but also variables. It is a good idea to create some *Variables.psm1* file and put exported variables there. This file has to be added on the list of nested modules. Here you can see how to export a variable:
```powershell
$constValue = 'XJ31'
Export-ModuleMemeber -variable constValue
```
An important thing to note is that the name of variabe put in the **Export-ModuleMember** has no **$** (dolar) sign at the beginning! Be careful with that. 

### Exporting aliases
Aliases are very useful especially while working in the console if you often use some function. Here is how to export an alias from a Powershell module:
```powershell
function Import-ImportantData { }
New-Alias -Name ipdata -Value Import-ImportantData
Export-ModuleMember -Alias * -Function *
```
