# Tips for beginners

* [Windows](#windows)
* [Devices and networks](#devices-and-networks)
* [Useful links](#useful-links)

## Windows

### Windows shortcuts
* `CTRL + ALT + Arrow` - rotate screen
* `CTRL + SHIFT + ESC` - task manager
* `win + X` - Quick Link Menu (Windows 10)
* `win + I` - Settings App (Windows 10)
* `win + R` - Run dialog box
* `win + E` - open explorer
* `win + D` - show desktop
* `win + M` - minimize all
* `win + ArrowUp` - maximize window
* `win + ArrowDown` - restore down window
* `win + ArrowLeft/Right` - move window left or right
* `ALT + TAB` - change window
* `win + P` - projector pane
* `win + V` - clipboard (list of lately coppied stuff)

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

### Configure default applications
->Settings ->Applications ->Default Applications<br />
It might be also useful to run the `assoc` command in CMD. With this command it is also possible to change file association like this for example:
```
assoc .mp4=VLC.vlc
```

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
Windows Update service is used to repair system image file. If this service is corrupted, then you will have to download new image file manualy. You can use **Windows 10 Media Creation Tool** (official Microsoft tool) or **Windows ISO Downloader** (not official) - remember to choose the correct version and language (run `winver` for more information about your system's version). After the image is downloaded you have to unzip or mount the iso file and get **install.wim** file from **sources** directory. Then you can use the following command:
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
* After the pendrive is ready you can turn off your PC (hold SHIFT and click Turn Off on Windows 10) and press F12 ([or other key depending on your PC model](http://boot-keys.org/)) while it is rebooting to get into the **Boot Menu**. In the Boot Menu you will be able to choose the PC to boot from your bootable pendrive and this way the process of installation of the system will begin.<br />
If you cannot get into Boot Menu, you can get into BIOS (press F2 or other key depending on your PC model) and change the precedence of bootable devices, putting your pendrive at the first place.<br />
[See the list](https://www.desertcrystal.com/bootkeys) to know what are the bootkeys for your pc.

##### Error: The selected disk is of the GPT partition style
While formatting a PC you may encounter the following error:
```
Windows cannot be installed to this disk. The selected disk is of the GPT partition style.
```
**GPT** is modern partition format that works with UEFI. It is superseeding older **MBR** format which works with BIOS. You may see such error, when you try to install Windows from a pendrive which has MBR format on a disk with GPT format. What you need to do in such case is to convert disk format to MBR. And there are two options:
* convert partition to MBR with **EaseUS Partition Master**
* delete all existing partitions (in the install wizard) - **be careful** you will lose all your data

Read more [here (polish)](https://www.download.net.pl/jak-rozwiazac-blad-o-stylu-partycji-gpt-przy-instalacji-windowsa/n/6765/?fbclid=IwAR0xKHDO9MRnFFoWaJ2v3IO_YdWsl1y1Bgih5ECAwYfDa_96YJs8oKIZqfM). 

### Capture image or GIF from screen
* Capture image from screen - [Snipping Tool](https://support.microsoft.com/en-us/help/13776/windows-10-use-snipping-tool-to-capture-screenshots)
* Capture GIF from screen - [Screen to GIF](https://www.screentogif.com/)

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

### Reset password for a given WSL user
In the terminal (can be Powershell) type:
```
wsl -l
```
To see the list of available distros, then:
```
wsl -d <YOUR_DISTRO_NAME> -u root

passwd <YOUR_USER_NAME>
```

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

### Change CISCO switch framework
```
flash_init
boot flash:/firmwareFileName.bin
configure terminal
do sh boot
boot system flash:/firmwareFileName.bin
exit
wr
sh run
sh ip interface
sh interfaces status
reload
```

### Share chrome tab on chrome cast
->Three dots (in the top right corner) ->Save and share (Zapisz i udostępnij) ->Cast... (Przesyłaj) ->Select device

## Useful links

#### Learn more
[Windows processes description 1](https://www.neuber.com/taskmanager/process/)<br />
[Windows processes description 2](http://www.processlibrary.com/en/)<br /> 
[Active Directory Documentation](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc754661(v%3dws.10))<br />
[How to Combine Images into One PDF File](https://www.howtogeek.com/248462/how-to-combine-images-into-one-pdf-file-in-windows/)<br />
[Boot keys](http://boot-keys.org/)<br />
[IFixIt](https://www.ifixit.com/)

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
[Anyrun - run suspicious apps on cloud enviroment and see the results](https://any.run/)<br />
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

#### Linux
[Tails - Linux live distribution for privacy](https://tails.boum.org/)<br />
[Kali Linux live USB with persistence](https://medium.com/@fatahnuram/creating-kali-linux-live-usb-with-persistence-a-simple-guide-54e3eb01b6aa)<br />
