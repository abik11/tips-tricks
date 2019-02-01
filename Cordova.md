# Cordova

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
