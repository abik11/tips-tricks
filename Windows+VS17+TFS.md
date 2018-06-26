# Tips for beginners

* Windows
* Visual Studio
* TFS and other version control systems
* VS Code

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
* `sysdm.cpl` - system variables, remote settings
* `diskmgmt.msc` - disk management (resize, add new)
* `MsInfo32.exe` - system info
* `winver` - system version
* `mstsc` - Remote Desktop Connection
* `regedit` - registry editor 
* `gpedit.msc`  - local group policy
* `cmd`  - command line

### Admin Panel in Windows 7
Create a directory and call it like this: `SuperAdmin.{ED7BA470-8E54-465E-825C-99712043E01C} ` and it will become an Admin Panel with many nice tools.

### Default virus
To test antivirus software copy and paste this: `X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*` into text file and save it. Antivirus should immediately recognize this text file as a virus.

### Check if exe file is x86 or x64
Open the exe file as text and search for the first `PE` string appearance. If you will find ` PE  L  ` it means it is x86 executable and if you will find ` PE  d† ` it means it is x64 executable.

### Clean disk from scrap
->Right click on a disk ->Properties ->Disk Cleanup, or:<br />
->Start ->Programs ->Accessories ->System Tools ->Disk Cleanup<br />
You can also delete all the files inside of these directories:
* `C:\Windows\Logs\CBS`
* `C:\Windows\Temp`

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

### Wireshark filters
To be able to quickly find what you need in Wireshark it is crucial to use filter, here is a nice example: ` (tcp.dstport == 8080 || tcp.srcport == 8080) && (http.request.method == "CONNECT" || http.response.code == 407 || http.response.code == 200)`

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

##### Quick actions and search
* Quick Search<br />`CTRL + Q`
* Quick Action (suggests solutions for problems in code)<br />`CTRL + .`

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
**Team Foundation Server** is a version control system developed by Microsoft and integrated with Visual Studio. There are some other version control systems like Git or SVN which can be also easily integrated with Visual Studio through extensions.

### Add new TFS project
##### New team project
->Team Explorer Window ->Manage Connections (Green plug icon) ->Connect ->Projects and My Teams ->New Team Project... -> Next/Next/Next ;)

##### Map team project to disk
->Team Explorer Window ->Source Control Explorer ->Click the project name on the list ->Not mapped ->Local folder-> Select: Recursive ->Map

##### Upload files
->File ->Open ->Project/Solution<br />
->Solution Explorer ->Right click on solution ->**Add Solution to Source Control**<br />
->Solution Explorer ->Right click on solution ->Check In ->Check In

##### Check current changes
->Team Explorer Window ->Pending Changes

##### See file's history
->Right click on project ->Source Control ->View History<br />
->Right click on changeset ->Changeset details

### Change project mappings to disk
->Run Visual Studio ->Team Explorer ->Source Control Explorer ->Workspace (on the top bar) ->Workspaces (from expendable list) ->Edit 

### Authorization error after changing account password
If you will encounter the following error code: `TF30063` that probably means that you cannot be authorized to connect TFS server. It can happen if you changed your current Windows account password. Go to:<br />
*(English)* ->Control Panel ->User accounts ->Credential Manager ->Windows Credentials ->Choose TFS ->Edit ->Put new password<br/>
*(Polish)* ->Panel Sterowania ->Konta użytkowników ->Zarządzaj poświadczeniami ->Poświadczenia systemu Windows ->Wybierz TFS ->Edytuj ->Podaj nowe hasło

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
* **Vetur** - syntax highlighting for Vue components
* **Better Line Select** - adds a new shortcut `CTRL + L` that selects the current line and puts the cursor under the selected line and `CTRL + SHIFT + L` that also selects the current line and puts the cursor above the selected line (it may not work if you will install Visual Studio Keymap)

### Manually installing extenstions
If you cannot install extensions from VS Code, you can install them manually. Go to [Visual Studio Marketplace](https://marketplace.visualstudio.com/vscode). Find your extensions and in **Resources** menu (on the right) click **Download Extension**.<br />
Now go to VS Code, go to **Extension** menu (the last icon on the left), click options (the icon with tree dots - top right corner) and select **Install from VSIX**.

### HTML snippets
In HTML files you can use some built-in snippets. You have to type the snippet name and then press `TAB` to expand the snippet. See here for a little list:
* `lorem10` - expands 10 first words of the lorem ipsum text
* `lorem100` - expands 100 first words of the lorem ipsum text, you can actually put some other numbers, not only 10 and 100
* `!` - expands a simple blank HTML template

### Open git repository in VS Code
Push `CTRL + SHIFT + P` to open **Command Palette**, type `Git: Clone` and paste the repository URL and push `Enter`. Quite simple, isn't it?

## Useful links

#### Windows processes description
[1](https://www.neuber.com/taskmanager/process/)<br />
[2](http://www.processlibrary.com/en/)<br /> 

#### Active Directory
[Documentation](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc754661(v%3dws.10))<br />

#### Malware scanners
[Dr. Web CureIt! - scanner](http://ftp.drweb.com/pub/drweb/cureit/launch.exe)<br />
[Dr. Web CureIt! - live CD](https://free.drweb-av.pl/aid_admin/)<br />
[Zemana Anti Malware](https://www.zemana.com/antimalware)<br />
[Zemana Anti Malware Portable](http://portable.info.pl/zemana-antimalware-portable/)<br />
[MalwareBytes Anti Malware](http://www.bleepingcomputer.com/download/malwarebytes-anti-malware/)<br />
[Farbar Recovery Smart Tool x86](http://www.bleepingcomputer.com/download/farbar-recovery-scan-tool/dl/81/)<br /> 
[Farbar Recovery Smart Tool x64](https://www.bleepingcomputer.com/download/farbar-recovery-scan-tool/dl/82/)<br /> 
[Farbar Recovery Smart Tool - how to](http://www.geekstogo.com/forum/topic/335081-frst-tutorial-how-to-use-farbar-recovery-scan-tool/)<br />
[TDSSKiller](http://support.kaspersky.com/viruses/utility#TDSSKiller)<br /> 

#### Audio-video tools
[Convert CDA files to MP3](http://www.freerip.com/)<br />
[Moo0 Tools - video compression](http://www.moo0.com/?top=http://www.moo0.com/software/VideoMinimizer/)

#### Online audio-video tools
[Cut, join, convert audio files](http://mp3cut.net/)<br />
[Convert MP3, WAW, OGG, WMA](http://media.io/es/)<br />
[Make MP3 files louder](http://www.mp3louder.com/)<br />
[Cut and convert video files](http://online-video-cutter.com/)<br />

#### Online image tools
[Color picker](http://www.colorpicker.com/)<br />
[Convert PNG to ICO](http://convertico.com/)<br />
[Convert ICO to PNG](http://icoconvert.com/icon_to_image_converter/)<br />
[Sketch](https://sketch.io/sketchpad/)<br />

#### Visual Studio
[Visual Studio Marketplace](https://marketplace.visualstudio.com/)<br />
[Programming languages in Visual Studio](https://docs.microsoft.com/pl-pl/visualstudio/#pivot=languages)<br />

#### Git in VS Code
[Version Control in VS Code](https://code.visualstudio.com/docs/editor/versioncontrol)<br />
[Git Version Control in VS Code (Video)](https://code.visualstudio.com/docs/introvideos/versioncontrol)<br />

#### Online dev tools
[Regex editor](http://regexr.com/)<br />
[Barcode generator](http://barcode.tec-it.com/en)<br />
[SHA256 calculator](http://www.xorbin.com/tools/sha256-hash-calculator)<br />
[MD5 checksum](http://onlinemd5.com/)<br />
[.Net error translator 1](http://finderr.net/)<br />
[.Net error translator 2](http://www.errortoenglish.com/)<br />
[UML editor](https://www.draw.io/)<br />
 
#### Online web-dev tools
[LESS editor](http://less2css.org/)<br />
[SASS editor](http://www.sassmeister.com/)<br />
[JSON editor](http://jsoneditoronline.org/)<br />
[Cubic curves generator](http://cubic-bezier.com/)<br />
[Clip-path generator](http://bennettfeely.com/clippy/)<br />
[Loader generator](http://loading.io/)<br />
[Gradient generator](http://www.colorzilla.com/gradient-editor/)<br />
[Google Fonts](http://localfont.com/)<br />
