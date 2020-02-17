## IIS
**Internet Information Services** is a web server developed by Microsoft. It is very popular, especially for hosting .Net applications and can be easily installed on Windows Server. [Here](https://github.com/abik11/tips-tricks/blob/master/Powershell/TaskAutomation#iis) you can learn a little bit about how to work with IIS thorugh the command line which might be useful for task automation.

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
