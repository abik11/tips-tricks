# Cordova

* [Cordova CLI](#cordova-cli)
* [Tools](#tools)
* [Development](#development)
* [Useful links](#useful-links)

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
Cordova is a nice platform but sometimes may cause you many different problems. Working with it can be much easier if you will use appropriate tools to build or debug apps.

### Debugging in Chrome
->Enable debugging mode in the device, plug to the PC and run the app 
->Go to `chrome://inspect` in Chrome<br />
->Click **inspect** under your app

### Visual Studio doesn't see Android SDK
It may happen if you will first install Android SDK before installing Visual Studio. To fix it, go to: ->Tools ->Options ->Tools for Apache Cordova ->Environment Variable Overrides and then set **ANDROID_HOME** as a path to **android-sdk**.

### Pin the app
Since Android version 5.0 there is a functionality that you can pin and lock the app so the user will not be able to close it and run other apps. Go to: ->Settings ->General ->Security ->Advanced ->Screen pinning, or: ->Settings ->Lock screen and security ->Other security settings ->Screen pinning.<br />
In polish it is: ->Ustawienia ->Ogólne ->Bezpieczeństwo ->Zaawansowane ->Przypnij okno, or: ->Ustawienia ->Ekran blokady i bezpieczeństwo ->Inne ustawienia bezpieczeństwa ->Przypnij okno.<br />
In spanish this function is called: *Fijar ventanas*.<br /> 
To unlock the app you have to press the back button and menu button (both at once) and put the PIN number. To set the PIN go to: ->Device ->Lock Screen ->Lock Screen ->PIN.

### How to check device IMEI
Type the following code instead of phone number: `*#06#`.

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
var app = {
    initialize: function() {	
        this.bindEvents();	
    },
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    onDeviceReady: function() {}
};
app.initialize();
```

### MAC Address is equal 02:00:00:00:00:00
In Android 6.0 and higher, to get MAC address, additional permissions are required so many old plugins don't work correctly. Use [this](https://github.com/navidmalekan/getmac/blob/master/www/getmac.js) plugin to work with modern devices.

### Promise doesn't work
In Android 4.4 and below in WebView control which is used to show Cordova applications **Promise** may not work. To fix it you should use the pollyfil, for example [this](https://github.com/stefanpenner/es6-promise/) one. Installation through npm is very simple:`npm install es6-promise`. To make the pollyfil work you have to add it in the main javascript file of your app:
```javascript
require('es6-promise').polyfill();
```

## Useful links

##### General stuff
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
[]()<br />
