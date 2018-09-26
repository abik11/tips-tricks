# Powershell - Tips for beginners

This is not a complete guide how to learn Powershell. This is just a set of some tips, some thoughts of how to do something with Powershell. It may be useful for beginners to quickly go through some difficulties.

* [Everyday struggles](#everyday-struggles)
* [Processes, services and tasks](#processes-services-and-tasks)
* [Files and directories](#files-and-directories)
* [Databases](#databases)
* [Mastering the syntax](#mastering-the-syntax)
* [Getting information](#getting-information)
* [Users and groups](#users-and-groups)
* [Remote control](#remote-control)
* [Powershell with Linux](#powershell-with-linux)
* [Application scripting](#application-scripting)
* [Powershell 5](#powershell-5)
* [Pester and modules](#pester-and-modules)
* [Appendix A - Linux commands](#appendix-a---linux-commands)
* [Appendix B - Serial port](#appendix-b---serial-port)
* [Appendix C - Colors in .Net](#appendix-c---colors-in-.net)
* [Appendix D - Wmic and netsh](#appendix-d---wmic-and-netsh)
* [Useful links](#useful-links)

## Everyday struggles

### Copy and paste text in the console
Just select some text and use right mouse button. And then again right click to paste the coppied text. In Powershell 5 it is much easier since you can use well known shortcuts as CTRL + C and CTRL + V, but for older Powershells, remember the right click!

### Break the command to the new line
If you are typing something in the console and you want to contiune in the new line just the **\`** character.

### Special characters
The **\`** character will be also used to represent special caracters in Powershell. Type **\`n** for new line, **\`t** for tab, **\`r** for carriage return, **\`b** for backspace and **\`a** alert sound.

### Commands history
Use the `h` command to show the history of latest commands. Every command in the history has some ID and you can re-run given command from the history like this: `r 10`.

### Getting help
One of the biggest strength of Powershell is that you can find a lot of information about the language just using the console! There are some handy cmdlets that will make your everyday life with Powershell much easier. Here you can see how to list all the cmdlets that contain the word *process*:
```powershell
get-help *process*
```
Simple as that! And if you will type this:
```powershell
get-help about*
```
you will see the list of so called *abouts*, some little tutorials built-in into the Powershell. You can learn a lot of things about Powershell reading those *abouts*. Now, if you will type this:
```powershell
get-command
```
you will see the whole (loooong) list of all available cmdlets and functions for you. This may grow if you will import some external modules. You can get the list of cmdlets of some specified verb, for example:
```powershell
get-command -verb get
```
Just as cmdlets, you can list all the available modules:
```powershell
get-module
```
This is very useful to know when you try to find some function in a specific module. Here is how to find it:
```powershell
get-command -module UIAutomation -name *button*
```
If you are just interested in the examples of how to use some cmdlet you can use the **-examples** switch. You can also show help in external window with some simple GUI using **-ShowWindow** switch. Here you can see how to use both those switches at once:
```powershell
get-help Stop-Process -Examples -ShowWindow
```

### Common aliases
While it is not a good practice to use aliases when you develop some large script or reusable modules, it is very acceptable and often time saving to use them when you type command directly in the console. Here is the list of the most important ones, worth remembering:
* man = help = Get-Help
* gm = Get-Member
* **ls** = dir = Get-ChildItem
* **cd** = Set-Location
* del = ri = Remove-Item
* pwd = Get-Location
* kill = Stop-Process
* cat = gc = Get-Content
* select = Select-Object
* where = **?** = Where-Object
* sort = Sort-Object
* foreach = **%** = ForEach-Object
* ps = Get-Process
* ft = Format-Table
* echo = write = Write-Output
* sleep = Start-Sleep
* cls = Clear-Host

### Problems with Execution Policies
If you will write your own scripts and try to run them, Powershell may not allow you because of default **Execution Policies**. If you want to work without any problem you can change the policy to **unrestricted** or **bypass**, but take into consideration some security issue.
```powershell
get-executionPolicy -list
set-executionPolicy unrestricted -scope localMachine
set-executionPolicy bypass -scope CurrentUser
```

### Powershell providers
There is something called **Powershell providers**, which is a program that encapsulates some data with access logic, like read, write, list and allows Powershell to use as it was a file system drive. For example **FileSystem** provider brings you the **C:**, **D:** and other drives that are mounted on your machine. **Registry** provider brings you **HKCU** and **HKLM** drives so you can explore Windows Registry with commands like ls, cd, pwd and so on! You can list all the Powershell providers and Powershell drives with **Get-PSProvider** and **Get-PSDrive** commands. Here you can see some little examples:
```powershell
get-PSProvider
get-PSDrive
cd C:\
cd HKLM:
cd HKCU:
cd variable:	#Powershell variables
cd Env:		#System variables
```

### System variables
It may be very often useful to work with system variables. And it is very easy to do that in Powershell. Here you can see two ways how to get the value of a system variable, like always in Powershel - ***there is more than one way to do it*** (this is actually [Perl's motto](https://en.wikipedia.org/wiki/There%27s_more_than_one_way_to_do_it) but quite applicable for Powershell too):
```powershell
#method 1
cd Env:	
new-item -itemType env -value "C:\Android\android-sdk" ANDROID_HOME

#method 2
$env:ANDROID_HOME = "C:\Android\android-sdk" 
```
In method one we use PSProvider and **new-item** cmdlet to add new variable. With the same method we can add files, directories, registry keys and many more, depending on your PSProviders!

### Powershell profile
You can personalize Powershell console and variables. There is something called Powershell profile, it is a Powershell script that will be run before the console will start. You can put there some variable initialization, some customization, anything you want Powershell do for you everytime when you work in the console. One of the most useful things is to put there module or library imports so you will have all the necesary functions and cmdlets after starting Powershell console. The path to Powershell profile is stored in **$profile** variable.
```powershell
notepad $profile
```

### Powershell console size
To set the console size you can use the following code:
```powershell
$windowSize = $Host.UI.RawUI.WindowSize
$windowSize.Width = 140
$windowSize.Height = 52

$bufferSize = $Host.UI.RawUI.WindowSize
$bufferSize.Width = 140
$bufferSize.Height = 1024

$Host.UI.RawUI.BufferSize = $bufferSize
$Host.UI.RawUI.WindowSize = $windowSize
```
It is a good idea to put this kind of code in Powershell profile.

### Powershell console custom colors
Changing colors to some custom values is surprisingly not an easy task. You have to add some windows registry key, see an example:
```powershell
cd HKCU:\Console
$powershellRegKeyName = "%SystemRoot%_system32_WindowsPowerShell_v1.0_powershell.exe"

new-item $powershellRegKeyName
cd $powershellRegKeyName

new-itemProperty . ColorTable00 -type DWORD -value 0x00F0EDEE #this is background
new-itemProperty . ColorTable07 -type DWORD -value 0x00464646 #this is foreground
```
Color values should be given as hex, go [here](https://www.webpagefx.com/web-design/color-picker/) to pick some fancy colors.<br />
By the way, in this registry key you can also allow quick edit for the console window:
```powershell
new-itemProperty . QuickEdit -type DWORD -value 0x00000001
```

### Powershell version
If you don't know what version of Powershell is installed on the machine, and that may be very important, you can get that information quickly in two ways:
```powershell
$host.version
$PSVersionTable
```

### Is current Powershell process 64-bit?
This may be sometimes a very important question, if you want to use some external tools in your scripts, you could use specific version, depending on Powershell process version. Here are two ways how to check it:
```powershell
[Environment]::Is64bitProcess	#Powershell 3.0 and above
[IntPtr]::Size -eq 8		#Any version of Powershell
```
If a result of the above expressions is true then Powershell process is 64-bit, else it is 32-bit.
 
### Stop execution after error
As default, Powershell will not stop on errors, Powershell is a fighter and never gives up but you can force it stop on errors if you want. To this you have to set **$ErrorActionPreference** variable to **Stop**:
```powershell
$ErrorActionPreference = 'Stop'
```
You can find this variable while exploring **variable:** PSDrive of course!

### Turn off error messages
Sometimes you may want to intentionally turn off error messages for some command or function. If you want to turn off all the errors in whole script you just have to change the value of **$ErrorActionPreference** variable:
```powershell
$ErrorActionPreference = 'Silentlycontinue'
```
But this approach is not always a good idea. It is much better to silent only those functions where you are sure that you don't care about errors, to make it use the **-errorAction** attribute:
```powershell
get-process VisualStudio -errorAction 'silentlyContinue'
```

## Processes, services and tasks
This is a very important feature of any scripting language to be able to spawn, kill and generally manage processes or services. Powershell does it perfectly well.

### Search process
You can list all processes with **ps** cmdlet and than filter them with **where-object** (?):
```powershell
ps | ? { $_.name -eq "vncviewer" -and $_.MainWindowTitle -match `
"corp11x431" } | select MainWindowTitle, StartTime, ProcessName, Id | ft -auto
```
`ft -auto` will format the result table to make it fit the console screen.

### Stop process
Killing processes is very easy!
```powershell
kill 1531
ps | where { $_.name -eq "MicrosoftEdge"  } | kill
```

### Get process path
It may be useful to retrive path of some process:
```powershell
ps | select Name, Path
```

### Start process
To start a new process you can use .Net framework:
```powershell
[System.Diagnostics.Process]::Start("osk")		#screen keyboard
[System.Diagnostics.Process]::Start("TabTip")	#writing tool :)
```

### List of running services
To get the list of running services, or stopped, or all, we can use Powershell cmdlet or WMI, here you can see both methods:
```powershell
Get-Service | ? { $_.Status -eq 'Running' }
Get-WmiObject win32_service | ? { $_.State -eq 'Running' } | ft -a
```

### Create service
You can also manage services with Powershell, here is an example of how to create one:
```powershell
new-service -name TestService -displayName "Test Service" `
   -description "Usługa testowa" -dependson NetLogon -startupType Manual `
   -binaryPathName "C:\WINDOWS\System32\svchost.exe -k netsvcs" `
sc.exe delete TestService #usuwanie usługi
```

### Create a job
Although creating processes and services is very useful, sometimes you would like to start some little task simply in the background without creating new process or service. This can be achieved in Powershell with **jobs**. See here how to start a new job:
```powershell
Start-Job -ScriptBlock {
    Add-Type -AssemblyName System.Windows.Forms
    while($true){
        $dt = [System.DateTime]::Now
	if($dt.Minute -eq 10 -and $dt.Second -eq 0){
	    [Windows.Forms.MessageBox]::Show('Move your ass!')
	}
    }
}
```
The above job will display message box 10 minutes after every hour.<br />
To see the list of jobs you can use the `Get-Job` cmdlet. Jobs can be stopped with `Stop-Job`, suspended and resumed with `Suspend-Job` and `Resume-Job`. If a job returns some value, you can get this value with `Receive-Job` and you can also wait for some job to finish with `Wait-Job`.

## Files and directories
Powershell is perfect tool to work with files and directories. It can be used to easily optimize some repetitve tasks working with files and directories. Give it a try!

### Current script and module directory
It is often very useful to get the current script directory, here is how to do it: 
```powershell
$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
Set-Location $scriptPath
```
Also when you will define your own modules, you can get its path like this:
```powershell
$ModuleDir = Split-Path $PSCmdlet.MyInvocation.MyCommand.Module.Path -Parent
```

### Check if the path exists
```powershell
Test-Path "C:\Temp"
pwd | Test-Path #always returns true :)
```

### Read and filter text from file
Here we read file content with **Get-Content** (gc) cmdlet, split it by new line and then, if it doesn't start from *#* and is not null or empty it is split by comma. Finally, every piece of text recieved is then trimmed, all spaces are removed. It is just a simple nice example, how easy it is in Powershell to get the text, filter it and do some simple transformations, this the real power!
```powershell
((gc .\sample.txt) -split "`n" `
   | ? { !$_.StartsWith("#") -and ![String]::IsNullOrEmpty($_) }) -split "," `
   | % { $_.Trim(" ") }
```

### Save to file
You can use **Out-File** to save some stuff to the file. It has a nice switch **-append**, it allows you to not to replace existing file, but add your new content to the file. Nice feature!
```powershell
$dir = pwd
"test content" | out-file "$dir\new1.txt" -append
```

### Delete files and directories
```powershell
rm "C:\new1.txt" 
remove-item C:\Temp -recurse
```

### Creating directories and files
There is an alias **mkdir** that you can use to create directoties, but there is also the **New-Item** cmdlet, much more generic solution. It has **-type** switch so you can define what kind of resource you want to create. 
```powershell
mkdir "folder"
new-item "new1.txt" -type file
```

### Copying and moving files
```powershell
dir file.txt | copy -dest "C:\Temp\"
dir file.txt | move -dest "C:\Temp\"
```

### Change name of multiple files
```powershell
$int = 1
(ls) | % { rename-item $_.FullName -NewName `
  (([string]$_.name).Substring(6).Replace(".mp3", "") + "_$int.mp3"); $int += 1 }
```

### File name, extension and directory 
One of the nicest thing about Powershell that is a huge part of its power is that you can without any limits use all the .Net Framework classes. Here is a nice example how to get the name of a file, its extension and its directory with .Net methods:
```powershell
[System.IO.Path]::GetFileNameWithoutExtension("D:\Files\note.txt") #note
[System.IO.Path]::GetExtension("D:\Files\note.txt") #.txt
[System.IO.Path]::GetDirectoryName("D:\Files\note.txt") #D:\Files
```

### Hide a file
With **attrib** command it is possible to add or remove file attributes like read-only (**R**), archive (**A**), system (**S**) or hidden (**H**) file attributes. You have to use plus or minus signs to respectively add or remove some attribute. Here you can see an example of how to add hidden file attribute:
```powershell
attrib +H names.txt
```
To be able to list this file you have to use **-Hidden** switch. 
```powershell
ls -hidden
```

### Join-Path
```powershell
join-path -path "D:\Test" -childpath "file.txt" 
```

### Head and tail
```powershell
gc file.txt -totalCount 3	#first 3 rows of the file
gc file.txt -tail 2		#last 2 rows of the file
```

### Advanced file searching
The following command will find in *D:\project* all the .cshtml files that do not contain the word *Partial* in their names:
```powershell
get-childitem d:\project -recurse -include *.cshtml -exclude *Partial*  
```
**Get-ChildItem** has many aliases worth remembering: ls, dir, gci. This **-recurse** switch toegether with **-include** and **-exclude** parameters are mind blowing!!! Searching files with this tool is unbelievable! UN-BE-LIE-VA-BLE! :D

### Clear recycle bin
Everything can be done with Powershell, literally everything... :]
```powershell
Clear-RecycleBin -Force
```

### Export results to Excel/CSV
```powershell
get-service | select name, status `
	| export-csv c:\temp\uslugi.csv -delimeter ";" -noTypeInformation
```

### Import CSV
Here is an example CSV file to be imported:
```csv
Rui;24;Portugal
Albert;26;Poland
```
And here is how to do it:
```powershell
$csv = import-csv 'file.csv' -delimeter ; -header 'name','age','nationality'
```

### Zip and unzip
```powershell
Add-Type -Path `
"C:\Windows\Microsoft.NET\assembly\GAC_MSIL\System.IO.Compression.FileSystem\v4.0_4.0.0.0__b77a5c561934e089\System.IO.Compression.FileSystem.dll"
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipFile.FullName, "D:\data")
[System.IO.Compression.ZipFile]::CreateFromDirectory("D:\data", "D:\data.zip")
```

### Run a link to exe file
```powershell
& '.\UltraVNC Viewer.lnk'
```

### Create a symbolic link to a file
Before Powershell 5.0 the easiest way to create a symbolic link was to run **mklink** command through **cmd**. Here is an example of how to create a symbolic link to a file:
```powershell
cmd /c mklink symbolicLink.exe d:\programs\firefox.exe
```
and here how to create a symbolic link to a directory:
```powershell
cmd /c mklink symbolicLinkToPrograms d:\programs /d
```
Since Powershell 5.0 you can create a symbolic link using **New-Item** command for both a file or a directory:
```powershell
New-Item -Path symbolicLinkToPrograms -ItemType SymbolicLink -Calue d:\programs
```

### Count file checksum
It is a nice example of how something can be done in Powershell way using cmdlet and .Net or C# way using .Net Framework classes. Firstly, lets see how easy it is with **Get-FileHash** cmdlet:
```powershell
Get-FileHash .\myapplication.exe
```
C# way is a bit more complex (but not complicated), still it is nice to see an example to keep in mind that Powershell can use .Net classes with *extreme* ease:
```powershell
[System.IO.FileStream] $fileStream = [System.IO.File]::OpenRead("myapplication.exe")
$sha = New-Object -TypeName System.Security.Cryptography.SHA256Managed
$checksum = $sha.ComputeHash($fileStream)
[System.BitConverter]::ToString($checksum) -creplace "-", ""
```
The result of running both codes should be the same if you will run it against the same file of course. Also be careful because the current path in Powershell is not the same as the current path in .Net. To see the current path in .Net you can use one of the two following lines:
```powershell
[Environment]::CurrentDirectory
[System.IO.Directory]::GetCurrentDirectory()
```
And to change the current directory in .Net use this:
```powershell
[System.IO.Directory]::SetCurrentDirectory("D:\data\scripts")
```

## Databases
Powershell is great tool to work with databases. It may easily serve as a glue tool between different kind of systems, importing some data from one to another or enabling integration. You can use ADO .NET in Powershell, SMO (SQL Server Management Objects) or some third party libraries. If you are interested in this topic, read more [here](https://github.com/abik11/tips-tricks/blob/master/DB.md).

## Mastering the syntax

### Creating PSObjects
**PSObject** is a very flexible structure. It allows you to dynamicaly create structures to store your data depending on your needs. You just have to specify all the properties of the structure and values in a hash array. See an example here:
```powershell
$filelist = ls | % `
  { new-object psobject -property @{ code = $_.Name.Substring(0, $_.Name.IndexOf(".")); CreationTime = $_.CreationTime; }}
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

### Show results in grid
```powershell
ls c:\temp | out-gridview -passThru
```

### Get the first element of the list
```powershell
(ps | ? { $_.ProcessName -eq "vncviewer" })[0]				# method 1
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

## Getting information
With Powershell you have access to huge amounts of different sources of information. With WMI, Event Log, different XML configuration files, COM Shell Object and others you can get some data about the system, network, files. Here you can see few interesting pieces of code. 

### Date
```powershell
Get-Date
get-date -format 'yyyy.MM'		#2017.11
get-date -format 'yy' -year 2005	#05
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

### Visual Studio 2012 project reference list
This is also a nice one! Here the **.csproj** XML file is parsed and is searched for the **Reference** nodes. A nice thing to take a glance is that we have to add the namespace used in this file to be able to run XPath query.
```powershell
[xml]$project = gc "MyProject.csproj"
$nm = New-Object -TypeName System.Xml.XmlNamespaceManager -ArgumentList $Project.NameTable
$nm.AddNamespace('x', 'http://schemas.microsoft.com/developer/msbuild/2003')
$nodes = $Project.SelectNodes('/x:Project/x:ItemGroup/x:Reference', $nm) 
$nodes | % { ($_.Include -split ",")[0] }
```

### Length of MP3 file
This one is quite tricky! We have to use COM **Shell** Object. Especially interesting for us is the method called **GetDetailsOf**. And detail number **27** has the information about the length of the MP3 file.
```powershell
$path = (ls C:\music | select -first 1 fullname).FullName.ToString()
$folder = split-path $path
$file = split-path $path -leaf

$shell = New-Object -ComObject Shell.Application
$shellFolder = $shell.NameSpace($folder)
$shellFile = $shellfolder.ParseName($file)
$shellfolder.GetDetailsOf($shellfile, 27)
```

### List of Appx Packages
In Windows 10 there is something as Appx Package. As default some stuff is installed like Zune, Spotify and others. You can list it, filter and easily delete, see here:
```powershell
Get-AppxPackage *spotify* | remove-AppxPackage
```

### Computer screen information
Again, two easy ways (and problably thousands less easy ways :] ) to do that. Here you can see how to get the information about screens from WMI:
```powershell
Get-WmiObject -Class Win32_DesktopMonitor
```
And here from the .NET class:
```powershell
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Screen]::AllScreens
```

### Processor usage
```powershell
Get-wmiobject win32_processor | select  loadPercentage | fl
```

### Operating system information in BIOS
```powershell
Get-WmiObject Win32_OperatingSystem | select *
Get-WmiObject Win32_Bios | select *
```

### List of installed hotfixes
```powershell
Get-HotFix
```

### When the PC was turn off
It is a simple search in Event Log. All we have to do is to find all the logs with **EventId** equal to **1074** which corresponds to the shutdown action.
```powershell
get-eventlog -logName system -source "USER32" | ? { $_.EventId -eq 1074 }| ft -wrap
```

### Network name and address
```powershell
$env:USERDOMAIN
[System.Net.Dns]::GetHostName()
[System.Net.Dns]::GetHostEntry([System.Net.Dns]::GetHostName())
```

### Network interfaces
```powershell
$netAdapters = get-wmiObject win32_networkAdapterConfiguration `
				-namespace 'root\CIMV2' | ? { $_.IPEnabled -eq $True }
$netAdapters[0].DNSDomain
$netAdapters[0].IPAddress
$netAdapters[0].Description
```

## Users and groups
One of the most common tasks that can be scripted are connected with users and groups managment. Powershell is a great tool for this, here you will see some commands and cmdlets that might be useful.

### Manage user groups
To list all the groups in domain you can use the following command:
```powershell
net group /domain
```
And if you are interested in some particular group and want to list all the users you can just put its name as an argument:
```powershell
net group "_Comapny Department" /domain 
```
**net** command is quite powerfull and also allows you to display all users, add or delete groups, check server time and so on.
```powershell
net user /domain
net user john.smith /domain
net time /domain
```
Here you can see how to add some user to **administrators** local group:
```powershell
net localgroup administrators john.smith /add
```
And how to add and delete a user from domain group:
```powershell
net group "_Company Department" john.smith /domain /add
net group "_Company Department" john.smith /domain /delete
```

### What groups user *driectly* belogns to?
To get the answer for the above question we can just simply execute the following command:
```powershell
net user user.name /domain
```
It is really cool but it has some disadvantage (or advantage depending on your sense of taste :D) because the result is pure text. It is possible to get the same information but as objects which is more *powershell way* of doing things. It is a bit more complicated since it requires us to use .Net classes, but is worth it! 
```powershell
# adding required assemblies
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
Add-Type -AssemblyName System.DirectoryServices

# preparing enum values that we will use later
$vdomain = [System.DirectoryServices.AccountManagement.ContextType]::Domain
$vsam = [System.DirectoryServices.AccountManagement.IdentityType]::SamAccountName

# getting the job done ;)
$context = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext $vdomain, "DomainName"
$userPrincipal = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($context, $vsam, "j.smith")
$userPrincipal.GetGroups() | select SamAccountName, name
```
This way we get all the current user groups in an object way. Moreover we have an access to a lot of other information about the current user from Active Directory, this is a really nice bunch of classes to play with!

### Get user extended properties
There is a very easy way to get extended properties with **Get-ADUser** cmdlet, here is an example:
```powershell
Get-ADUser j.smith -Properties EmployeeNumber
```
Here *EmployeeNumber* is an extended property and to get it, you just have to put in the **Properties** list. But there is also a bit more difficult (less powershellish :)) way that you can see here:
```powershell
# adding required assemblies
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
Add-Type -AssemblyName System.DirectoryServices

# preparing enum values that we will use later
$vdomain = [System.DirectoryServices.AccountManagement.ContextType]::Domain
$vsam = [System.DirectoryServices.AccountManagement.IdentityType]::SamAccountName

# getting the job done
$context = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext $vdomain, "DomainName"
$userPrincipal = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($context, $vsam, "j.smith")
$entry = [System.DirectoryServices.DirectoryEntry]$userPrincipal.GetUnderlyingObject()
$entry.employeeNumber #here you can access the extended property

# getting the job even more difficult way - but this may be useful while translating to C#
$searcher = New-Object -type System.DirectoryServices.DirectorySearcher $entry
$searcher.PropertiesToLoad.Add("employeeNumber")
$results = $searcher.FindAll()
[string]$employeeNumber = $results.Properties["employeeNumber"] #here you can access the extended property
```
With **Get-ADUser** you can get extended properties for all users at once:
```powershell
Get-ADUser -Filter * -Properties EmployeeNumber
```

### Set user properties
With a **Set-ADUser** cmdlet you can set user's properties as easily as getting them, see here:
```powershell
Set-ADUser -Identity j.smith 
	-Remove @{SecondaryMail="smith.j@evilcorp.com"} -Add @{EmployeeNo="4214"} -Replace @{Title="manager"} -Clear description
```
Those ActiveDirectory commands are really cool, aren't they?

### Get current user name and domain name
There are several ways to get current user name, see here: 
```powershell
#1 
[System.Environment]::UserName

#2 
$winPrincipal = [Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())
$winPrincipal.Identity.Name
```
Getting current domain name is also an easy task:
```powershell
[System.Environment]::UserDomainName
```

### Check if current user is Administrator
```powershell
$winPrincipal = [Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $winPrincipal.IsInRole("Administrator")
```

### Currently logged in users
```powershell
query user /server:$computer_ip
```

## Remote control
Powershell has really nice remote capabilities which allows you to do your job from one machine, remotely executing scripts and commands on other machines.

### Ping
Of course you can execute the plain old `ping` command, but Powershell brings us the new, object-oriented cmdlet Test-Connection, here is some little example, just returning **$true** if it could ping the given host:
```powershell
(Test-Connection 192.168.64.132 -quiet) -eq $True
```

### User credentials
There is a very useful cmdlet **Get-Credential** that prompts user for the credentials and ther returns them. It is useful because many different Powershell cmdlets will ask for credentials as one of the arguments. The following examples shows how to get the username and password as readable string from the **PSCredential** object:
```powershell
$crd = Get-Credential
$user = $crd.UserName
$pass = [Runtime.InteropServices.Marshal]::PtrToStringAuto `
		([Runtime.InteropServices.Marshal]::SecureStringToBSTR($crd.Password))
```

### Secure string
```powershell
ConvertTo-SecureString -String "runforrestrun"
ConvertFrom-SecureString -SecureString $secureStr
```

### Remote PowerShell session
```powershell
$cred = get-credential
Enter-PSSession -ComputerName '172.21.0.4' -Credential $cred 
Enter-PSSession -VMName "WinServer" #hyperV
Exit-PSSession
```

### Remote script and command execution
```powershell
Invoke-Command -ComputerName pc -FilePath C:\skrypty\skrypt.ps1
Invoke-Command -ComputerName pc -scriptblock { ... } 
Invoke-Command $session -scriptblock { ... } 
```

### Session with many machines
```powershell
$session = New-PSSession -ComputerName pc1, pc2, pc3
Invoke-command -session $session -scriptblock { ... }
Get-PSSession #session list
Enter-PSSession $session
Exit-PSSession
Remove-PSSession $session
```

### Use local variables in remote session
Very often it is useful to use some local variables inside of the command block you want to execute remotely. To do that you have to use **-argumentList** and put all the variables that you want to use. In remote code block you can specify with **param** expression the required variables just like in the functions. But it is not necessary, you can also access the variables by **$args** table.  
```powershell
$userName = "R2D2"
$password = "I<3C3PO
Invoke-command -session $s -argumentList $userName, $password
   -Command {
       param($userName, $password)
       $user = dsquery user -name $userName
       dsmod user $user -pwd $password -mustchpwd no -disabled no
   }
```

### Turn on remote command execution
As a security issue, remote control may be turned off. To turn it on, run this set of commands:
```powershell
Enable-PSRemoting –Force
Set-Item wsman:\localhost\client\trustedhosts * #add machine to trusted
Restart-Service WinRM
```
To turn it off again use those:
```powershell
Stop-Service WinRm
Disable-PSRemoting
```

### Access to shared drive in remote desktop
If you are connected to some machine through Remote Desktop and you want to access shared drive from Powershell, here is how to do that (you must add **\\\tsclient\\** to your path:
```powershell
ls \\tsclient\D\projects
```

## Powershell with Linux
Although it is not effortless, it is possilbe to make Powershell working with Linux. And it is a quite nice combo. Here we are going to focus on how to do something with Linux machine from Powershell remotely rather than how to install Powershell on Linxu - but this is also possible nowadays! In case if you are not very familiar with Linux commands, go to Appendix 1. Now, you need to open SSH on Linux, here is how to do it:
```bash
service ssh open #open/status/stop
```
And on the Powershell side you may need the passoword to remote Linux machine. It is nice to get the password using **Get-Credential** cmdlet, it is a bit safier than typing it directly in the code:
```powershell
$haslo = (Get-Credential -UserName user_name -Message "Password please!") `
		.GetNetworkCredential().Password
```

### Remote command exectution with plink
There is a tool called **plink** that allows to access the Linux shell from Powershell. Here is how to do it, *linux_pc* is the name of Linux machine:
```powershell
.\plink.exe linux_pc  
.\plink.exe -l user1 -pw $haslo -batch linux_pc ls -lsa 
```

### Copying files with pscp
Another tool, called **pscp** allows to exchange files between the Linux machine and Windows machine through Powershell. First to list the files and directories you may use the following command:
```powershell
.\pscp.exe -l user1 -pw $haslo -ls linux_pc:Desktop/files
```
**-ls** switch does the job. Now to copy files from the remote machine to the local one, or otherwise, use the followings commands:
```powershell
.\pscp.exe -l user1 -pw $haslo linux_pc:Desktop/file1 copy.txt	#copying FROM remote
.\pscp.exe -l user1 -pw $haslo file.txt linux_pc 		#copying TO remote
```

### Install Posh-SSH from PSGallery
```powershell
Get-Module -ListAvailable posh-ssh 
Find-Module -Name posh-ssh
Install-Module posh-ssh
Update-Module posh-ssh
ipmo posh-ssh
```

### Install Posh-SSH from GitHub
```powershell
Invoke-WebRequest ` #wget
    -uri https://github.com/darkoperator/Posh-SSH/archive/v1.7.2.zip `
    -outfile posh-ssh.zip
expand-archive -path .\posh-ssh.zip -destinationpath .
ipmo .\Posh-SSH-1.7.2\posh-ssh.psm1
```

### Execute remote commands in session
```powershelll
Get-Credential -username root -message "Password:"
$session = New-SSHSession -ComputerName linux_pc -Credential $crd -AcceptKey
Get-SSHSession
(Invoke-SSHCommand -Command "ls" $session).Output
```

### Copy files and directories
```powershell
Get-SCPFile -ComputerName pc -Credential $crd -RemoteFile file1 -LocalFile test1
Set-SCPFile -ComputerName pc -Credential $crd -LocalFile test1 -RemoteFile file1
```
Those commands have very simple scheme:
```
Get/Set-SCPFile 	-RemoteFile 	-LocalFile 
Get/Set-SCPFolder	-RemoteFolder	-LocalFolder 
```
And it is good to know that Posh-SSH uses the path from `[Environment]::CurrentDirectory` in its operations.

## Application scripting
Powershel is a great tool for application scripting and automatization. You can work with COM objects, that are provided by many applications, you can control some applications through their command lines parameters, and do other thigns! Look here:
```powershell
$ie = new-object -comObject internetExplorer.Application
$ie.adressBar = $false
$ie.toolBar = $false
$ie.visible = $true
```
This is a very baisc example of how to create COM object. As you can see it is very easy and you can work with it as with typical objects, access its properties and call its methods.

### Internet Explorer
Here is an example of how to use Internet Explorer COM object. As you can see you can explore HTML DOM tree from Powershell just like from Javascript! You can programmatically click on the buttons, type something in text inputs or retrieve some data from HTML.
```powershell
$ie.navigate("http://www.listentoyoutube.com/")
while($ie.Busy) { Start-Sleep -Milliseconds 100 }
$doc = $ie.Document
$urlInput = $doc.getElementsByTagName("input") | ? { $_.Name -eq "url" } 
$urlInput.Value = "https://www.youtube.com/watch?v=rM213vh295M"
$btn = $doc.getElementById("go-button")
$btn.click()
```

### Excel
It is a very common task for programmers in a company to do something with Excel, import, export, open, save, anything. You can do it in Powershell in more than one way. The most obvious one is to use Excel COM object of course. If you are interested in how to do it, please go [here](https://github.com/abik11/tips-tricks/blob/master/VBA.md). You may also use some external library like [this](http://epplus.codeplex.com/).

### Photoshop
Photoshop has its own scripting engine which in fact is a COM object. As default Photoshop allows to write scripts in Javascript, but since it provides access to the COM object, you can also use any functionality of Photoshop from Powershell. If you are interested in the API in greater detail, pleas read [here](http://www.adobe.com/devnet/photoshop/scripting.html). Here is how to create Photoshop COM object and get the list of currently open documents:
```powershell
$ps = New-Object -ComObject Photoshop.Application
$ps.Application.Documents | select Name
```
You can also get the list of layers in *img1* document, or access the second layer:
```powershell
$lays = ($ps.Application.Documents | ? { $_.name -eq "img1"  }).layers
$lay = $lays | select -index 2
```
Here you can see how to create new layer group and put there some layer:
```powershell
$gr1 = ($ps.Application.Documents | ? { $_.name -eq "img1" }).layerSets.add()
$gr1.Name = "gr1"
$lay.move($gr, 0)
```
In the **Move** method, the secod parameter has the following meaning:
* 0 - put layer in the group
* 1 - put layer in the beginning of the group
* 2 - put layer in the end of the group
* 3 - put layer before the group (or layer)
* 4 - put layer after the group (or layer)

You can of course do any kind of operations with layers, here you see how to do translation and rotation:
```powershell
$lay.translate(0.1, 4)	#x,y
$lay.rotate(30)			#deg
```

### Open Chrome with many tabs
Chrome.exe has a command line parameter **--new-window**. It will cause Chrome to open all the websites that it takes as separate tabs on browser start.
```powershell
.\chrome.exe --new-window memrise.com google.com onet.pl interia.pl wp.pl
```

### Download YouTube videos
There is a command line tool called **youtube-dl.exe** that allows you to download videos from YouTube. Here you can see how to get the list of formats that you can download for the given video: 
```powershell
.\youtube-dl.exe $link -F
```
And here is how to download the video:
```powershell
.\youtube-dl.exe $link -f webm -o "music\%(title)s.%(ext)s"
```
As you can see you have to specify the file format with the **-f** parameter.

### Download MP3 from YouTube
There is also another tool called **ffmpeg.exe** that allows to separate the sound of the video and save it as MP3 file. You can blend this tool with **youtube-dl.exe** and this way download sound from YouTube videos as MP3 file.
```powershell
.\youtube-dl.exe $link -o file.webm
.\ffmpeg.exe -i file.webm -acodec libmp3lame music.mp3
```

### Speech synthesizer
In Windows 7 there is a built-in speech synthesizer which can be controlled by COM object of course. Here is a simple example:
```powershell
(new-object -com sapi.spvoice).speak("Hello baby! How are you?")
```

### Work with Windows
One of the most useful COM objects for automatization is **Shell.Application**. It provides a lot of functionality for example asociated with Windows Explorer. A nice use case of this COM object can be seen in other tip - *Length of MP3 file*. Here you can see some simple but useful methods:
```powershell
$shell = new-object -COMObject Shell.Application
$shell.TileVertically()
$shell.TileHorizontally()
$shell.MinimizeAll()
$shell.UndoMinimizeALL()
```
**TileVertically** and **TileHorizontally** are quite useful, they try to adjust the size of all the open windows to make them fit the screen at once.

### Work much more with Windows - WinApi
Because of the fact that with Powershell you have access to the whole .Net library, you can also access **Windows API** with the **P/Invoke** mechanism and that gives you an unlimited power. Frankly speaking calling WinApi functions is difficult, much less intuitive than working with Powershell cmdlets and functions or even calling .Net methods. But it is doable and sometimes there is no other way to achieve some particular goal. Here you will see some very simple example of how to get the system datetime with WinApi function call, let's say it is some kind of WinApi *hello world* example:
```powershell
$typeCode = @"
public struct SYSTEMTIME 
{    
  public ushort wYear, wMonth, wDayOfWeek, wDay, wHour, wMinute, wSecond, wMilliseconds;
}

public class Win32Utils
{
  [System.Runtime.InteropServices.DllImport("Kernel32.dll")]
  public static extern void GetSystemTime(ref SYSTEMTIME sysTime);
}
"@

Add-Type -TypeDefinition $typeCode

[SYSTEMTIME]$time = new-object -type SYSTEMTIME
[Win32Utils]::GetSystemTime([ref]$time)
$time
```
Few things nice to notice - WinApi functions quite often require to provide arguments as structs - this make it a bit difficult to work with them because you have to know the structure of the required struct type. There is a nice web site that may help you: [pinvoke.net](https://www.pinvoke.net/index.aspx), it is a generally great source of information about WinApi for .Net, totally recommended! Another thing good to notice, that you will often encounter while working with WinApi in Powershell is the **[ref]** keyword put before an argument in function call. It is required because WinApi functions often use the given variable as a reference and not as a value and putting this keyword there guarantees that it will work like that.<br />
WinApi is extremely useful if you want to manipulate windows GUI and controls. Here is a simple example that runs notepad, puts some text in it and maximize it.
```powershell
$sig = '
  [DllImport("user32.dll", EntryPoint = "FindWindowEx")]public static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);
  [DllImport("User32.dll")]public static extern int SendMessage(IntPtr hWnd, int uMsg, int wParam, string lParam);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
'
Add-Type -MemberDefinition $sig -Name GUI -Namespace Win32

$process = Start-Process notepad -PassThru
$process.WaitForInputIdle()
$hwnd = $process.MainWindowHandle

[IntPtr]$child = [Win32.GUI]::FindWindowEx($hwnd, [IntPtr]::Zero, "Edit", $null)
[Win32.GUI]::SendMessage($child, 0x000C, 0, "Hello notepad from Powershell! :D")
[Win32.GUI]::ShowWindow($hwnd, 1) #show window
[Win32.GUI]::ShowWindow($hwnd, 3) #maximize window
#Other values you can use: 0 - hide, 2 - minimize (for more see MSDN)
```
Trying to avoid such low level calls is a good idea, most of things you will need to do is already ported to .Net or even to Powershell cmdlets, but if you are really sure that something cannot be done - it is surely time to work with WinApi.

### Send slack messages
If you use slack maybe you have heard about WebHooks. Thanks to WebHooks you can integrate external applications with slack. They can send messages and inform you about some actions, for example TFS can send you a message that a check-in was done. You can also create your own messages with Powershell thanks to **Invoke-WebRequest** cmdlet:
```powershell
$webHook = https://hooks.slack.com/services/aaa/bbb
$body = 'payload={"text":":slack: test"}'
invoke-webRequest $webHook -Method POST -Body $body
```
If the network from which you send messages is under proxy, to make this work, you may need to add some exceptions for the following addresses: *.slack.com *.slack-msgs.com *slack-files.com *slack-imgs.com *slack-edge.com *slack-core.com *slack-redir.net.

### IIS 
There is a nice command line tool available for IIS managment in `C:\Windows\System32\inetsrv`. You can get the list of IIS object, actions that you can make with site (or any other) object, the list of all sites:
```powershell
.\appcmd.exe 
.\appcmd.exe site /?
.\appcmd.exe list site
```
You can restart the given site
```powershell
.\appcmd.exe stop site /site.name:MyWeb
.\appcmd.exe start site /site.name:MyWeb
```

### Search controls in UIA
```powershell
$notepadProc = ps | ? { $_.MainWindowTitle -match 'Notatnik' }
$notepadWin = $notepadProc | Get-UiaWindow

$notepadWin | Get-UiaControl -AutomationId 15
$notepadWin | Get-UiaControl -ClassName 'Edit'
```

### Autologgin with UIA
```powershell
$txtboxes = Get-UiaWindow -Name "*UltraVNC Auth*" | Get-UiaTextbox
$txtboxes[0].Value = "abik"
$txtboxes[1].Value = "tajne_haslo"
(Get-UiaWindow -Name "*UltraVNC Auth*" | Get-UiaButton)[0].Invoke()
Hide-UiaCurrentHighlighter
```

## Powershell 5
Powershell 5 brought many nice improvments to the language. Here you can see only few of them.

### Using namespaces
```powershell
using module Server; #our own module Server.psm1
using namespace System.Data.SqlClient;
[SqlConnection]::new()
```

### Enum
```powershell
enum OSType {
    Unknown
    Windows
    Linux
}
[OSType] $myOS = 'Linux'
[OSType] $myOS2 = 'Windows'
```

### Classes and inheritance
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

### Get data from web service with default proxy
```powershell
$apiquery = 'http://samples.openweathermap.org/data/2.5/weather?...'
$proxy = [System.Net.WebProxy]::DefaultProxy
$cred = [System.Net.CredentialCache]::DefaultWebProxy
$proxy.Credentials = $cred
$web = new-object System.Net.WebClient
$web.Proxy = $proxy
$result = $web.DownloadString($apiquery) | ConvertFrom-Json
#ConvertTo-Json
```

## Pester and modules
Pester is the most popular Powershell unit test and mock framework. It is so popular that it became the part of Powershell 5 by default. It is similar to Javascript Mocha and Chai frameworks. Tests written with Pester have rather Behaviour-Driven Development style and tend to be more human-readable.<br />
Unit testing is a great mix with powershell modules which allows to group functions, variables into packages that can be imported by a script or into Powershell console. Modules are easily testable and encourage a better approach for writing Powershell code.

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

## Appendix A - Linux commands
Here you will find just some very basic review of Linux commands. If you are interested in more detailed stuff, go [here](https://www.computerhope.com/unix.htm). And if you have no Linux at all, this is a [nice distribution](https://tails.boum.org/).

### Files
```bash
touch file1 			#creates new file
echo "hello world" > file1	#puts some conent to file1
mkdir myDirectory		#creates directory
cp file1 myDirectory		#copies file1 to myDirectory
mv myDirectory/file1 myDirectory/file2
chmod 655 file1				
chmod u+x,o-r file2
```

###  Searching files
Simple find, searching in the current directory.
```bash
find -name myfile.txt
```
This returns the path from $PATH variable to the given binary
```bash
which ls 
```
Searching file with the given name
```bash
whereis aircrack-ng
```
Searching all the paths that contain the given name, basing on the the files database managed by the system - it doesn't work for the newest files because they may not me be in the database yet.
```bash
locate aircrack-ng
```

### Processes
```bash
ps -aux		#show all processes
top		#show most processor-consuming tasks
kill 102 	#kill process with the given pid
nice -n -5 top	#spawn the process with adjusted nicenness (priority)
renice 102 -15	#increase the process priority
ps & 		#run the task in background
```

### System variables
```bash
set 
echo $HISTSIZE
HISTSIZE=0 #no space!!!
export HISTSIZE
PATH=$PATH:/new/soft
```

### Users
```bash
useradd -d /home/topsecretdata abik
useradd -G admins,webdev abik
useradd -M abik #user without home directory
passwd abik
id abik #user info
cat /etc/passwd | grep abik #user info
deluser --remove-home abik
su - abik #login as abik
```

### Text files
```bash
nl file1 							#displays file with line numeration
head -30 file1						#displays first 30 lines
cat file1 | grep abik 				#search for a string 'abik' in file1
sed s/abik/ABIK/ file1 > file1 		#replaces first occurance of 'abik' to 'ABIK'
sed s/abik/ABIK/g file1 > file1 	#g - global, all occurances
sed s/abik/ABIK/3 file1 > file1 	#third occurance
```

### Network
```bash
ifconfig ethX NODE_IP_ADDRESS netmask NETWORK_MASK up

### ruter
sysctl -w net.ipv4.ip_forward=1
route add -net NETWORK_IP_ADDRESS netmask NETWORK_MASK dev ethX #add/del

### host
route add default gw RUTER_IP_ADDRESS ethX
```

### Netcat
```bash
### recieve file 
nc -l -p 5500 > outfile

### sending
nc -w3 DESTINATION_IP 5500 < infile

### scanning 
nc -v -n -z -w1 ADDRESS_IP STARTPORT-ENDPORT

### banner grabbing: 
echo "" | nc -v -n -z -w1 ADDRESS_IP STARTPORT-ENDPORT

### backdoor: 
nc -l -p 5500 -e /bin/bash

### mini serwer: 
while true; do 
	cat index.html | nc -l -p 5500 | head --bytes 2000 >>req.log
	date >>req.log
	done
```

## Appendix B - Serial port
It may not be the most common solution to handle serial port through Powershell, but that doesn't mean it cannot be done. And here are some tips how to make it. First, let's look get currently available port names: 
```powershell
[System.IO.Ports.SerialPort]::GetPortNames() 
```
It will for example return `COM4`. That means, that we can use this serial port further. Here is an example configuration of how to open a given port. The configuration may be different, depending on what is connected to the port: 
```powershell
$port = new-object System.IO.Ports.SerialPort
$port.PortName = 'COM1'
$port.BaudRate = 9600
$port.DataBits = 8
$port.Parity = 0
$port.StopBits = 1
$port.Handshake = 0
$port.ReadTimeout = 2000
$port.DiscardNull = $True
$port.Open()
```
Let's assume that a barcode scanner is connected to the `COM1` and we scanned a text `MAP0`. We can read each byte separately (we could also use **ReadByte** instead of **ReadChar** here):
```powershell
$port.ReadChar() #2 STX (start of text)
$port.ReadChar() #77 M
$port.ReadChar() #65 A
$port.ReadChar() #80 P
$port.ReadChar() #48 0
$port.ReadChar() #3 ETX (end of text)
```
Or we can read the whole buffer at once:
```powershell
$port.ReadExisting() # ☻MAP0♥
```
When the job is done it is good to clear the read buffer, close the stream and dispose the **SerialPort** object. If serial port will become blocked we can make the same operation - close it and open again:
```powershell
$port.DiscardReadBuffer()	# Clear read buffer

$port.BaseStream.Close()	# When serial port gets blocked
$port.Dispose() 			# When serial port gets blocked
```
If you are familiar with C# and you are interested in serious operations with serial ports you may need to handle an event - **DataRecieved**.
```csharp
serialPort.DataReceived += methodDelegate;	//methodDelegate - SerialDataReceivedEventHandler
```
For more detailed information go [here](https://msdn.microsoft.com/pl-pl/library/system.io.ports.serialport(v=vs.110).aspx) or [here](http://www.sparxeng.com/blog/software/must-use-net-system-io-ports-serialport)

## Appendix C - Colors in .Net
In general colors in .Net are represented by **Color** class form **System.Drawing** namespace. They consist of four 8 bit numbers representing transparency (alpha), red, green and blue and the whole color can be represented simply by a 32 bit integer value. Once I encountered a system that was saving colors of some objects as such 32 bit integer value, for example *-5658199*. This is some kind of grey and I was asked to change it to lighter grey. I didn't know what is this number and how to understand it, how to convert it to hex notation or ARGB. Powershell helped me a lot to understand it and to achieve my goal. I tried to put this mysterious number as an argument of **FromArgb** static method of **Color** class and it return an object of type **Color** with all the color details.
```powershell
Add-Type -AssemblyName System.Drawing
$color = [System.Drawing.Color]::FromArgb(-5658199)
$color.Name
```
This integer is nothing more than just color written as ARGB in decimal notation instead of hexadecimal, the one that we are all used to when it comes to dealing with colors! You can see the hex notation accessing **Name** property of color object. Building a new color is quite easy also if you know red, green and blue elements. You just have to use **ToArgb** method to get the color representation as decimal integer:
```powershell
$color = [System.Drawing.Color]::FromArgb(216, 216, 216)
$color.ToArgb()
```
That's all!

## Appendix D - Wmic and netsh
There are two extremely powerfull commands in Windows. Actually there are much more, but here I would like to say a word or two about **wmic** and **netsh**. The first one is WMI (Windows Management Instrumentation) command line tool that allows you to get almost any kind of information about software and hardware and manage the system. The second command is intended to configure and manage networks through command line. Both tools are designed for someting different but you can sometimes achieve the same goal using them. It is also good to know that they both can work in interactive (shell) mode but for scripting it is much better to use them simply as commands putting all the required parameters.

### Netsh
With this command you can easily get a lot of information about networks and interfaces in your system. It allows you to manage and configure network interfaces and much more! For example with the following few commands you can see all the enabled network interfaces, their addresses and configuration. In the last command only the configuration of the selected interface will be shown.
```
netsh interface ipv4 show interface
netsh interface ipv4 show addresses
netsh interface ipv4 show config
netsh interface ipv4 show config 12
```
It is good to know how to get interface index number because it may be used to configure the specified interface. It is easier to use index than name (`name='Local connection'`) because depending on your language, tha name can contain some diacritical marks which may not be interpreted by the command line.<br />
Here you can see how to set static IP address, net mask (`/22`), default gateway and primary and secondary DNS server:
```
netsh interface ipv4 set address 12 static 100.110.80.125 255.255.252.0 100.110.84.1
netsh interface ipv4 set dnsservers 12 static 100.110.86.62
netsh interface ipv4 add dnsserver 12 100.110.86.61 index=2
```
All the settings are applied to the interface of index 12. If you want to get the address and other settings automatically from DHCP you should use the following commands:
```
netsh interface ipv4 set address 12 source=dhcp
netsh interface ipv4 set dnsservers 12 source=dhcp
```
It is also possible to enable and disable (turn on and off) network interface cards (NIC) with **netsh**, this is how you do it:
```
netsh interface show interface
netsh interface set interface name="Local connection" admin=disabled
netsh interface set interface name="Local connection" admin=enabled 
```
A disadvantage of this command is that you have to specify the name of the NIC, you cannot use its index. To overcome it you have to use **wmic**.

### Wlan
**Netsh** can be used for WLAN management. For example you can see all the configured WLAN profiles and connect your PC with the given profile:
```
netsh wlan show profiles
netsh wlan connect name="myWifi"
```

### Much more
There are many other things you can do with **netsh**. If you will type `netsh /?` in cmd, you will see all the possible contexts in which you can use this command. Here is just one more example which shows all the firewall rules. Of course with **netsh** you can add and modify such rules:
```
netsh advfirewall firewall show rule name=all
```

### WMIC
Powershell has it own **Get-WmiObject** cmdlet to handle WMI but **wmic** can do the same thing and can be also run from cmd, not only from Powershell. This command uses heavily aliases for WMI classes, so for example we can use the alias `DESKTOPMONITOR` instead of the class name `Win32_DesktopMonitor`, for example the two following lines do the same thing:
```powershell
wmic desktopmonitor
wmic path win32_desktopMonitor
```
To get the list of available aliases with their descriptions you can execute the following command:
```powershell
wmic /?
```
If you are interested about the details of a specific alias you can use this:
```powershell
wmic alias desktopmonitor
```
You can use **wmic** to query for a specific information with **get** and **where** keywords, see an example:
```powershell
wmic desktopmonitor where availability=3 get name,screenHeight,screenWidth
```
Be careful, there should not be any space between the fields names in **get** clause.

### Enable and disable NICs
Many things that can be done with **netsh** can be also done with **wmic**, for example enabling and disabling network interface cards. Use the following command to list all NICs:
```
wmic nic get name,index,interfaceIndex,netConnectionID
```
Remember, index field is the *physical* numer of network card and interface index is the *logical* number of the network interface (you use this number in `netsh interface ipv4` context). It maybe useful to display the NIC information along with the interface.<br/> 
With **wmic** you can query WMI to find the NIC you want to enable or disable in many ways:
```
wmic path win32_networkadapter where "NetconnectionID like '%wireless%' and not ProductName like '%Virtual%'" get name,index call disable
wmic path win32_networkadapter where index=7 call enable
```

### NIC configuration
It is also easy to get configuration details (the same information as `netsh interface ipv4 show config` shows) with `Win32_NetworkAdapterConfiguration` class. See an example:
```
wmic nicconfig where "interfaceIndex=12" get DHCPEnabled,IPAddress,IPSubnet,DefaultIPGateway,DNSServerSearchOrder
```
Of course it is possible to change the configuration with **wmic**:
```
wmic nicconfig where index=7 call SetDNSServerSearchOrder ('8.8.8.8','8.8.4.4')
wmic nicconfig where index=7 call EnableStatic ('100.110.16.20'),('255.255.255.0')
wmic nicconfig where index=7 call EnableDHCP
```
To know more about the functions you can call for `nicconfig` type this command (it works for other classes too):
```
wmic nicconfig call /?
```

## Useful links

#### General Powershell stuff
[PoshGUI](https://poshgui.com/)<br />
[Simple-talk](https://www.simple-talk.com/)<br />
[Precision Computing](http://www.leeholmes.com/blog/)<br />
[Exploit Monday](http://www.exploit-monday.com/)<br />
[Lazy Admin](http://www.lazywinadmin.com/)<br />
[Mad With Powershell](http://www.madwithpowershell.com/)<br />
[Hey, Scripting Guy](https://blogs.technet.microsoft.com/heyscriptingguy/)<br />

#### Pipelining
[Implementing pipelines](https://learn-powershell.net/2013/05/07/tips-on-implementing-pipeline-support/)

#### Linq with Powershell
[Linq with Powershell](https://www.simple-talk.com/dotnet/net-framework/high-performance-powershell-linq)

#### WinForms with Powershell
[Building Forms with Powershell](https://blogs.technet.microsoft.com/stephap/2012/04/23/building-forms-with-powershell-part-1-the-form/)<br />

#### UIAutomation
[UIAutomation](https://uiautomation.codeplex.com/documentation)<br />
[UIAutomation](https://softwaretestingusingpowershell.wordpress.com/category/ui-automation/)<br />

#### Modules
[Module Manifest](https://msdn.microsoft.com/en-us/library/dd878337(v=vs.85).aspx)<br />
[Powershell Module](http://joshua.poehls.me/powershell-script-module-boilerplate/)<br />

#### Pester
[Pester](https://www.red-gate.com/simple-talk/sysadmin/powershell/practical-powershell-unit-testing-getting-started/)<br />
[Pester](https://github.com/pester/Pester/wiki)<br />
