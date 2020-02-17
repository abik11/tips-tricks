## Task automation
Powershel is a great tool for application scripting, automation and retrieving information from many different sources. You can work with COM objects, that are provided by many applications, you can control some applications through their command lines parameters, manage system components with [WMI](https://docs.microsoft.com/pl-pl/windows/desktop/WmiSdk/wmi-tasks-for-scripts-and-applications), modify registry and Event Log and do other thigns!

### Create a COM Object
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

### Speech synthesizer
In Windows 7 there is a built-in speech synthesizer which can be controlled by COM object of course. Here is a simple example:
```powershell
(new-object -com sapi.spvoice).speak("Hello baby! How are you?")
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

### Visual Studio 2012 project reference list
This is also a nice one! Here the **.csproj** XML file is parsed and is searched for the **Reference** nodes. A nice thing to take a glance is that we have to add the namespace used in this file to be able to run XPath query.
```powershell
[xml]$project = gc "MyProject.csproj"
$nm = New-Object -TypeName System.Xml.XmlNamespaceManager -ArgumentList $Project.NameTable
$nm.AddNamespace('x', 'http://schemas.microsoft.com/developer/msbuild/2003')
$nodes = $Project.SelectNodes('/x:Project/x:ItemGroup/x:Reference', $nm) 
$nodes | % { ($_.Include -split ",")[0] }
```

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
$iis = "$env:windir\System32\inetsrv\appcmd.exe"
& $iis site /?
& $iis list site
```
You can restart the given site
```powershell
& $iis stop site /site.name:MyWeb
& $iis start site /site.name:MyWeb
```

### Add a certificate for IIS HTTPS connections
If you've installed WebAdministration module you can easily check what certificates are applied:
```powershell
ipmo webadministration
ls iis:\sslbindings | ? { $_.sites.value -eq "Your Site" }
```
Also you can check it with `netsh` command:
```powershell
netsh http show sslcert ipport=0.0.0.0:443
```
To add a certificate you have to know its hash and id of the application to which the certificate will be assigned:
```powershell
$IISAppId = "{4dc3e181-e14b-4a21-b022-59fc669b0914}"
$certhash = Get-ChildItem Cert:\LocalMachine\My\ `
    | Where-Object { $_.Subject -eq 'CN=localhost' } `
    | Select-Object -ExpandProperty Thumbprint
```
Finally you can add the certificate:
```powershell
netsh http add sslcert ipport=0.0.0.0:443 certhash=$certhash appid=$IISAppId
```
or delete it if necessary:
```powershell
netsh http delete sslcert ipport=0.0.0.0:443
```

### Work with Windows
One of the most useful COM objects for automatization is **Shell.Application**. It provides a lot of functionality for example asociated with Windows Explorer. A nice use case of this COM object can be seen in other tip - [Length of MP3 file](#length-of-mp3-file). Here you can see some simple but useful methods:
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
WinApi is extremely useful if you want to manipulate windows GUI and controls. Here is a simple example that runs notepad, puts some text in it and maximize it. Notice that this time WinApi functions are imported slightly different way, it is up to you which way do you prefer.
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

### Lock screen, restart and turn off the system
To lock a screen you have to run **LockWorkStation** function of **user32.dll**. You can import that function through pinvoke, as shown in some previous examples, but there is also another, much simpler way:
```powershell
rundll32.exe user32.dll,LockWorkStation
```
If you want to log off the system you have few different ways:
```powershell
logoff.exe
shutdown.exe -l
(Get-WmiObject -Class Win32_OperatingSystem).Win32Shutdown(0)
```
With **Win32Shutdown** you can also perform other operations: 
* 0 - log off, 4 - forced log off (0+4)
* 1 - shutdown, 5 - forced shutdown (1+4)
* 2 - restart, 6 - forced restart (2+4)
* 8 - power off, 12 - forced power off

### When the PC was turn off
It is a simple search in Event Log. All we have to do is to find all the logs with **EventId** equal to **1074** which corresponds to the shutdown action. We choose `USER32` as a source because in **user32.dll** there is a function that shutdowns the system.
```powershell
get-eventlog -logName system -source "USER32" | ? { $_.EventId -eq 1074 }| ft -wrap
```

### Uninstall applications
With WMI you can uninstall some of the applications.
```powershell
(Get-WmiObject -Class Win32_Product -Filter "Name='AppName'").Uninstall()
```

### Remove Appx Packages
In Windows 10 there is something as Appx Package. As default some stuff is installed like Zune, Spotify and others. You can list it, filter and easily delete, see here:
```powershell
Get-AppxPackage *spotify* | remove-AppxPackage
```

### How to automatically answer Y/N questions when prompted?
A lot of command line applications ask *questions* to make sure that a user really wants to execute given operation or other things and it may be difficult to automate such application and give them answer from Powershell. You can try to handle it in the following way:
```powershell
echo 'n' | git clean -xfd
```
which will automatically send `n` (no) as answer for every question that will be raised.
