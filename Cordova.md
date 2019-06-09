# Cordova

* [Cordova CLI](#cordova-cli)
* [Tools](#tools)
* [Development](#development)
* [Useful links](#useful-links)

Read also:
* [Web](https://github.com/abik11/tips-tricks/blob/master/Web.md)
* [Publish .apk file in IIS](https://github.com/abik11/tips-tricks/blob/master/W10+VS17+TFS.md#publish-android-apk)

## Cordova CLI
You can use different tools to work with Cordova, for example **Visual Studio Tools for Apache Cordova** to manage Cordova with Visual Studio. But still it may be useful to know how to handle Cordova through command line in case if other tools will not be able to do the job or something will go wrong.

### Install and update cordova
To install Cordova you require **node** and **npm** (npm is installed toegether with node). 
```
npm install -g cordova
npm update -g cordova
cordova platform update android --save
```

### Create new app
To create a new app you should use the following command:
```
cordova create HelloApp com.example.hello HelloApp
```
Next you should add some platform for which you want to later build the app:
```
cd HelloApp
cordova platform add android --save
```
It is possible to create a new app based on a templete. And this a really nice feature, often saving a lot of time:
```
cordova create HelloApp --template cordova-app-hello-world
```
[Here](https://www.npmjs.com/search?q=cordova%3Atemplate) you can search for templates.

### Check platforms and requirements
To see what platforms are installed in the current project you can use the following command:
```
cordova platform ls
```
You can also see current requirements for the project with the following command:
```
cordova requirements
```

### Manage plugins
To list installed plugins type:
```
cordova plugin                          
```
You can search available plugins in the Internet and install them:
```
cordova plugin search camera
cordova plugin add cordova-plugin-camera
cordova plugin save
```
To delete a plugin type this:
```
cordova plugin remove cordova-plugin-camera
```

### Test and run an app
Often building and runing the app on the device may take a bit long. It is faster to run an app in the browser. You can make it with the following command:
```
cordova platform add browser
cordova run browser
```
If you want to run on a device use the following command:
```
cordova build android
cordova run android
```

## Tools
Cordova is a nice platform but sometimes may cause you many different problems. Working with it can be much easier if you will use appropriate tools to build or debug apps, for example if you will build Cordova apps with Visual Studio.

### Debugging in Chrome
->Enable debugging mode in the device, plug to the PC and run the app 
->Go to `chrome://inspect` in Chrome<br />
->Click **inspect** under your app

### Webpack Task Runner Explorer
If you use Webpack in your project, it is recommended to install **Webpack Task Runner Explorer**. It allows you to easily manage webpack configuration files through Visual Studio. You can even bind webpack files before build.<br />
If you use **node-sass** you can encounter the following error: `Missing binding (...) Node Sass could not find a binding for your current environment`. In such case go [here](https://github.com/sass/node-sass/releases), find the appropriate binding file, download and paste it in the path that is shown in the error message.

### Installing newer API Levels
When you install new Android API Levels, in most cases all you need is **SDK Platform**, you don't need System Image (if you don't debug on the emulator) and many other components.<br />
If you will encounter the following error: `skipping existing file: gradle-wrapper.jar`, go to Task Manager and kill all Visual Studio, Node and Java processes and try again.

### List connected devices
If you cannot debug your app on the device, first make sure that it is seen by adb. In the command line go to the directory where adb is installed and run `adb devices`, for example:
```
cd 'C:\Program Files (x86)\Android\android-sdk\platform-tools'
adb devices
```
If you have turned on debugging mode on your device and it is plugged by USB and still not seen on the list, you probably have to install USB drivers for your mobile device. [Here](https://developer.samsung.com/galaxy/others/android-usb-driver-for-windows) you can find drivers for Samsung devices.

### Visual Studio doesn't see Android SDK
It may happen if you will first install Android SDK before installing Visual Studio. To fix it, go to: ->Tools ->Options ->Tools for Apache Cordova ->Environment Variable Overrides and then set **ANDROID_HOME** as a path to **android-sdk**.

### Visual Studio cannot run adb.exe
Delete `.vs` directory in your solution that contains your mobile app. Then it should work though you may lose some settings.

### Set proxy in SDK Manager
If you see the following errors in SDK manager:
```
* Failed to fetch URL connection to refused
* Failed to fetch URL peer not authenticated
```
It may be caused because you work in a network with proxy. To configure proxy in SDK Manager go to: ->Tools ->Options:
* Proxy Server: 106.116.81.88
* Proxy Port: 8080
* Force https:// source: TRUE

### Failed to fetch platform android + Error: tunneling socket
If you will encounter any proxy errors, they may come from few different sources: npm, gradle and git. To know how to set proxy configuration for npm and git go [here](https://github.com/abik11/tips-tricks/blob/master/Web.md#proxy-configuration-for-npm).<br />
Then, change this file: `.\MySolution\MobileProject\platforms\android\gradle.properties` to this:
```text
systemProp.proxySet="true"
systemProp.http.keepAlive="true"
systemProp.http.proxyHost=104.114.81.88
systemProp.http.proxyPort=8080
systemProp.http.proxyUser=DOMAIN/user.name
systemProp.http.proxyPassword=pass
```

### Could not resolve com.android.support
```
FAILURE: Build failed with an exception.
What went wrong:
A problem occurred configuring root project 'android'.
> Could not resolve all dependencies for configuration ':_debugCompile'.
> Could not resolve com.android.support:support-v4:24.1.1+.
Required by:
:android:unspecified
> Could not resolve com.android.support:support-v4:24.1.1+.
> Failed to list versions for com.android.support:support-v4.
```
If you see such error it means that **Android Support Repository** is not installed in the correct version. You have to go to '/android-sdk/SDK Manager.exe' and update it through this tool. Go to ->Extras ->Android Support Repository and update to version 47.

### CordovaError: Current working directory is not a Cordova-based project.
If you see this error while trying to install new Cordova plugin or building the project - check if your structure has **www** directory, if not, then add this directory or if you use Webpack, configure it to create it for you.

### Cordova-build error : Please install Android target: "android-23"
You can see something like that if you have omitted some API Level while updating Android SDK to higher API Level, for example from 21 to 25.

### Error : BLD00401 : Could not find module '...\node_modules\vs-tac\app.js'...
*I have bad feelings about this...*<br />
If you see the above error, you are lost. Create completely new Cordova solution and copy your source files to this solution. That's the best thing you can do.

### Install Graddle
If you have no Graddle installed or have some problems with it (which may happen quite often......) download it from [here](http://services.gradle.org/distributions/gradle-2.2.1-all.zip). Unzip and copy gradle to some directory. Add this directory to `PATH` variable, for example: `C:\Program Files (x86)\Android\gradle-2.2.1\bin`.<br />
To see if everything is allright, use following command: `cordova requirements`.

### TLS version errors
You may see some of the following in the output:
```
> Could not GET 'https://repo1.maven.org/maven2/org/slf4j/slf4j-api/maven-metadata.xml'.
> Received fatal alert: protocol_version
```
if you use Java 1.7 or older toegether with Gralde 4.8 or older. If so, the easiest way to solve the issue is to install Java 1.8. Go [here](https://stackoverflow.com/questions/51090914/received-fatal-alert-protocol-version-build-failure-gradle-maven) to see more details.<br />
You can also encounter problems with TLS version while installing Cordova plugins (through git). To check what version of TLS uses git on your machine use the following command:
```
git config --global http.sslVersion
```
If it is `1.1` then setting it to `1.2` should solve the problem:
```
git config --global http.sslVersion tlsv1.2
```

### Pin the app
Since Android version 5.0 there is a functionality that you can pin and lock the app so the user will not be able to close it and run other apps. Go to: ->Settings ->General ->Security ->Advanced ->Screen pinning, or: ->Settings ->Lock screen and security ->Other security settings ->Screen pinning.<br />
In polish it is: ->Ustawienia ->Ogólne ->Bezpieczeństwo ->Zaawansowane ->Przypnij okno, or: ->Ustawienia ->Ekran blokady i bezpieczeństwo ->Inne ustawienia bezpieczeństwa ->Przypnij okno.<br />
In spanish this function is called: *Fijar ventanas*.<br /> 
To unlock the app you have to press the back button and menu button (both at once) and put the PIN number. To set the PIN go to: ->Device ->Lock Screen ->Lock Screen ->PIN.

### How to check device IMEI
Type the following code instead of phone number: `*#06#`.

### How to errase permamently all the data from the phone?
Delete all the data and then start recording a movie. Record it as long as there will be no more free memory. You can repeat this few times to be sure the previous data is overwriten.

## Development
In general when you develop applications with Cordova it is very similar to web app development, but there are some differences and additional functionalities not available in casual web development. The most important difference is the application structure. You must put your code insinde of the **deviceready** event handler:
```html
<!DOCTYPE html>
<html>
    <head>
        <script type="text/javascript" charset="utf-8" src="cordova.js"></script>
        <script type="text/javascript" charset="utf-8" src="index.js"></script>
    </head>
    <body>
    </body>
</html>
```
```js
(function(){
    document.addEventListener('deviceready', onDeviceReady.bind(this), false);
    
    function onDeviceReady() {
        document.addEventListener('pause', onPause.bind(this), false);
        document.addEventListener('resume', onResume.bind(this), false);
        
        console.log("App started...");
    }
    
   function onPause() { }
   function onResume() { }    
})();
```

### Check platform and version
```javascript
if(cordova.platformId == "android" && device.platform == "Android")
    console.log(device.version);
```

### Enabling CORS
Cross-origin resource sharing is a very common mechanism that allows your web app to access resources or APIs that are located in other domain than your app. To enable CORS in Cordova app you have to take few steps. First add Whitelist Plugin: `cordova plugin add cordova-plugin-whitelist`. Then modify **config.xml**, add this:
```xml
<access origin="*" />
<allow-navigation href="*" />
<plugin name="cordova-plugin-whitelist" version="1.3.2" />
```
inside of the **widget** tag. Finally modify **index.html**, add:
```html
<meta http-equiv="Content-Security-Policy" content="default-src * data: gap: https://ssl.gstatic.com 'unsafe-eval'; style-src 'self' 'unsafe-inline'; media-src *">
```
inside **head** tag.

### Device events
There are some additional events connected with the device as: **backbutton**, **menubutton**, **searchbutton**, **volumedownbutton**, **volumeupbutton** that you can use the same way as other DOM events.

##### Prevent default event handling
With **preventDefault** method of event object you can block default event handlers or *override* them which may be very useful with device button events:
```javascript
document.addEventListener("backbutton", onBackKeyDown, false);

function onBackKeyDown(e) {
   e.preventDefault();
}
```

##### Handle backbutton event in Vue
Here is a little example of a component that goes to the default route when the back button is clicked:
```javascript
export default {
   name: 'component1',
   created() {
      document.addEventListener('backbutton', () => this.$router.push('/'), false);
   },
   beforeDestroy() {
      document.removeEventListener('backbutton', () => this.$router.push('/'));
   }
};
```

##### Battery events
```javascript
window.addEventListener("batterystatus", onBatteryStatus, false);

function onBatteryStatus(info) {
   console.log("Level:" + info.level);
   console.log("IsPlugged:" + info.isPlugged);
}
```
There are also other events like: **batterylow**, **batterycritical**.

### Sending files to WCF service
To work with files in general you have to install **cordova-plugin-file** plugin which is one of the default plugins. Here you can see an example of a function that will let you access a file:
```javascript
readFile(fileName, onFileLoaded, onFileError){
    window.resolveLocalFileSystemURL(fileName, function (fileEntry) {
        fileEntry.file(function (file) {
            var reader = new FileReader();
            
            //Attach onLoadEnd event handler for FileReader
            reader.onloadend = onFileLoaded;
            reader.onerror = onFileError;
            
            //Execute read action - will cause onLoadEnd event
            reader.readAsBinaryString(file);
        }, onFileError);
    }, defaults.defaultErrorHandler);
}
```
This function can be easily used with a promise:
```javascript
var p = new Promise((resolve, reject) => {
    readFile(fileName, e => resolve(e.target.result), () => reject());
});

p.then(file => {
    axios.post(webServiceUrl, JSON.Stringify({ file }))
        .then(response => console.log(response));
});
```
The WCF method that gets a file should the following contract:
```csharp
[OperationContract]
[WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, 
BodyStyle = WebMessageBodyStyle.Wrapped)][return: MessageParameter(Name = "result")]
JSONResponse SaveFile(Stream JSONDataStream);
```
and the following implementation:
```csharp
public JSONResponse SaveFile(Stream JSONDataStream)
{
    JSONResponse response = new JSONResponse();
    try
    {
        StreamReader reader = new StreamReader(JSONDataStream);
        string JSONdata = reader.ReadToEnd();
        JavaScriptSerializer JS = new JavaScriptSerializer();
        DataItem data = JS.Deserialize<DataItem>(JSONdata);
        
         Logic.SaveFile(data.file);
         response.Code = 200;
    }
    catch(Exception){ response.Code = 500; }
    return response;
}
```

### MAC Address is equal 02:00:00:00:00:00
In Android 6.0 and higher, to get MAC address, additional permissions are required so many old plugins don't work correctly. Use [this](https://github.com/navidmalekan/getmac/blob/master/www/getmac.js) plugin to work with modern devices.<br />
By the way, some older devices may return MAC Address as `error` when the device is offline.

### Promise doesn't work
In Android 4.4 and below in WebView control which is used to show Cordova applications **Promise** may not work. To fix it you should use the pollyfil, for example [this](https://github.com/stefanpenner/es6-promise/) one. Installation through npm is very simple:`npm install es6-promise`. To make the pollyfil work you have to add it in the main javascript file of your app:
```javascript
require('es6-promise').polyfill();
```

### Unable to open asset URL: file:///android_asset/www/img/xyz.png 
If you see this error while trying to reference an image by indirect path, change it to direct path. For example, change this: `/img/xyz.png ` to this: `file:///android_asset/www/img/xyz.png`.<br />
With Webpack you can still use indirect paths to images if you will define a rule that will translate those paths for you. Here is an example:
```javascript
{
    test: /\.(jpe?g|png|gif|svg)$/i,
    loader: 'file-loader',
    options: {
        name: '[name].[ext]',
        outputPath: 'img/',
        publicPath: 'file:///android_asset/www/'
    }
}
```
You have to add this in your **main.js** to include images:
```javascript
require.context("../img/", true, /\.(jpe?g|png|gif|svg)$/i);
```

### Phonegap-plugin-barcodescanner version
Be careful with the above plugin. If you want to use it with Cordova 6 (6.3.1 for example), add the following line in your `config.xml`:
```xml
<plugin name="phonegap-plugin-barcodescanner" source="npm" spec="6.0.8" />
```
Since version 7 and aboce the plugin is not compatibile with Cordova 6.

## Useful links

##### General stuff
[ADK for Windows](https://android-sdk.uptodown.com/windows)<br />
[Cordova docs](https://cordova.apache.org/docs/en/latest/)<br />
[Cordova templates](https://www.npmjs.com/search?q=cordova%3Atemplate)<br />
[How do I add "uses-permissions" tags to AndroidManifest.xml for a Cordova project?](https://stackoverflow.com/questions/30042088/how-do-i-add-uses-permissions-tags-to-androidmanifest-xml-for-a-cordova-projec)<br />
[Tools for Cordova 2017](https://docs.microsoft.com/en-us/visualstudio/cross-platform/tools-for-cordova/?view=toolsforcordova-2017)<br />

##### Plugins
[Getmac Plugin - above Android 6](https://github.com/navidmalekan/getmac)<br />
[Background Plugin](https://github.com/katzer/cordova-plugin-background-mode)<br />
[Local-Notifications Plugin](https://github.com/katzer/cordova-plugin-local-notifications)<br />
[Badge Plugin](https://github.com/katzer/cordova-plugin-badge)<br />
[Bluetooth Plugin](https://github.com/tanelih/phonegap-bluetooth-plugin)<br />
[Screen Orientation Plugin](https://github.com/apache/cordova-plugin-screen-orientation)<br />

##### Webpack for Visua Studio
<https://developer.telerik.com/featured/webpack-for-visual-studio-developers/><br />
<https://sochix.ru/how-to-integrate-webpack-into-visual-studio-2015/><br />
