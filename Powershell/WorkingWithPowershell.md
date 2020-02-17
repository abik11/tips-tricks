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

### Unblock scripts
When you download PowerShell files from the Internet in Windows 10 they are *blocked* by default and everytime you will try to import them or run them you will see a *Security warning*. If you don't want to see this warning, you have to unblock them. You can: ->right click on a file ->Properties ->Unblock, or let's assume that you have a lot of scripts in your *Downloads* directory and you want to unblock them:
```powershell
ls "$env:userprofile\Downloads\" | unblock-file
```

### Powershell providers
There is something called **Powershell providers**, which is a program that encapsulates some data with access logic, like read, write, list and allows Powershell to use it as it was a file system drive. For example **FileSystem** provider brings you the **C:**, **D:** and other drives that are mounted on your machine. **Registry** provider brings you **HKCU** and **HKLM** drives so you can explore Windows Registry with commands like ls, cd, pwd and so on! You can list all the Powershell providers and Powershell drives with **Get-PSProvider** and **Get-PSDrive** commands. Here you can see some little examples:
```powershell
get-PSProvider
get-PSDrive
cd C:\
cd HKLM:
cd HKCU:
cd variable:	#Powershell variables
cd Env:		#System variables
```
You can use existing providers to create a new **PSDrive** which can optimize your work:
```powershell
New-PSDrive -name Desktop -PSProvider FileSystem -root C:\users\j.smith\Desktop
cd desktop:
```
PSDrive created like this will exist only in the current Powershell session.<br />
If you *got lost* in the provider you are using or simply you need to know the exact path of some item of the provider, you can check provider's path easily:
```powershell
(Get-Location).ProviderPath
(Get-Location -PSProvider FileSystem).ProviderPath #you can specify provider type explicitly
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
In method 1 we use PSProvider (`Env:`) and **new-item** cmdlet to add new variable. With the same method we can add files, directories, registry keys and many more, depending on your PSProviders!

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

### Debugging
Powershell allows you to set a breakpoint on given command or variable, for example:
```powershell
set-psbreakpoint -command get-process
set-psbreakpoint -variable processData
```
The two following breakpoints will cause script's execution to stop every time when `get-process` command will be call or `$processData` variable will be set or read. When the execution is stopped, you can use a bunch of commands to control the debugging process, like: `stepInto` (**s**), `stepOver` (**v**), `stepOut` (**o**) and `list` (**l**) - to list the source code of current script. Type **h** to get help.<br />
You can use `Get-PSBreakpoint` to list all breakpoints and `Remove-PSBreakpoint` to remove them. Here you can see an example that removes the first breakpoint on the list:
```powershell
get-psbreakpoint 0 | remove-psbreakpoint
```
