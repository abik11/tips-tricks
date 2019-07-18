# Tips for beginners

* [Windows](#windows)
* [Devices and networks](#devices-and-networks)
* [IIS](#iis)
* [Visual Studio](#visual-studio)
* [TFS and other version control systems](#tfs-and-other-version-control-systems)
* [VS Code](#vs-code)
* [Useful links](#useful-links)

## Windows

### Windows shortcuts
* `CTRL + ALT + Arrow` - rotate screen
* `CTRL + SHIFT + ESC` - task manager
* `win + X` - Quick Link Menu (Windows 10)
* `win + I` - Settings App (Windows 10)
* `win + D` - show desktop
* `win + M` - minimize all
* `win + E` - open explorer
* `win + P` - projector pane
* `win + R` - Run dialog box

### Run commands
* `msconfig` - autorun settings and tools
* `compmgmt.msc` - event log, tasks, users, services and devices
* `control.exe` - control panel
* `OptionalFeatures`- turn Windows features on or off
* `sysdm.cpl` - system variables, remote settings
* `ncpa.cpl` - network settings
* `diskmgmt.msc` - disk management (resize, add new)
* `MsInfo32.exe` - system info
* `winver` - system version
* `mstsc` - Remote Desktop Connection
* `regedit` - registry editor 
* `gpedit.msc`  - local group policy
* `cmd`  - command line
* `shell:startup` - startup directory of currently logged user
* `shell:common startup` - startup directory for all users
* `shell:start menu` - start menu directory of currently logged user
* `shell:common start menu` - start menu directory for all users

### Minimize all windows despite the current one
You can click on window and hold it and try to shake it with mouse. All other open windows should be minimized and only the one that you shaked should remain open. Cooool.

### Admin Panel
Create a directory and call it like this: `SuperAdmin.{ED7BA470-8E54-465E-825C-99712043E01C} ` and it will become an Admin Panel with many nice tools.

### Default virus
To test antivirus software copy and paste this: `X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*` into text file and save it. Antivirus should immediately recognize this text file as a virus.

### Set default applications
->Settings ->System ->Default Applications

### Check if exe file is x86 or x64
Open the exe file as text and search for the first `PE` string appearance. If you will find ` PE  L  ` it means it is x86 executable and if you will find ` PE  d† ` it means it is x64 executable.

### Change hostname
To check hostname run this command in cmd: `hostname`. To change hostname go to: ->Control Panel ->System ->Change settings (net to hostname) ->Change ->Computer name (put new name) ->OK

### Manage local users
->`CTRL + R` ->`compmgmt.msc` ->Computer Management ->Local Users and Groups

##### Add new user
->Right click empty space ->New User...

##### Add user to a group
->Right click on user ->Properties ->Member Of ->Add ->Advanced ->Find ->Choose group

### Remote Desktop Connection

##### Connect local disk to Remote Desktop
->Start ->Remote Desktop Connection ->Options ->Local Resources ->More ->Choose disk ->Connect

##### Clean credentials for Remote Desktop
You can save credential for Remote Desktop Connection if you will go to ->Options ->Allow me to save credentials. This is a nice option, but if the password of the user that use for login will change you will have to edit or delete this credentials. To do this just click the **edit** or **delete** link in Remote Desktop Connection on the bottom.

#### Reset password in Active Directory
* From GUI:<br />
->Start ->Administrative Tools ->Active Directory Users and Computers ->Select your domain ->Right click on some folder ->Find ->Right click on the found user ->Reser Password
* From Powershell:<br />
```powershell
dsquery user -name *Smith*
dsmod user "CN=John Smith,OU=IT Group,OU=Corp_Users,DC=EvilCorp,DC=Corp" `
-pwd abcd1234 -mustchpwd yes -disabled no
```
If you want to learn more about Powershell go [here](https://github.com/abik11/tips-tricks/blob/master/Powershell.md).

### Personalized Management Console MMC
->`CTRL + R` ->`mmc` ->File ->Add or Remove Snap-ins

### Power efficiency diagnostics
->`CTRL + R` ->`cmd` ->`powercfg /energy /output d:\report.html`<br />
By the way, **powercfg** has few other nice options. For example you can list all the devices that can wake your pc with the following command:
```
powercfg -devicequery wake_armed
```

### Permamently delete a file
There is a shortcut `SHIFT + DEL` that allows you to delete a file without putting it to Recycle Bin. But even tough you can recover files from disk. If you want to delete a file and be sure that it won't be able to recover this file you can use **BleachBit**. After installation it adds a new option in context menu - **Shred with BleachBit** which deletes a file or a directory and overwrites the disk space where it was stored.

### Clean disk from scrap
->Right click on a disk ->Properties ->Disk Cleanup, or:<br />
->Start ->Programs ->Accessories ->System Tools ->Disk Cleanup<br />
You can also delete all the files inside of these directories:
* `C:\Windows\Logs\CBS`
* `C:\Windows\Temp`

You can also use **BleachBit** to remove some unnecessary files like history files or logs.

### Remove useless stuff in Windows 10
There are quite many things enabled and installed by default in Windows 10 that you might want to get rid off. Also if you use your computer for a long time you can have many unnecessary application installed, you can use [**Revo Uninstaller**](https://www.revouninstaller.com/revo_uninstaller_free_download.html) or [**CCleaner**](https://www.ccleaner.com/ccleaner) instead of built-in program to remove programs. **Java Uninstall tool** can be very usefull too.

##### Turn of Internet Explorer and Media player
->`Win + X` ->Programs and Features ->Turn Windows features on or off ->Uncheck: Internet Explorer 11, Media Features\Windows Media Players

##### Turn off ads from start menu
->Settings ->Personalization ->Start ->Occasionally show suggestions in Start

##### Turn off search from taskbar
->Right click on taskbar ->Search ->Hidden

##### Turn off lock screen
->regedit ->`HKEY_LOCAL_MACHINE` ->`SOFTWARE` ->`Policies` ->`Microsoft` ->Right click on `Windows` ->New ->Key ->Name: `PERSONALIZATION`<br />
->Right click on `PERSONALIZATION` ->New ->DWORD Value (32 bit) ->`NoLockScreen = 1`

##### Turn off standard applications
Run this in Powershell:
```powershell
get-appxPackage *photo* | remove-appxPackage
```
Other packages you might want to delete: `*camera*, *zune*, *communi*, *people*, *soundrec*, *3d*, *phone*, *solit*, *bing*`. You can also use **10AppsManager** or **CCleaner**.

##### Turn off apps in the background
->Settings ->Privacy ->Background apps

### Add My Computer on the desktop in Windows 10
->Right click on the desktop ->Personalize ->Themes ->Desktop icon settings ->Check **Computer**

### Turn off text scaling in Windows 10
->Right click on the desktop ->Display settings ->Change the size of text, apps, and other items

### Repair Windows 10 files
Open command line and use the following commands to first check if the system image file is correct, if not, what are the problems and finally to repair the image:
```
dism.exe /Online /Cleanup-image /CheckHealth
dism.exe /Online /Cleanup-image /ScanHealth
dism.exe /Online /Cleanup-image /Restorehealth
```
Windows Update service is used to repair system image file. If this service is corrupted, then you will have to download new image file manualy. You can use **Windows 10 Media Creation Tool** (official Microsoft tool) or **Windows ISO Downloader** (not official) - remember to choose the correct version and language. After the image is downloaded you have to unzip or mount the iso file and get **install.wim** file from **sources** directory. Then you can use the following command:
```
dism.exe /Online /Cleanup-image /Restorehealth /Source:c:\download\install.wim
```
When the system image file is correct you can repair your system files:
```
sfc /scannow
```

### Prepair bootable pendrive for Windows reinstallation
It is a very good idea to keep a bootable pendrive with Windows system image, ready to reinstall the system if something goes really wrong. It is quite easy to make it on your own, follow the steps:
* Download Windows ISO file - to make it you can use **Windows 10 Media Creation Tools** or **Windows ISO Downloader**. Be sure that you download the correct version of the ISO file (correct version, language, etc).
* Use **Rufus** to put the Windows ISO file on pendrive and to make it bootable. Be careful - after the operation, you will not be able to use the pendrive as an external storage device anymore. Set file system to NTFS and choose the Windows ISO file, leave other options as default.
* **Remember!** Before any reinstallation, write down your Windows product key. To make it, the easiest way is to use **NirSoft ProduKey**.
* After the pendrive is ready you can turn off your PC (hold SHIFT and click Turn Off on Windows 10) and press F12 (or other key depending on your PC model) while it is rebooting to get into the **Boot Menu**. In the Boot Menu you will be able to choose the PC to boot from your bootable pendrive and this way the process of installation of the system will begin.<br />
If you cannot get into Boot Menu, you can get into BIOS (press F2 or other key depending on your PC model) and change the precedence of bootable devices, putting your pendrive at the first place.<br />
[See the list](https://www.desertcrystal.com/bootkeys) to know what are the bootkeys for your pc.

### AutoHotkey - define your own key shortcuts
There is a really nice and easy scripting language called **AutoHotkey** also known as **AHK** which allows you to easily create new key shortcus (hotkeys) and automize your work. Here is a little example:
```ahk
!k::
WinGetActiveTitle, CurrentTitle
If InStr(CurrentTitle, "Visual Studio")
    SendInput, Hello World{!}
return

#IfWinActive ahk_class Notepad
::wpf::Windows Presentation Foundation
return
```
In the above script there is defined a hotkey of `ALT + K` (`!k`). When you will press `ALT + K`, it will get the current window title and if it will find the string `Visual Studio` in the title, it will input some text.<br />
There is also defined a hotstring for `wpf`. Everytime you will type the `wpf` string, it will be expanded to `Windows Presentation Foundation`, but it will work only in **Notepad** because of the **#IfWinActive** directive before the hotstring.<br />
The nice feature of AHK is that if you will copy the **AutoHotkey.exe** into the folder where you have your AHK script and you will change the name of the .exe file to be the same as the name of the AHK script, then if you will double click on the .exe file it will automatically run your script.<br />
You can use `#` for Windows key, `^` for CTRL, `!` for ALT, `+` for SHIFT and other keys like `Numpad0`, `Numpad1` etc. You can also join keys with `&`, for example `LCtrl & Numpad1`. AHK allows you to automize a lot of things, go to the [documentation](https://autohotkey.com/docs/AutoHotkey.htm) to learn more.

### Run application or script on startup
Press `Win + R` and type `shell:startup` or go to `%appdata%\Microsoft\Windows\Start Menu\Programs\Startup` and copy into that directory anything you want to run on system's startup. If you want to run some application you must create a shortcut to that application rather than copying an exe file.<br />
Of course, the same thing can be also achieved with **Task Scheduler**.

### Notes on the desktop
There are plenty of applications that allow to write and save quickly some notes and keep them on the screen or desktop. It is very useful at work. Here are some propositions:
* [Minimalist Notepad](http://win7gadgets.com/tools-utillities/minimalist_notepad.html) - Windows gadget
* [Stickies](http://www.zhornsoftware.co.uk/stickies/) - Windows application

### Create a RAM disk
If your PC has a lot of RAM memory which is not used, you can use this memory to create an extremely fast **RAM disk**. RAM disk is a part of RAM memory which simulates a traditional drive (thanks to some kind of software). Such disk is a lot faster than both HDD and SSD drives, its speed is totally uncomparable with any kind of disk because of the RAM memory is very fast. The only drawback of RAM disk is that all its contest will be deleted with every restart of your PC. But it is possible to save RAM disk to .img file and mount it after reboot. All in all, it is an interesting solution.<br />
There is a very easy to use application called **SoftPerfect RAM Disk** that allows to create and manage RAM disks. You just have to click the plus icon, select RAM disk size (2048 Mb for example), drive letter (R: for example) and NTFS as file system and that's it. You can see in Task Manager (in Performance tab) that RAM usage changed after you have created a RAM disk. You can for example copy some files that you currently edit to the RAM disk, it should speed up your work a lot.

## Devices and networks

### Wireshark filters
To be able to quickly find what you need in Wireshark it is crucial to use filter, here is a nice example: ` (tcp.dstport == 8080 || tcp.srcport == 8080) && (http.request.method == "CONNECT" || http.response.code == 407 || http.response.code == 200)`

### 5Ghz WiFi adapter can't detect 5GHz networks
If you have a WiFi adapter which should be able to connect to 5GHz networks but it cannot even detect them, the first solution you should try is to:
-> Go to **Device Manager** (you can make it through CTRL + R and type: `compmgmt.msc`) ->**Network Adapters** ->Choose your adapter from the list ->Right click it and choose **Properties** ->Go to **Advanced** tab ->Select **Wireless Mode** ->Set it to **IEEE 802.11a/n/ac**

### Installed Wi-Fi printer stopped working
First check the printer's IP adress and try to ping it from your PC. If you cannot ping it, then make sure that printer is in the correct network and that your firewall allows you to ping other devices.<br />
If you can ping the printer and it still doesn't work, go to: ->Control Panel ->Printers and Devices ->Right click your printer ->Properties ->Ports ->Standard TCP/IP port ->Configure port ->Make sure that correct IP address is set<br />
If the printer works but scanner does not, go to: ->Control Panel ->Type `scanner` in search box ->Show scanners and photo cameras ->Select your printer/scanner ->Properties ->Network Settings ->Make sure that correct IP address is set

### Turn off and on Elan touchpad when mouse is plugged or not
Elan touchpads have a nice feature that they can automatically turn off when a USB mouse is plugged in and automatically turn on when a mouse is removed. By default this feature is turned off. You must find the following key in the Windows Registry: `HKEY_CURRENT_USER/Software/Elantech/Othersetting` and set the following value: `DisableWhenDetectUSBMouse` to `1`.<br />
If there is no such key or value, try to update the touchpad's drivers.

## IIS
**Internet Information Services** is a web server developed by Microsoft. It is very popular, especially for hosting .Net applications and can be easily installed on Windows Server.

### Install IIS in Windows Server
->Server Manager ->Dashboard ->Add roles and features ->Features ->.Net Framework, IIS Hostable Web Core, Windows Process Activation Service

### New site in IIS 
->Choose your server ->Right click on Sites ->Add Web Site ->Set: Site name, Application pool, Physical path, Port<br />
->Left click on created page ->Default Document ->Add new or use defaults (for example: publish.htm)

### Web application is running slow after being idle for some time
Try the following settings as a solution for the problem.<br />
->Application Pools ->Right click on selected App Pool ->Advanced Settings:
* **General\Start Mode** = AlwaysRunning
* **Process Mode\Idle Time-out** = 0

### Publish Android APK
Create a new site and put in its directory the apk file. Modify the Web.config file to look like this:
```xml
<?xml version="1.0" encoding="ASCII"?>
<configuration>
    <system.webServer>
        <defaultDocument>
            <files>
                <add value="yourApp.mobile.debug.apk" />
            </files>
        </defaultDocument>
        <directoryBrowse enabled="false" />
        <staticContent>
            <remove fileExtension=".apk" />
            <mimeMap fileExtension=".apk" mimeType="application/vnd.android.package-archive" />
        </staticContent>
    </system.webServer>
</configuration>
```

## Visual Studio
Visual Studio is an amazing IDE with a plenty of tools, options and configurations that may confuse many users. Moreover it is good to learn some tricks that will make your life as a developer much easier. Here you will find some tips and advices that may be useful. Most of the thing you will see here is valid for Visual Studio 2017, but many tips should also work in Visua Studio 2015.

### Keyboard shortcuts
Visual Studio has a lot of nice keyboard shortcuts that can speed up your work, instead of clickling all the time you can do many things with just two or three keys. Here are only some of the most useful shortcuts.

##### Comments
* Comment selected lines of code<br />`CTRL + K, CTRL + C`
* Uncomment selected lines of code<br />`CTRL + K, CTRL + U`

##### Debbugging
* Start debugging<br />`F5`
* Add breakpoint<br />`F9`
* Jump to next break point<br />`F5`
* Go to next line<br />`F10`
* Go deeply to next line<br />`F11`
* Exception Settings<br />`CTRL + ALT + E`
* Breakpoint Window<br />`CTRL + ALT + B`
* Stop debugging<br />`SHIFT + F5`

##### Bookmarks
* Add bookmark<br />`CTRL + K, CTRL + K`
* Go to next bookmark<br />`CTRL + K, CTRL + N`
* Go to previous bookmark<br />`CTRL + K, CTRL + P`
* Delete all bookmarks<br />`CTRL + K, CTRL + L`

##### Text editor
* Select the word pointed by the cursor (very useful!)<br />`CTRL + W`
* Move the line up<br />`ALT + ArrowUp`
* Move the line down<br />`ALT + ArrowDown`
* Duplicate the current line<br />`CTRL + C, CTRL + V`
* Go to line<br />`CTRL + G`

##### Show definition
* Go to definition<br />`F12`
* Show definition - **peek view** (this is really cool!)<br />`ALT + F12`
* Navigate backward<br />`CTRL + -`
* Navigate forward<br />`CTRL + SHIFT + -`

##### Quick actions and search
* Quick Search<br />`CTRL + Q`
* Quick Action (suggests solutions for problems in code)<br />`CTRL + .`
* Search in Solution Explorer<br />`CTRL + ;`
* Quick Info<br />`CTRL + K, CTRL + I`

##### Other
* Repair code indention (this is amazing!)<br />`CTRL + K, CTRL + D`
* Create a method<br />`CTRL + K, CTRL + M`
* Roll and expand regions<br />`CTRL + M + M`
* Solution Explorer<br />`CTRL + ALT + L`
* Command Window (`redo`, `undo`, `Debug.Print variableName`)<br />`CTRL + AlT + A`
* Threads, a window showing current threads<br />`ALT + CTRL + H`

### TAB options
It is important to set the same tab options in the developer team because source control system can see different code indention as changes in the code. To set tab options go to: ->Tools ->Options ->Text Editor ->All Languages ->Tabs, and set:
* Tab size: 3
* Indent size: 3
* Insert spaces: True

### Turn off Word Wrap
Word Wrap is a setting that will break all the lines of code that are too long to fit the screen. Some people may like it, some not. If you want to change this setting go to: ->Tools ->Options ->Text Editor ->All Languages ->General ->Word Wrap

### Scrollbar with code previev
There is a nice feature in Sublime text editor, that it shows a little code previev on the scrollbar. In Visual Studio it is called **map mode**, to turn it on right clik on the scrollbar and go to: ->ScrollBar Options ->Behavior ->**Use map mode for vertical scroll bar**. You can also check the **Show Previev Tooltip** option, which will show some additional preview when you will move mouse over the scrollbar.

### Turn off exceptions
Sometimes while debugging the application may throw a lot of exceptions that we don't care at the moment. We can turn off some exceptions or even all of them. Go to **Exceptions Settings**: ->Debug ->Windows ->Exceptions Settings or push `CTRL + ALT + E` and simply choose which exceptions you want to turn off.

### Nice Visual Studio extensions
* **VSColorOutput** - it colors the output in Output Window, making it much more readable
* **Indent Guides** - it shows line for each code indention level, since VS2017 such feature is already implemented in Visual Studio
* **ResXManager** - described in the next tip

### ResXManager
This is a very popular extension that allows to easily manage string resources in the application. It is especially useful when you want to support many different languages in your application.<br />

##### Install
->Tools ->Extensions and Updates ->Online ->Search: ResXManager ->Download

##### Open
->Tools ->ResX Manager, or:<br />
->Right click on .resx file ->Open in ResX Manager

##### Add new string to String.resx from code
There is a really nice feature of **ResXManager** that allows to add a string used in C# code to .resx file. To make it just right click on the string and choose **Move to Resource**. A new window will appear where you will be able to choose to which .resx file add the string, what key name it will have and what code will be used in C# in place of the string.

### Create your own snippets
Snippets are quite nice feature of Visual Stduio. They allow you to type little command and push `TAB` twice to expand this command into code. Here is an example of XML snippet definition. You can use it to create your own snippets. You have to change the content of **Title** and **Shortcut** markup and of course the most important part the **Code** markup. Such XML file has to be saved with .snippet extension.
```xml
<?xml version="1.0" encoding="utf-8"?>
<CodeSnippets
    xmlns="http://schemas.microsoft.com/VisualStudio/2005/CodeSnippet">
   <CodeSnippet Format="1.0.0">
      <Header>
         <Title>Close WCF client</Title>
         <Shortcut>closewcf</Shortcut>  
      </Header>
      <Snippet>
         <Code Language="CSharp">
            <![CDATA[
               try
               {
                  client.Close();
               }
               catch (CommunicationException e)
               {
                  Client.Abort();
               }
               catch (TimeoutException e)
               {
                  Client.Abort();
               }
               catch (Exception e)
               {
                  Client.Abort();
                  throw;
               }
            ]]>
         </Code>
      </Snippet>
   </CodeSnippet>
</CodeSnippets>
```
To import snippet into Visual Studio go to: ->Tools ->Code Snippets Manager ->Language: CSharp ->Import

### Application settings
To create settings for your application right click on the project in Solution Explorer and go to: ->Properties ->Settings ->Create settings ->Add any setting you need. Settings are stored in **Properties\Settings.settings** file.<br />
To read a setting from C# code use the follwing line of code:
```csharp
Properties.Setting.Default["settingName"];
```
To change setting value use the following code:
```csharp
Properties.Settings.Default["settingName"] = newValue;
Properties.Settings.Default.Save();
```

### ClickOnce Publish
Here is a little description of very basic configuration of ClickOnce publish.<br />
->Right click on Project ->Properties<br />

##### Application 
->Assembly Information ->Assembly version = File version<br />
->Manifest ->Create application without a manifest

##### Signing
->Sign the ClickOnce manifest = false<br />
->Sign the assembly = false<br />

##### Security
->Enable ClickOnce security settings = false

##### Publish
->Publish version (changes automatically!)<br />
->Updates ->Before the application starts<br />
->Updates ->Specify a minimum required version for this application = Publish version<br />
->Prequisites ->Download prequisites from same location as my application<br />
->Options ->Deployment ->Deployment web page = **publish.htm**<br />
->Options ->Deployment ->Auotmatically generate deployment web page after every publish = true

### Problem with dotNetFix while publishing
Donwload dotNetFix from [here](https://www.microsoft.com/en-us/download/details.aspx?id=42642) and put it here `C:\Program Files (x86)\Microsoft Visual Studio 14.0\SDK\Bootstrapper\Packages\DotNetFX452`.

### Web.config for test and production
**Web.config** is a file where a lof of configuration is stored, some database connection string or service connection data. Different setting are required in test environment and different in production. Visual Studio allows to create XML transforms for Web.config and automatically switch between them while publishing the web application.<br />
First go to: ->Build ->Configuration Manager ->Configuration (column) ->Expand the list and select <New...>.<br />
For each build configuration that you will create you can also have a specific Web.config transform. To do this right click on Web.config and choose **Add Config Transform**.<br />
Now you can also create a publish configuration that will use your build configuration and Web.config:<br /> ->Right click on Project ->Publish ->Custom<br />
->Connection ->Publish method: File System (example path `\\106.116.82.90\c$\inetpub\MyAppName`)<br /> 
->Settings ->Configuration ->Choose your configuration

### Bad image exception
Such error can be caused by few things but at first, try to change platform target:<br />
->Right click on the project ->Properties ->Build ->Plarform Target

### Edit HTML and CSS while debbugging is off
->Tools ->Options ->Debugging ->Enable Edit and Continue

## TFS and other version control systems
**Team Foundation Server** is a version control system developed by Microsoft and integrated with Visual Studio. There are many other version control systems like Git or SVN which can be also easily integrated with Visual Studio through extensions.

### Add new TFS project
->Go to VSTS (web panel) of your collection ->Gear icon (in the top menu) ->Collection Settings ->New team project<br />
->Go to Visual Studio ->Team Explorer ->Source Control Explorer ->Select your new TFS project<br />
->File ->Project ->Choose project type ->Set solution name - the same as TFS project name ->Set location to your TFS folder (for example `D:\tfs\`) ->Right click on solution ->Add to Source Control

### Change project mappings to disk
->Run Visual Studio ->Team Explorer ->Source Control Explorer ->Workspace (on the top bar) ->Workspaces (from expendable list) ->Edit 

### Delete TFS project
->Go to VSTS (web panel) of your collection ->Gear icon (in the top menu) ->Collection Settings ->Three dots icon (next to the project you want to delete) ->Delete ->Type project's name

### Branching
If you need to keep more than one version of code of some project it is good to use branching. This techinque allows you to create an alternative version of your project. For example you can have one branch with stable version of your application, ready for production and another branch being currently developed and not ready for production. This is very common approach and it is easy to implement in TFS.<br />
Before creating branches for your project it is good to put all the solution files and folders into one folder that will be easy to branch. If all your files are at the root level of TFS project it won't be so easy.<br />

##### Create a branch
Before creating a branch you must check-in all pending changes.<br />
->Source Control Explorer ->Right click on folder that you want to branch ->**Branching and Merging** ->Branch ->Target - set your branch name ->Set: **Immediately convert source folder to branch**<br />
A nice thing to know is that you can create a branch from any version of code that you want. You can specify it in **Branch from version** group.

##### Merge
If you will change something in a child branch and want to apply those changes in a parent branch, for example to publish a new funcionality in production, you have to merge those branches:<br />
->Source Control Explorer ->Right click on source branch ->**Branching and Merging** ->Merge ->Select target branch (where the changes will be applied) ->Next ->Finish<br />
If some conflicts will occur, TFS will allow you to resolve them with the Resolve Conflicts tool.

##### Reparent
Sometimes it maybe a good choice to change the relationship between branches, to convert a child into parent and reverse. To do that, first you have to change child's branch parent to **No parent** and then assign this branch as a parent for the second branch (which was a parent before). You will the reparent option here: ->Source Control Explorer ->Right click on a branch ->Branching and Merging ->Reparent. It can be very useful to see branches hierarchy, go to ->Source Control Explorer ->Right click on a branch ->Branching and Merging ->View Hierarchy.

##### TF14098: Access Denied: User ... needs ManageBranch permission(s)
If you see the above error you have to add specific permission to given user or a group. In Visual Studio go to ->Team Explorer ->Source Control Explorer ->Right click at the TFS projects or the whole collection ->Advanced ->Security. In the Permissions window you can click Add button to add a TFS group or Windows user identity and then set **Manage branch** permission to **Allow**. 

### Ignore a file or directory
->Source Control Explorer ->Pending Changes ->**Excluded Changes** ->**Detected** ->Right click on a selected item ->Ignore by folder (or other ignore option).<br />
This will generate a `.tfignore` file where you can put things that you want to be ignored by TFS, it can look like this for example:
```
\packages
\UpdateLog*
\WebApp\logs
\MobileApp\platforms\android\assets\www
\MobileApp\www
\MobileApp\package-lock.json
```
Be careful because it won't have any effect on files that are already added to source control. So if there is a file that you want to ignore but it is added to source control, you have to delete it firstly and check-in/commit changes.

### Authorization error after changing account password
If you will encounter the following error code: `TF30063` that probably means that you cannot be authorized to connect TFS server. It can happen if you changed your current Windows account password. Go to:<br />
*(English)* ->Control Panel ->User accounts ->Credential Manager ->Windows Credentials ->Choose TFS ->Edit ->Put new password<br/>
*(Polish)* ->Panel Sterowania ->Konta użytkowników ->Zarządzaj poświadczeniami ->Poświadczenia systemu Windows ->Wybierz TFS ->Edytuj ->Podaj nowe hasło

### No workspace matching error after changing computer name
TFS stores the information about your workspace which is strictly connected to your computer name. If your computer name will change, you may see an error message after trying to connect to TFS, saying that **workspace XYZ does not reside on this computer**. It will also suggest to use `tf workspaces /updateComputerName:oldComputerName`, but it may not be enough to resolve the issue.<br />
1. The first thing you have to do is to add a new workspace: ->Team Explorer ->Solutions (at the bottom) ->Workspace ->Manage Workspaces ->Add ->Set name of the workspace to be the same as your new computer name (as default).<br />
2. Next you can run the **tf** command:
```powershell
cd C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE
#This directory may be different depending on your installation and VS and TFS version

TF.exe workspaces /updateComputerName:old-comp-name /s:http://corpdev:8080/tfs
#Remember to put the OLD name of your computer, not new one
```
3. Then go to `%userprofile%\AppData\Local\Microsoft\Team Foundation`. You will find there few directories called `7.0`, `6.0` and so on and each one of them has `Cache` directory inside. Delete the content of each `Cache` directory. You can make it with one Powershell command. The `~` sign stands for the user profile directory.
```powershell
ls "~\AppData\Local\Microsoft\Team Foundation" -recurse -filter Cache | ls | rm -recurse -force
```
4. The last step is to go to Visual Studio and **Source Control Explorer** and map your new workspace to your disk. Actually, if you don't want to map your workspace to the old directory, but create a new one, you can omit the third step.<br />

By the way, the **tf** command is capable of a lot more! Go to [useful links](#useful-links) to learn more. 

### AnkhSVN
**AnkhSVN** is an amazing extension for Visual Studio that integrates SVN support into Visual Studio GUI, it is very intuitive and easy to use. After you install the plugin, you have to set it as the source control for Visual Studio. Go to: ->Tools ->Options ->Source Control ->Plugin Selection ->Current source control plug-in: **AnkhSVN**.<br />
Now if you right click on some file, project or solution you will be able to choose among few options: Update to Latest Version, Revert, Commit, Show Changes and other.<br />
If you will encounter an error about lock, right click the file or folder ->Subversion ->Cleanup ->Commit.

## VS Code
Visual Studio Code is a lightweight text editor that can be used for free and even replace Visual Studio in smaller projects. It has many extensions so it can be used for many different types of projects and programming languages.

### Keyboard shortcuts from Visual Studio
For those familiar with Visual Studio the thing that can be annoying while using VS Code are shortcuts. They are quite different than those in Visual Studio. Especially `CTRL + W` which in Visual Studio selects the word pointed by the cursor and in VS Code it closes the current document.<br />The only thing that has to be done to use Visual Studio shortcuts inside VS Code is to install an extenstion called **Visual Studio Keymap**.

### Extensions
There are many extensions available for VS Code that can convert in a complex IDE with specialized tools for different programming languages or frameworks.
* **Path Intellisense** - adds autocompletion for file names (extremely useful)
* **Live Server** - it allows you to right click on a HTML file and select **Open with Live Server** to start a little HTTP server that will serve you your HTML file - be careful to be able to use it you must open some folder (CTRL + K, CTRL + O), it doesn't work with single file
* **Vetur** - syntax highlighting for Vue components
* **AutoHotkey** - syntax highlighting for AHK files
* **Better Line Select** - adds a new shortcut `CTRL + L` that selects the current line and puts the cursor under the selected line and `CTRL + SHIFT + L` that also selects the current line and puts the cursor above the selected line (it may not work if you will install Visual Studio Keymap)

### Manually installing extenstions
If you cannot install extensions from VS Code, you can install them manually. Go to [Visual Studio Marketplace](https://marketplace.visualstudio.com/vscode). Find your extensions and in **Resources** menu (on the right) click **Download Extension**.<br />
Now go to VS Code, go to **Extension** menu (the last icon on the left), click options (the icon with tree dots - top right corner) and select **Install from VSIX**.

### HTML snippets
In HTML files you can use some built-in snippets. You have to type the snippet name and then press `TAB` to expand the snippet. See here for a little list:
* `lorem10` - expands 10 first words of the lorem ipsum text
* `lorem100` - expands 100 first words of the lorem ipsum text, you can actually put some other numbers, not only 10 and 100
* `!` - expands a simple blank HTML template

Of course you can also define your own snippets, not only for HTML. There is even an online tool to make it easier, [here](https://snippet-generator.app/).

### Open git repository in VS Code
Push `CTRL + SHIFT + P` to open **Command Palette**, type `Git: Clone` and paste the repository URL and push `Enter`. Quite simple, isn't it?

## Useful links

#### Learn more
[Windows processes description 1](https://www.neuber.com/taskmanager/process/)<br />
[Windows processes description 2](http://www.processlibrary.com/en/)<br /> 
[Active Directory Documentation](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc754661(v%3dws.10))<br />
[How to Combine Images into One PDF File](https://www.howtogeek.com/248462/how-to-combine-images-into-one-pdf-file-in-windows/)<br />

#### Tools for Windows
[SysInternals - Windows tools](https://live.sysinternals.com/)<br />
[SysInternals Suite](https://docs.microsoft.com/pl-pl/sysinternals/downloads/sysinternals-suite)<br />
[Process Hacker](https://processhacker.sourceforge.io/downloads.php)<br />
[Yaprocmon](http://yaprocmon.sourceforge.net/)<br />
[All in One - System Rescue Toolkit](https://paul.is-a-geek.org/aio-srt/)<br />
[SeaTools - Disk diagnostics](https://www.seagate.com/gb/en/support/downloads/seatools/#)<br />
[Lazesoft Recovery Suite](https://www.lazesoft.com/lazesoft-recovery-suite-free.html)<br />
[FixWin 10](https://www.thewindowsclub.com/fixwin-for-windows-10)<br />
[VeraCrypt](https://www.veracrypt.fr/en/Downloads.html)<br />
[Ninite - Install apps for Windows](https://ninite.com/)<br />
[Driver Store Explorer](https://github.com/lostindark/DriverStoreExplorer)<br />

#### Malware scanners
[Dr. Web CureIt! - scanner](https://free.drweb.com/download+cureit+free/?lng=en)<br />
[Dr. Web CureIt! - live CD](https://free.drweb-av.pl/aid_admin/)<br />
[Zemana Anti Malware](https://www.zemana.com/antimalware)<br />
[Zemana Anti Malware Portable](http://portable.info.pl/zemana-antimalware-portable/)<br />
[MalwareBytes Anti Malware](https://www.malwarebytes.com/premium/)<br />
[AdwCleaner](https://www.bleepingcomputer.com/download/adwcleaner/)<br />
[AdwCleaner](https://pl.malwarebytes.com/adwcleaner/)<br />
[HitmanPro](https://www.hitmanpro.com/en-us/downloads.aspx)<br />
[ESET SysRescue](https://www.eset.com/uk/support/sysrescue/)<br />
-<br />
[Farbar Recovery Smart Tool x86](http://www.bleepingcomputer.com/download/farbar-recovery-scan-tool/dl/81/)<br /> 
[Farbar Recovery Smart Tool x64](https://www.bleepingcomputer.com/download/farbar-recovery-scan-tool/dl/82/)<br /> 
[Farbar Recovery Smart Tool - how to](http://www.geekstogo.com/forum/topic/335081-frst-tutorial-how-to-use-farbar-recovery-scan-tool/)<br />
[TDSSKiller](http://support.kaspersky.com/viruses/utility#TDSSKiller)<br /> 

#### LSP/Winsock2
[Changes in LSP stack](https://blog.malwarebytes.com/cybercrime/2014/10/changes-in-the-lsp-stack/)<br />
[NirSoft WinsockServicesView](https://www.nirsoft.net/utils/winsock_service_providers.html)<br />
[LSP-Fix (for Win XP)](http://www.cexx.org/lspfix.htm)<br />
[Spabot.AS](https://www.pandasecurity.com/homeusers/security-info/160902/information/Spabot.AS)<br />

#### Visual Studio and TFS
[Visual Studio Marketplace](https://marketplace.visualstudio.com/)<br />
[Programming languages in Visual Studio](https://docs.microsoft.com/pl-pl/visualstudio/#pivot=languages)<br />
[TFS from command line](https://docs.microsoft.com/pl-pl/vsts/repos/tfvc/use-team-foundation-version-control-commands?view=vsts)<br />

#### Git
[Configuración de un repositorio Git en Visual Studio - Español](https://www.kabel.es/configuracion-git-visual-studio/)<br />
[Fundamentos de Git - Español](https://git-scm.com/book/es/v1/Fundamentos-de-Git-Trabajando-con-repositorios-remotos)<br />
[Version Control in VS Code](https://code.visualstudio.com/docs/editor/versioncontrol)<br />
[Git Version Control in VS Code (Video)](https://code.visualstudio.com/docs/introvideos/versioncontrol)<br />
[Why are my commits linked to the wrong user?](https://help.github.com/articles/why-are-my-commits-linked-to-the-wrong-user/)<br />

#### Audio-video tools
[Convert CDA files to MP3](http://www.freerip.com/)<br />
[HandBrake - resize video](https://handbrake.fr/)<br />
[Moo0 Tools - video compression](http://www.moo0.com/?top=http://www.moo0.com/software/VideoMinimizer/)<br />
[ClipGrab - YouTube downloader and converter](https://clipgrab.org/)<br />
[YouTube Song Downloader](https://www.abelssoft.de/en/windows/Multimedia/YouTube-Song-Downloader)<br />

#### Online audio-video tools
[Cut, join, convert audio files](http://mp3cut.net/)<br />
[Convert MP3, WAW, OGG, WMA](http://media.io/es/)<br />
[Make MP3 files louder](http://www.mp3louder.com/)<br />
[Cut and convert video files](http://online-video-cutter.com/)<br />
[Download YouTube songs](https://listentoyoutube.online/)<br />
[Download YouTube videos](https://keepvid.pro/)<br />

#### Image tools
[Png2jpg Converter](http://www.easy2convert.com/png2jpg/)<br />
[Png2jpg Command-Line Converter](https://sourceforge.net/projects/png2jpeg/)<br />

#### Online image tools
[Color picker](http://www.colorpicker.com/)<br />
[Convert PNG to ICO](http://convertico.com/)<br />
[Convert ICO to PNG](http://icoconvert.com/icon_to_image_converter/)<br />
[Sketch](https://sketch.io/sketchpad/)<br />

#### Online dev tools
[Regex editor](http://regexr.com/)<br />
[Barcode generator](http://barcode.tec-it.com/en)<br />
[SHA256 calculator](http://www.xorbin.com/tools/sha256-hash-calculator)<br />
[MD5 checksum](http://onlinemd5.com/)<br />
[VS Code Snippet Generator](https://snippet-generator.app/)<br />
[UML editor](https://www.draw.io/)<br />

#### Linux
[Tails - Linux live distribution for privacy](https://tails.boum.org/)<br />
[Kali Linux live USB with persistence](https://medium.com/@fatahnuram/creating-kali-linux-live-usb-with-persistence-a-simple-guide-54e3eb01b6aa)<br />
