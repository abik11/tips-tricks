## Mastering the syntax
Powershell syntax may not be easy to understand at a first glance, so it is good to spend some time seeing what Powershell offers. Such knowledge may help you to finish many tasks much faster. 

### Creating PSObjects
**PSObject** is a very flexible structure. It allows you to dynamicaly create structures to store your data depending on your needs. You just have to specify all the properties of the structure and values in a hash array. See an example here:
```powershell
$filelist = ls | % `
  { new-object psobject -property @{ code = $_.Name.Substring(0, $_.Name.IndexOf(".")); CreationTime = $_.CreationTime; }}
```

### Object structure
To get the listing of object's properties and methods us the following command:
```powershell
get-item myfile.txt | get-member
```
Sometimes very useful may be also this one:
```
get-item myfile.txt | select-object *
```
It will list all the properties of the result object with its values.

### .NET class structure
The same works well for .NET classes also:
```powershell
Add-Type -AssemblyName System.Drawing.Image
[System.Drawing.Image] | gm
```

### Add your own and .NET types
You can define your onw classes, structs, with all the functionality that is allowed by CLR and C# and import them into Powershell. You can define constructors, methods, inheritance, anything. This is very useful!
```powershell
$source = @"
public struct Rect{
   public int width;
   public int height;
}
"@
Add-Type -TypeDefinition $source
```
It is also possible to import already existing .NET Framework types.
```powershell
Add-Type -AssemblyName System.Windows.Forms
```
Here you can see how it was done in the older versions of Powershell, just in case if you will ever need it:
```powershell
[Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[Windows.Forms.MessageBox]::Show("Test")
```

### List all the types provided by the assembly
If you are not sure about the types provided by some assembly that you already loaded, you can easily list the types it provides, here is a piece of code that allows you to do that:
```powershell
$asm = [System.AppDomain]::CurrentDomain.GetAssemblies() | ? { $_.FullName -like "*Windows.Forms*" }
$asm.GetTypes() | select Name
```

### Import module
```poweshell
Import-Module -Name ".\Libs\UIAutomation.0.8.7B3.NET35\UIAutomation.dll"
```

### Functions
Basic syntax for definig functions is very easy. The important thing to know is how to return value? In Powershell the last operation return value is what will be returned by the function. You don't have to specify any type of return value or arguments, but you can optionally make it for parameters. It is a good practice to start your function name from a well known verb, like get, set, add, remove, close and so on. To get the list of verbs you can use **Get-Verb** command.
```poweshell
function Get-VNCWindow([string] $domainName, [string] $procName = "vncviewer"){
   ps | ? { $_.Name -eq $procName -and $_.MainWindowTitle -match $domainName }
}
get-VNCwindow -domainName "albert-komp"
```

### Delegates
It may be often required, especially while working with .Net classes, to pass some delegate. But that's not really obvious how to make it in Powershell? That's quite easy, maybe even easier than in C#, look at the following example:
```powershell
[System.Action] $delegate = { write-host "Text" }
[System.Action[string]] $delegateWithParam = { param($text) write-host $text }
$delegate.Invoke()
$delegateWithParam.Invoke("Text")
```

### Advanced functions
You can define functions in advanced mode. In this mode you can define if some parameters are mandatory, validation rules, how the function accepts arguments from pipeline or define parameters set and aliases. All that stuff can be done inside of **param** instruction. Moreover you can use **Write-Verbose** cmdlet inside advanced functions. A function requires **cmdletBinding** to become advanced.
```powershell
function Write-Name {
   [cmdletbinding()]
   param(
       [Parameter(mandatory=$true)]
       [string] $name 
   )
   Write-Verbose "Function is trying to write your name:"
   Write-Host $name
}

Write-Name -n "Albert" -Verbose
```
A nice thing to know about parameters is that you don't have to specify the full name. You have to refer the parameter with as few letters as is enough to recognize it between all the parameters of a function. For example we can access the *-name* parameter with just *-n*.

### Parameter set
A great thing about advanced mode is that you can define parameter set! So you can call the function in few different ways. You can define default set like this: `[cmdletbinding(DefaultParameterSetName='user')]`. And here is an example of a function with two parameter sets:
```powershell
[cmdletbinding(DefaultParameterSetName='user')]
param(
   [ValidatePattern('^.*\.(txt|csv)$')]
   [string] $fileName,
   [Parameter(ParameterSetName='user', Position=0)]
   [string] $name,
   [Parameter(ParameterSetName='user', Position=1)]
   [ValidateRange(0,200)]
   [int] $age,
   [Parameter(ParameterSetName='comp', Position=0)]
   [string] $address,
   [Parameter(ParameterSetName='comp', Position=1)]
   [ValidateSet('Windows7', 'Windows10')]
   [string] $platform
)
switch($PSCmdlet.ParameterSetName){
   'user' {
      # do some things for user
   }
   'comp' {
      # do some things for comp
   }
}
```
There are more options than this! Especially for validation you can use: **ValidateNotNull**, **ValidateNotNullOrEmpty**, **ValidateLength**(min, max), **ValidateCount**(min, max), **ValidateScript({$_.Length -gt 10})** and others! You can have total control over your functions!

### Documenting functions
Here is a structure that you may use to document functions. It is not obligatory to use them all, only those you need.
```powershell
<#
    .SYNOPSIS
    Function1
    .DESCRIPTION
    The best function on the world
    .EXAMPLE
    function -userName a.kozak
    .PARAMETER UserName
    User name
    .NOTES
     author: Albert
    .LINK
     http://www.something.com
#>
```
Later, to get the little documentation you defined, just call **Get-Help** cmdlet:
```powershell
get-help .\Function1.ps1 -full
```
It is a very good practice to document your functions! Think about it!

### Function switch
Switch is a parameter that can be only true or false. If it is not put in the function call, it is false, and if it is put, it is true. It is a very common construction, used in scriptting world, not only in Powershell.
```powershell
function test-switch{
    param(
        [switch] $force
    )
    Write-Host $force
}

test-switch #False
test-switch -force #True
```
As you see, to define a switch you just have to add **[switch]** attribute for the parameter. A nice thing to know is that you can explicitly assing the value to a switch, here is an example:
```powershell
ps -id 1120 | kill -confirm:$false #confirm is a switch
```

### Arguments from pipeline
This is quite complicated stuff, but extremely useful! Can make your functions become deadly flexible, being able to be put as a part of a pipeline chain. This is the another piece of the real power of Powershell.
```powershell
function Read-Name {
    Param(
        [Parameter(ValueFromPipelineByPropertyName=$true)][string]$name
    )
    process{
         Write-Host $Name
    }
}
$user = @{ Name = "Albert" }
$user | Read-Name
```
Here we get the value from pipeline **by property name**. That means that the function must recieve the data that in its structure has some property called the same way as the parameters that are took from pipeline. Simple as that, but it may sound quite complicated, it is a good idea to try it on your own before really understanding. You can also get the data from pipe by value, just use **ValueFromPipeline** instead of **ValueFromPipelineByPropertyName**.

### Function slapping
This is a technique that allows you to create a hash array with the key names corresponding to the names of some function parameters, and then to use this hash array as a function parameter instead of specifying each parameter separately. Here is a nice example: 
```powershell
$params = @{ ComputerName = '172.21.0.4'; Credential = $cred }
Enter-PSSession @params
```
This is the same as this:
```powershell
Enter-PSSession -ComputerName = '172.21.0.4' -Credential = $cred
```

### Sorting by expression
This is real tricky :D You can define your own expressions in **Select-Object** cmdlet. It is possible by passing a hash array as on of the arguments with the name of your expression and the expression itself in **{** brackets **}**. Here you can see a nice example:
```powershell
ls | select name, @{name="kbSize";expression={$_.length/1KB}} | sort kbSize
```
Those hash arrays seem to by extremely flexible constructions!

### Sort, aggregate and filter
```powershell
ls | sort-object -descending -property Mode, Extension
ls | measure-object -property length -sum -average
ls | ? {$_.length -gt 1000} | sort -property extension
```

### Sorting hash arrays
Hash arrays are stored in Powershell as a **HashTable** type. This structure totally doesn't care about ordering its items, it cares about beeing as fast as possible. But what if you have to get its items sorted? And you will for sure sooner or later need it. You can make it by using the **GetEnumerator** method, here is an example, it is very easy!
```powershell
$hash.GetEnumerator() | sort -property Value -descending
```

### String search
Here you see an example of searching the processes listening on port 1900. This kind of search is a bit different from most searching functions in Poweshell since they usually use some property and compare its value. **Select-String** is trying to find a matching string in the whole text, for example a result of some command. Sometimes it is useful too, especially while working with older commands like netstat. 
```powershell
netstat /abn | select-string -pattern '1900'
```

### Slice an array
It is very often useful to get for example the elements of an array from 4 to 8, or last two or something like this, which is often called slicing. Here in a little example you will see how to do it with Powershell:
```powershell
$stringArray = "This is an array of chars"
$tmp = $stringArray[($strinArray.Length-3)..($strinArray.Length-1)] #last two elements
$tmp = $stringArray[4..8]
```

### Show results in grid
```powershell
ls c:\temp | out-gridview -passThru
```

### Get the first element of the list
```powershell
(ps | ? { $_.ProcessName -eq "vncviewer" })[0]			# method 1
ps | ? { $_.ProcessName -eq "vncviewer" } | select -first 1	# method 2
```
The problem with the first method is that if the result is null, you will get an error since you are trying to get the first element of an array that doesn't exist. The second method will simply return nothing, much less error prone solution.

### Regular expressions
Regular expressions are important component of every programming language. To use them you just have to use the **-cmatch**, **-creplace** or **-match**, **-replace** switches of **String** type (it works very similarily to **-split** and **-join**). Important thing to note is that the first two switches (with **c** at the beginning) are case-sensitive.
```powershell
'ABc...xyz' -cmatch '^[A-Za-z]*\.{3}[a-z]*$' #True
'ABc...xyz' -creplace '\.{3}', '_'	#ABc_xyz
```
A great thing to know is that you can use regular expressions with **-split**! By doing this you can split a given text by all whitespaces for example:
```powershell
$array = $textData -split "\s+" 
```
[Go here](https://kevinmarquette.github.io/2017-07-31-Powershell-regex-regular-expression/) to read much more about regular expressions.

### Inline if
```powershell
$v1 = 2;
$v2 = 2;
$value = @{ $true = 1; $false = -1 }[$v1 -eq $v2]
```
This is a really nice trick, worth a word of two of explanation. All the magic here is that we define a hash array with two elements with keys **$true** and **$false** and some values. So if we want to access the element with key **$true** we recieve one value and when we want to access the element with key **$false** we recieve another one. Moreover, we calculate the key dynamically - here by comparing the equality of two variables. So if they are equal we recieve the first element of the hash array and if not, the second element. Really cool!

### Disable printing to the console
There are few weird things in Powershell and one of them is that it is trying to print out to the console every operation that it computes, but there is a very easy way to disable this, you just have to pipe the result of the computation to **Out-Null** cmdlet.
```powershell
$i++ | out-null
```

### Random
Being able to use some random values is quite common. Powershell has a very nice **Get-Random** cmdlet which is quite universal. Here is an example of how to get a random integer from defined range, the returned integer will serve as an index for an array:
```powershell
$index = Get-Random -Min 0 -Max $players.Count
$currentPlayer = $players[$index]
```
But to get randomly an element of the array we can make it even easier:
```powershell
$currentPlayer = Get-Random $players
```

### Date
```powershell
Get-Date
get-date -format 'yyyy.MM'		#2017.11
get-date -format 'yy' -year 2005	#05
Get-WmiObject -ClassName Win32_localtime
```

### Powershell 5
Many new language features were added to Powershell in version 5. For example namespaces:
```powershell
using module Server; #our own module Server.psm1
using namespace System.Data.SqlClient;
[SqlConnection]::new()
```
Also enums were added:
```powershell
enum OSType {
    Unknown
    Windows
    Linux
}
[OSType] $myOS = 'Linux'
[OSType] $myOS2 = 'Windows'
```
and classes with all the object-oriented stuff like constructors, inheritance, overrides and so on:
```powershell
class Vehicle {
     [int] $Mileage
     Vehicle([int] $mileage){
          $this.Mileage = $mileage
     }
}

class Car : Vehicle {
     [int] $Speed
     Car ([int] $mileage, [int] $speed) : base($mileage){
          $this.Speed = $speed
     }
     [void] Drive-Faster([int] $moreSpeed){
          $this.Speed += $moreSpeed
     }
}

$myCar = [Car]::new(100, 50)
```
Another new thing is a quite big number of new cmdlets, among them functions that allow to easily convert data from and to JSON format. Here you can see an example of how to get data from web service (with default proxy) and finally convert it to JSON:
```powershell
$apiquery = 'http://samples.openweathermap.org/data/2.5/weather?...'
$proxy = [System.Net.WebProxy]::DefaultProxy
$cred = [System.Net.CredentialCache]::DefaultWebProxy
$proxy.Credentials = $cred
$web = new-object System.Net.WebClient
$web.Proxy = $proxy
$result = $web.DownloadString($apiquery) | ConvertFrom-Json #There is also ConvertTo-Json
```
