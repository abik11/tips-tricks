# Cordova

* [Cordova CLI](#cordova-cli)
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
