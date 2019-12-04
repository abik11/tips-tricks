# Web development
Web dev is an extremely vast topic. There are plenty of different things that you can mix and blend toegether to build modern web. Moreover web became so much integreated into our lives that it is a really useful to know web technologies. This is not a tutorial how to becaome a web developer, it is justa a bunch of tips and tricks or some interesting stuff that was more or less useful to me at my work, especially at the beginning.

#### Chrome shortcuts
* `F12` - debug tools
* `F11` - full screen
* `CTRL + N` - new window

* [Javascript](#javascript)
* [Libraries](#libraries)
* [Npm](#npm)
* [Webpack](#webpack)
* [Vue](#vue)
* [React](#react)
* [JQuery](#jquery)
* [DataTables](#datatables)
* [HTML and CSS](#html-and-css)
* [Appendix A - Google Maps Api](#appendix-a---google-maps-api)
* [Appendix B - CSS Animations](#appendix-b---css-animations)
* [Useful links](#useful-links)

Read also:
* [Cordova](https://github.com/abik11/tips-tricks/blob/master/Cordova.md)
* [DevExtreeme](https://github.com/abik11/tips-tricks/blob/master/DevExpress.md#devextreeme)
* [ASP.NET MVC](https://github.com/abik11/tips-tricks/blob/master/CSharp.md#aspnet-mvc)
* [MongoDB](https://github.com/abik11/tips-tricks/blob/master/DB.md#mongodb)
* [VS Code](https://github.com/abik11/tips-tricks/blob/master/W10+VS17+TFS.md#vs-code)

## Javascript

### Syntax
Some syntax construction or details in JS may not be so obvious for developers that are used to other languages, so it is nice to learn a little bit about that.

##### Check if a variable exists
This is extremely useful to know if a variable exists. You can do it more than one way:
```javascript
typeof var1 === 'undefined'
typeof(var1) === 'undefined' 
var1 === void 0
```

##### Foreach
**For ... in** loop can be used with arrays and objects:
```javascript
var obj = { a:1, b:2 };
for(property in obj){ 
  //... do something
}

var a = [1, 2, 3];
for(element in a){ 
  //... do something
}
```
If you want to iterate through arrays you can also use array's forEach method like this:
```javascript
fruits.forEach(fruit => console.log("Buy: " + fruit));
```

##### Classes and inheritance
Actually in JS there is no such thing as class in the same meaning that is used in other programming languages like C#, C++, PHP or Python. It works differently in JS. You can create new objects that are based on other objects - this way you can implment inheritance and classes. To make it all work you have to heavily use object's **prototype**. Here you can see a very simple example of how it works: 
```javascript
//PERSON --- --- --- --- --- ---
var Person = function(name) {
  this.canSpeak = true;
  this.name = name;
};

Person.prototype.greet = function() {
  if (this.canSpeak) {
    console.log('Hello! My name is ' + this.name);
  }
};

//EMPLOYEE --- --- --- --- --- ---
var Employee = function(name, title) {
  Person.call(this, name); // Call the parent class constructor!!!
  this.title = title;
};

Employee.prototype = Object.create(Person.prototype); // Attach parent class prototype to child class prototype!!!
Employee.prototype.constructor = Employee; // Set constructor to child class constructor !!!

Employee.prototype.greet = function() {
  if (this.canSpeak) {
    console.log('Hello, my name is ' + this.name + ' and my title is ' + this.title);
  }
};
```
In ECMAScript 2017 there was added **class** and **extends** keywords but this is just a syntactic sugar which is under the hood translated to the code that looks like the one above.

##### Static method
```javascript
Person.prototype.greet = function(){} //Non-static method 
Person.speak = function(){} //Static method
```

##### Default method parameter value 
```javascript
function func1(a, b){
  if (typeof(a) === 'undefined') a = 10;
  if (typeof(b) === 'undefined') b = 20;
  //...
}

// or:

function func2(a, b){
   if (a === void 0) a = 10;
   if (b === void 0) b = 20;
   //...
}
```

##### Object.assign
With `Object.assign` you can easily extend your existing objects with new properties. This may be often a quite useful!
```javascript
var a = { a:1, b:2, c:3 };
a = Object.assign(a, { d:4, e:5 });
```

### Asynchronous programming
In JS there plenty of asynchronous operations, so it is very important to know how to handle and build an asynchronous API.

##### Promise
Promises are amazing. They are really amazing. There is no better way to handle asynchronous programming in JS.
```javascript
var p =  new Promise(function(resolve, reject){
    obj.asyncMethod(result => resolve(result), error => reject(error));
});

p.then(result => {})
  .then(() => {})
  .then(() => {})
  .catch(e => console.log(e));
```
If you've got more than one promise you can wait for all of them or for the first to finish
```javascript
Promise.all([promise1, promise2])
  .then(results => {
    console.log(result[0]);
    console.log(result[1]);
  })
  .catch(e => console.log(e));

Promise.race([promise1, promise2])
  .then(result => console.log(result))
  .catch(e => console.log(e));
```
Promises are getting more and more commmon and now they have became a real standard in JS. There is a new AJAX API called **fetch** which returns promises. See here an example:
```javascript
function loadData(url) {
   return fetch(url)
      .then(result => result.json())
      .then(function (result) { return result; });
}

function loadUserData() {
   return loadData("/MyPortal/Users/");
}

loadUserData()
  .then(userData => console.log(userData));
```

##### Async and await
There are **async** and **await** keywords in JS that can make your asynchronous code even more readable. In simple words **await** just waits for the asynchronous function to end and **async** is used just to mark a function that will internally use **await**. See an example:
```javascript
var p =  new Promise(function(resolve, reject){
    obj.asyncMethod(result => resolve(result), error => reject(error));
});

var result = await p;
```
You can ofcourse use await with functions that return promises:
```javascript
function loadData(url) {
   return fetch(url)
      .then(result => result.json())
      .then(function (result) { return result; });
}

var data = await loadData("/MyPortal/Users/");
```
Or we could also use await to get the results of fetch, this time marking the *loadData* function as async:
```javascript
async function loadData(url) {
   return await fetch(url)
      .then(result => result.json())
      .then(function (result) { return result; });
}
```

### Data types

##### Arrays
```javascript
var tasks = [];
tasks.push({ text: 'New task' });
var task = tasks[0];
tasks.splice(tasks.indexOf(task), 1);

var fruits = [];
var appleExists = fruits.indexOf("apple") != -1; 
fruits.forEach(fruit => console.log("Buy: " + fruit));
```

##### Strings
```javascript
"Javascript".substring(4); //script

var str = "WELCOME";
str.replace(/w/i, "#");  //#ELCOME - i - case insensitive
str.replace(/w/g, "#");  //WELCOME - g - global
```

##### Numbers
```javascript
//Get random number from 0 to 100
Math.floor(Math.random() * 100);

var num = 4.253452334342;
Math.round(num * 100) / 100; //4.25
```

##### Leading zero for numbers
Here is an example of an extension method. The *pad* method is defined for the **Number** prototype, so for each object o this type you will be able to call the *pad* method. This is really nice to remember! 
```javascript
Number.prototype.pad = function (size) {
	var str = String(this);
	while (str.length < (size || 2)) { 
		str = "0" + str; 
	}
	return str;
}
```

##### Get week number
Here you can see another example of extension method.
```javascript
Date.prototype.getWeek = function(weekStartsOnMonday) {
	var offset = weekStartsOnMonday ? 0 : 1;
        var firstJanuary = new Date(this.getFullYear(), 0, 1);
        return Math.ceil((((this - firstJanuary) / 86400000) + firstJanuary.getDay() + offset) / 7) - 1;
}
```

##### Format data
Here you can see an example of data formatting using *pad* and *getWeek* extension methods:
```javascript
var d = new Date();
`${d.getFullYear()}-${(d.getMonth() + 1).pad(2)}-${d.getDate().pad(2)} W${d.getWeek(false).pad(2)} ${d.getHours().pad(2)}:${d.getMinutes().pad(2)}`
```

##### Parse JSON
```javascript
var text = '{name:"John", address:"Oak Street 28", phone:"600 521 997"}';
var obj = JSON.parse(text);
```

### DOM
One of the most important use cases of JS is to work with Document Object Model - DOM.

##### Add new elements
```javascript
var element = document.createElement("div");
div.className = "bg-red";
div.id = "user-name";

var textArea = document.createElement("textarea");
textArea.rows = 4;
textArea.cols = 30;

element.appendChild(textArea);
document.getElementById("container").appendChild(element);

element.appendChild(document.createTextNode("A text example");
```

##### Delete elements
```javascript
var element = document.getElementById("container");
var innerElement = element.getElementsByTagName("div")[0];
element.removeChild(innerElement);
```

##### Toggle an element
```javascript
function toggleElementById(elementId)
{
	var element = document.getElementById(elementId);
	var visibility = element.style.display; 
	if(visibility === "block")
	{
		element.style.display = "none";
	}
	else if(visibility === "none")
	{
		element.style.display = "block";
	}
}
```

##### Query Selector
This is the which you should get DOM elements in pure JS.
```javascript
var baseElement = document.querySelector(".navbar");
var menuButtons = baseElement.querySelector(".button");
```

##### Manage element's CSS classes
With the element's **classList** property you have access to all the CSS classes that an element is attached to.
```javascript
element.classList.add("new-class");
element.classList.remove("existing-class");
element.classList.contains("one-class");
element.classList.toggle("another-class");
```
With **toggle** method it is even easier to toggle an element. For example you can add the following CSS class:
```css
.hide {
	display: none;
}
```
and then just toggle this class:
```javascript
element.classList.toggle('hide');
```

##### Data properties
You can add in HTML tags your own data properties with **data-** prefix, for example:
```html
<div id="user" data-name="John" data-id="42341" data-my-custom-key="test"></div>
```
and then you can easily access them from JS:
```javascript
//pure JS:
var element = document.querySelector('#user');
var name = element.dataset.name;
element.dataset.myCustomKey = "test2";

//JQuery:
$('#user').data('my-custom-key');
$('#user').data('myCustomKey');
```

##### Submit a form from JS
```javascript
document.getElementsByTagName('form')[0].submit();
```

### Prompt dialog
`alert()` and `confirm()` are well known JS dialogs. But there is also `prompt()` which allows user to input some value. See how to use it:
```javascript
var name = prompt('Put your name:');
if (name === null)
    alert('Canceled!');
else if (name === '')
    alert('Name was not given!');
else
    alert(`Your name is: ${name}.`);
```

### Local web storage
If you have to store some little quantity of date on the client side, you can use local storage instead of cookies. 
```javascript
if(localStorage.views){
	localStorage.views = parseInt(localStorage.views) + 1;
}
else {
       localStorage.views = 1;
}
```
There is also session storage which you can use to store temporary data for the current session. The data inside of session storage will disapear when you will close your browser tab.
```javascript
if(sessionStorage.views){
      sessionStorage.views = parseInt(sessionStorage.views) + 1;
}
else {
       sessionStorage.views = 1;
}
```

### Timeouts and intervals
The difference between timeout and interval is that the first one runs only once and interval runs periodically after specified amount of miliseconds. Here you can see how to manage them - both are very useful and important:
```javascript
var t1 = window.setTimeout(function(){}, 1500); //this runs only once
var t2 = window.setInterval(function(){}, 1500); //this runs every 1500 miliseconds
window.clearTimeout(t1);
window.clearInterval(t2);
```
Timeout can be used to implement a quasi-sleep function in JS - if you want your code to wait for the given amount of time:
```javascript
setTimeout(function(){
     //Here you can put the code that will be run after 1 second...
}, 1000);
```
By the way, with promises it can be done slightly better I guess:
```javascript
function sleep(ms){
    return new Promise(resolve => {
        setTimeout(function(){ resolve(); }, ms);
    });
}

await sleep(4000);
console.log("test");
```

### Reload the page
If you have to reload the web app from JS, you can make it the following way:
```javascript
// 1
window.location.href = window.location.href;
// 2
location.reload(false); //reload from cache
location.reload(true); //reload from server
```

### Detect if a browser tab is visible
You can have many different tabs open in browser of course. If you want to check in your JS app if the tab is currently visible you can use: `document.visibilityState`. It can have one of two possible string values, simply:
* visible
* hidden

### Detect a browser or operating system
```javascript
var browser = navigator.userAgent;
var pattern = /Tizen/g;
var result = pattern.test(browser);
```

### Open link in a different browser (IE only)
```html
<script>
   function openURL() {
      var shell = new window.ActiveXObject("WScript.Shell");
      shell.run("Chrome http://google.com");
   }
</script>
<input type="button" onclick="openURL()" value="Click here" />
```
To make it work you have to enable ActiveX in Internet Explorer. Got to: ->Options ->Internet options ->Security ->Custom level ->ActiveX controls and plugins ->Initializing and executing ActiveX controls scripts not marked as safe to execute ->Turn on

### FormData
FormData can be used to send big amount of data or files to the server. Here you can see how to prepare FormData object: 
```javascript
var data = new FormData();
data.append("file", document.getElementById("upload-file").files[0])
data.append("key", "test1")
//send it with POST method
```
Here is an example of a controller method in C# which recieves the data from FormData:
```csharp
[HttpPost]
public ActionResult AddNewFile()
{
    string key = Request["key"];
    if(Request.Files.Count > 0)
    {
         Stream fileStream = Request.Files[0].InputStream;
         byte[] file = new byte[fileStream.Length];
         fileStream.Read(file, 0, (int)fileStream.Length);
     }
}
```

### Blob and FileReader
Blob represent raw date, raw bytes. It may be useful while working with File API or in few other use cases. Here you can see how to create a blob from string:
```javascript
var str = "abc";
var blob = new Blob([str], { type: 'plain/text' });
```
To read the data inside of a blob (or a file) you have to use **FileReader**, call its **readAsText** or **readAsBinaryString** which will execute **onloadend** event when blob will be read.
```javascript
var rdr = new FileReader();
var result;

rdr.onloadend = () => result = rdr.result;
rdr.readAsText(blob);
rdr.readAsBinaryString(blob);
```
You can also read a blob as a buffer if you prefer
```javascript
var rdr = new FileReader();
var buffer;

rdr.onloadend = () => buffer = rdr.result;
rdr.readAsArrayBuffer(blob);
var uintArray = new Uint8Array(buffer); //[97, 98, 99]
var text = String.fromCharCode.apply(null, uintArray); //"abc"
```

## Libraries
With the constant development of JS as a language and development platform itself, there is also a growing number of JS libraries which are really good. You can use them through CDN's, host locally or (usually preferable way) install with npm.

### Lodash
Lodash is quite simple but very powerful JS library that brings you many functions to work with collections, arrays and other data types. It has great documentation. If you have ever worked with C# and Linq, it is like a Linq for C# :)
```javascript
var users = [
  { 'user': 'alberto', 'age': 26, 'active': false },
  { 'user': 'paulina',   'age': 22, 'active': false }
];

_.every(users, { 'user': 'barney', 'active': false }); // => false
_.some([null, 0, 'yes', false], Boolean); // => true
_.some(users, ['age', 36]); // => true
_.includes([2,5,6], 3); // => false
_.groupBy(users, 'active'); // => { false: [{ 'user': 'alberto', ... }, { 'user': 'paulina', ... }] }
_.groupBy([6.1, 4.2, 6.3], Math.floor); // => { 4: [4.2], 6: [6.1, 6.3] }
_.groupBy(['one', 'two', 'three'], 'length'); // => { '3': ['one', 'two'], '5': ['three'] }
_.countBy(['one', 'two', 'three'], 'length'); // => { '3': 2, '5': 1 }
_.size(users); 
_.sortBy(users, ['age', 'user']);
_.orderBy(users, ['age', 'user'], ['desc', 'asc']);
_.shuffle([1,2,3,4]);
_.sample([1,2,3,4]);
_.map(users, 'user');
_.map(users, function(u){ return u.age * u.age });
_.filter(users, function(u){ return u.age > 25 });
_.filter(users, ['active', false]);
```

##### Delayed function
```javascript
var debounced = _.debounce(validateInput, 750);
debounced.cancel(), debounced.flush()
```

##### Setting functions intervals
```javascript
var throttled = _.throttle(someFunction, 1500);
```

##### Foreach
```javascript
_.forEach([1, 2], function(value){ ... });
_.forEach({ 'a':1, 'b':2 }, function(value, key){ ... });
```

##### Delete an array element of given index
```javascript
var numbers = [1, 2, 3, 4, 5];
_.remove(numbers, function(n, i){ return i == 2; });
```

##### Chaining lodash methods
```javascript
_.chain(users)
  .sortBy('age')
  .map(function(u){ return u.name + '/' + u.age })
  .head()
  .value()
```

##### Current date
```javascript
_.now()
```

### Axios
**Axios** is a very well known AJAX library. It does nothing more than just AJAX based on promises. In many cases it can be replaced with **fetch** API.

##### Simple GET and POST requests
```javascript
axios.get('/users?id=10')
    .then(response => console.log(response))
    .catch(error => console.error(error));
    
axios.post('/users', { id: 10 })
    .then(response => console.log(response))
    .catch(error => console.error(error));
```

##### Waiting for multiple axios promises
Just like there is **Promise.all** method, there is **axios.all** which works the same way:
```javascript
function getUserAccount() { return axios.get('/user/12345'); }
function getUserPermissions() { return axios.get('/user/12345/permissions'); }

axios.all([getUserAccount(), getUserPermissions()])
    .then(axios.spread((account, permissions) => { 
        //...
    }));
```

##### How to enable cross domain requests
```html
<meta http-equiv="Content-Security-Policy" 
      content="default-src * data: gap: https://ssl.gstatic.com 'unsafe-eval'; style-src 'self' 'unsafe-inline'; media-src *">
```

### Anime.js
There is a great JS library for animation called **Anime.js**. It has quite easy API, you can read more in the docs. The following example will animate all the divs with *box* class. Each div will be animated one second after other div animation started thanks to **delay** property. Also play and pause functions are attached to buttons.
```javascript
var animation = anime({
    targets: 'div.box',
    translateY: [
        { value: 200, duration: 500 },
        { value: 0, duration: 800 },
    ],
    rotate: {
        value: '1turn',
        easing: 'easeInOutSine'
    },
    delay: function(el, i, l){ return i * 1000 },
    autoplay: false,
    loop: true
});

document.querySelector('button.play').onclick = animation.play;
document.querySelector('button.pause').onclick = animation.pause;
```

## Npm
Npm is a package manager for JS. It is very common and you can find there thousands of different packages. Probably you will find there whatever you will need so it is really good idea to learn how to apply npm for your projects.

### Update node and npm
```
npm install -g n
npm install npm -g
```

### Proxy configuration for npm
This is a very common scenario that you will work behind some kind of a corporate proxy. In such case, downloading packages may be impossible if you won't configure proxy for npm correctly.
```
npm config set proxy http://DOMAIN%5Cuser.name:pass@proxy-address:8080
npm config set https-proxy http://DOMAIN%5Cuser.name:pass@aproxy-ddress:8080

npm config set strict-ssl false #sometimes you may need this
npm config set registry https://registry.npmjs.org/ #and this

git config http.proxy --global http://DOMAIN%5Cuser.name:pass@proxy-address:8080
git config https.proxy --global https.proxy http://DOMAIN%5Cuser.name:pass@proxy-address:8080
```
You can type the following URL in your browser to get proxy configuration: http://wpad/wpad.dat

##### URIError: URI malformed
If you see such error returned from npm, it is possible that you have an incorrect char in the proxy address. You can modify it in the `c:\users\my.user\.npmrc` file.

##### UNABLE_TO_VERIFY_LEAF_SIGNATURE
If you see the above error while executing npm install and you are behind the corporate proxy, run the following commands:
```
npm config set registry http://registry.npmjs.org/
npm config set strict-ssl false
```

### Delete files with long names
There is an amazing package available in npm - **rimraf**. It simply deletes files and directories without taking into consideration how long is its name. It is especially useful while working with npm on Windows to delete `node_modules` directory when needed.
```
npm install rimraf -g
rimraf .\node_modules
```

## Webpack
Webpack is a JS bundler, it allows you to divide your whole JS project into many small files that will be then joined toegether into a final JS file. It also bundles CSS and HTML files and with plugins it can work with almost any kind of web technology. It is a really amazing tool.<br />
See here an extremely simple **webpack** configuration file:
```javascript
var path = require('path');

module.exports = {
  entry: './src/js/index.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist')
  }
};
```
To make it work with **npm** you have to add it into scripts:
```javascript
{
    "scripts": {
        "build": "webpack -p"
    }
}
```
and to run it type `npm run build` in the console. Then for example you can use imports to divide your projects and structure it easily.
```javascript
// ./src/js/index.js:
import greet from './greet.js';
console.log("Here is the entry point!");
greet();

// ./src/js/greet.js:
function greet() {
    console.log('And I am imported from the other file!');
};
export default greet;
```

### Multiple entry points
It is possible to configure Webpack to have more than one entry point. Just remember that you will also have as many output JS files as many entry points you have defined. 
```javascript
entry: {
    bundle: "./src/js/index.js",
    vendor: "./src/js/vendorLib.js"    
}
output: {  
    path: path.join(__dirname, "./dist"),
    filename: "[name].js"
}
```

### Use Babel with Webpack
Babel is a tool that translate modern Javascript (ES2015 for example) into older versions to allow your code to be compatible with older browsers. It is a super nice feature which can be easily integrated with Webpack build process. Run the following command to install required Babel packages as dev dependencies:
```
npm i -D babel-core babel-loader babel-preset-es2015 babel-preset-stage-2 babel-plugin-transform-object-rest-spread
```
You can now configure Webpack to load Javascript files through **babel-loader**:
```javascript
{
    test: /\.js$/,
    exclude: /node_modules/,
    loader: 'babel-loader',
    options: {
        presets: ['es2015'],
	plugins: ['transform-object-rest-spread']
    }
}
```
which can be also written a bit differently if you prefer:
```javascript
{
    test: /\.js$/,
    exclude: /node_modules/,
    loader: 'babel-loader?presets[]=es2015&plugins[]=transform-object-rest-spread'
}
```

### Loading images
To load images through Webpack you should use **file-loader** plugin. To install it with **npm**, run the following command:
```
npm install --save-dev file-loader
```
Then you can use it inside of your Webpack configuration file to load images:
```javascript
webpack.config.js
{
    test: /\.(jpe?g|png|gif|svg)$/i,
    loader: 'file-loader',
        options: {
            name: '[name].[ext]',
            outputPath: 'img/'
        }
}
```
Also you should add the following line in your main JS file:
```javascript
require.context("../img/", true, /\.(jpe?g|png|gif|svg)$/i);
```
You can use this plugin to load other static resources, for example fonts.

##### Loading images and fonts in Cordova
In Cordova a web application is run in WebView and it tries to find images or fonts in `/android_assets/www/` where as default the files of a Cordova application are stored. To make Webpack replace the path you have to add **publicPath** property with `file:///android_asset/www/` as a value. See here an example:
```javascript
module: {
      rules: [
           {
              test: /\.(jpe?g|png|gif|svg)$/i,
              loader: 'file-loader',
              options: {
                 name: '[name].[ext]',
                 outputPath: 'img/',
                 publicPath: 'file:///android_asset/www/'
              }
           },
           {
              test: /\.(woff2?|ttf|eot|svg)$/,
              loader: 'file-loader',
              options: {
                 name: '[name].[ext]',
                 outputPath: 'fonts/',
                 publicPath: 'file:///android_asset/www/'
              }
           }
      ]
   }
```

### Add jQuery
If you need jQuery in your project you can add it in many different ways. If you don't need jQuery, but some CSS frameworks that you use need it (Bootstrap, Materialize) the best way to add jQuery is to provide it as a plugin. It is quite simple and you can use this method to add other libraries for example lodash or axios - they will be available in all your JS files, you will not have to import them every time.<br />
First you have to install the library with **npm**:
```
npm install jquery
```
or other package manger and then you can provide it as a plugin:
```javascript
var path = require('path');
var webpack = require('webpack');

module.exports = {
  entry: './src/js/index.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist')
  },
  plugins: [
  	new webpack.ProvidePlugin({
		jQuery: 'jquery',
  		$: 'jquery',
  		jquery: 'jquery'
  	})
  ]
};
```

## Vue
Vue.js is a modern, practical web front-end framework that allows you to quickly build well-structured modularized applications. It is quite easy to learn and very powerful when mixed with Webpack and Vuex (its state management library). Working with Vue.js is a real fun! 

### Handling forms

##### V-model
To create two-way binding with input tags you have to use **v-model** directive.
```html
<input v-model="message">
```

##### Multiple checboxes
```html
<input type="checkbox" id="name1" value="Albert" v-model="checkedNames">
<label for="name1">Albert</label>

<input type="checkbox" id="name2" value="Paulina" v-model="checkedNames">
<label for="name2">Paulina</label>

<br>
<span>Checked names: {{ checkedNames }}</span>
```
```javascript
data() {
    return {
      checkedNames: []
    }
}
```

##### Select
```html
<select v-model="selectedItem" @change="$emit('change-item', selectedItem)">
    <option value="" disabled selected hidden>Please select...</option>
    <option v-for="item in items" :value="item.Oid">{{item.Name}}</option>    
</select>
```
```javascript
data(){
    return {
        items: [],
        selectedItem: ''
    }
}
```

### Routing

##### Keep the component's state
If you will wrap **router-view** with **keep-alive** tags, it will keep the state of components between different routes, otherwise every time you will leave a route, its data will be lost.
```html
<keep-alive>
    <router-view></router-view>
</keep-alive>
```

##### Access URL parameters
If you route is for example `/user/:id`, than for the url `user/4` the value for **id** will be 4.
```javascript
data(){
   return {
       id = ''
   }
},
beforeRouteEnter (to, from, next) {
   next(vm => vm.id = to.params.id);
}
```

##### Pass route parameters as component's props
All you have to do to automatically pass route parameters as component's props is to add `props: true`:
```javascript
const router = new VueRouter({
    mode: 'history',
    base: __dirname,
    routes: [
        { path: '/item/:id', component: Item, props: true }
    ]
});
```

### Init component's properties with props
```javascript
props: ['initialCounter'],
data: function () {
  return { 
    counter: this.initialCounter 
  }
}
```

### Reset component's data
Functionality of component's data is encapsulated in mixin here:
```javascript
var ResetMixin = {
   methods: {
      reset() {
         Object.assign(this.$data, this.$options.data.call(this));
      }
   }
};
export default ResetMixin;
```
and then imported to the module:
```javascript
import ResetMixin from 'resetMixin.js'

export default {
    name: 'component-1',
    mixins: [ResetMixin],
    data(){
        return {
            prop1: false
        }
    }
}
```

### Event modifiers
Vue.js brings many different modifiers that allow you to control precisely the way you handle events. For example `.prevent` modifier will add `event.preventDefault()` instruction to the event handler. Here you can see how to aply modifier to an event:
```javascript
<button @submit.prevent="sendForm">Send</button>
```
There are also many modifiers connected with keys. For example if you want to execute someting when *enter* is pushed you can make it like that: `@keyup.13` or `@keyup.enter`. There are also other predefined buttons `.esc`, `.space`, `.tab` etc. Also you can define your own codes:
```javascript
Vue.config.keyCodes.f1 = 112;
```
You can also mix keys with other events, for example CTRL + click: `@click.ctrl` or two keys, CTRL + A: `@keyup.alt.65`. It is also possible to choose witch mouse button do you expect: `@click.left`, `@click.right`, `@click.middle`. There are some other things you can make and achieve with modifiers. If you want to know the details, read the [docs](https://vuejs.org/v2/guide/events.html#Event-Modifiers).

### 4 forms of v-for directive
The **v-for** directive is extremely useful and quite flexible. You can use in 4 ways:
* `v-for="item in objects"`
* `v-for="(value, key) in objects"`
* `v-for="(item, index) in objects"`
* `v-for="(value, key, index) in objects"`

### Computed properties

#### Binding CSS classes with computed property
Binding CSS through computed properties is very powerful and easy to use, see here an example:
```html
<div :class="componentClasses"><span>Text</span></div>
```
```javascript
data(){
    error: false,
    empty: true
},
computed: {
    componentClasses(){
        return {
	    error: this.error,
	    empty-data: this.empty
	}
    }
}
```

##### Computed property with getter and setter
```javascript
data(){
    return {
        value: 10,
	currency: 'zł'
    };
},
computed: {
    valueStr: {
        get: function(){ return `${this.value} ${this.currency}`; },
	set: function(newValue){ this.value = parseInt(newValue); }
    }
}
```

### Refs
Usually you will not have to access the DOM in Vue.js, but if you will ever have to you can use **refs**.
```html
<div ref="readText">Innet text</div>
<input type="text" ref="input" @change="onChange" />
```
```javascript
data() {
    return {
    	output: ''
    }
},
methods: {
    onChange: function(){
    	console.log(this.$refs.readText.innerText);
    	this.output = this.$refs.input.value;
    }
}
```

### Vuex

##### Access property from another module in Vuex
Imagine that you have a Vuex store with two modules: *tasks* and *users*, and you want to access a state property form *users* module inside of a getter in *tasks* module. You can make it easily through **rootState** parameter that can be passed to a getter as a thrid argument. See here an example:
```javascript
export default {
   namespaced: true,
   state: {
      dailyTasks: [
         { name: 'Task 1', time: '18:00', id: 1, status: 'undone', user: '' },
         { name: 'Task 2', time: '18:05', id: 2, status: 'undone', user: '' },
         { name: 'Task 3', time: '18:15', id: 3, status: 'undone', user: 'Albert' },
         { name: 'Task 3', time: '18:20', id: 4, status: 'undone', user: 'Paulina' }
      ]
   },
   getters: {
      currentUserTasks: (state, getters, rootState) => {
         return state.dailyTasks.filter(task => task.user == rootState.users.currentUser);
      }
   }
}
```

##### Vuex2.default is not a function
If you encounter the following error: `TypeError: (0 , _vuex2.default) is not a function` while working with Vue and Vuex, the possible reason is that your imports from Vuex are incorrect, for example:
* error: `import mapGetters from 'vuex';`
* correct: `import { mapGetters } from 'vuex';`

## React
ReactJS is a UI library to allow you to build better views and SPA (Single Page Applications), it is developed by Facebook and became an extremely popular library/framework used to build modern web applications. It is very fast by the way!

### Nice way to bind onchange event
```javascript
class MyComponent extends Component {
    constructor(props){
        super(props);
        this.state = {
            content: ""
        }
    }

    onChange = e => {
        this.setState({ [e.target.name]:e.target.value });
    }

    render(){
        return (
            <input type='text' name='content' 
                value={this.state.content} onChange={this.onChange} />
	);
    }
}
```
State property name (content) must be exactly the same as the name in the input tag to make it work.

## JQuery
JQuery is a library that allows you to write less javascript code that will be more portable among different browsers. Nowadays JQuery is not such a fundamental library as it was in the past, loosing the market with modern javascript frameworks like Vue, React or Angular, but it is still in use.

### Forms

##### Submitting a form
```javascript
$(".my-form").submit(function(event){ 
   event.preventDefault();
  
   $.ajax({
      type: "POST", 
      contentType: "application/json; charset=utf-8",
      url: "/users/setuser",
      data: JSON.stringify({ name: 'alberto' }),
      dataType: "json",
      error: function(jqXHR, textStatus, errorThrown){},
      success: functon(data){}
   });
});
```

##### Submitting a form when pushing enter
```javascript
$('body').keypress(function(event) {
     if (event.which == 13) {
          event.preventDefault();
          $('.send-button').click();
     }
});
```

##### File upload
```html
<input type="file" id="file" name="file">
```
```javascript
var inputFiles = $('#file').prop('files');
var fd = new FormData();

fd.append('imagefile', inputFiles[0]);
$.ajax({
    url: '/img/upload',
    type: 'POST',
    data: fd,
    //...
});
```

##### Uncheck a checkbox
```javascript
$("input").is(":checked").attr("checked", false);
```

### Get tag's name
```javascript
$(".box").prop("tagName");
```

### AJAX

##### Call an external API
```javascript
$.ajax({
    url: '...',
    dataType:  'jsonp',
    jsonpCallback: function (response) {
    	$.each(response.data.entries, function (i, item) {
        	$('.feed').append('<li>' + item.title + '</li>');
    	}); 
    }
});
```

##### Default values for AJAX
```javascript
$.ajaxSetup({
    url: '/myapp/default',
    contentType: 'GET',
    success: function(data){ $(".container").append(data) }
});

$.ajax({
    data: { user: 'alberto124' }
});
```

##### Cancel AJAX request
```javascript
var xhr = $.ajax({
    error: function(jqXHR, textStatus, errorThrown){
        if(textStatus == "abort"){}
    }
});

xhr.abort();
```

##### AJAX request timeout
```javascript
$,ajax({
    timeout: 3000,
    error: function(jqXHR, textStatus, errorThrown){
        if(textStatus == "error"){}
        else if(textStatus == "timeout"){}
    }
});
```

#### Reload whole page
```javascript
$.ajax({
      /*
       * AJAX configuration
       */
      success: function (response) {
         document.open();
         document.write(response);
         document.close();
      }
});
```

### Animations

##### Built-in
```javascript
$('.box').on('click', function(){
      $(this)
            .animate({ opacity: 0.8 }, 1500)
            .animate({ opacity: 0.0 }, 1500);      
});
```

##### Transit - plugin for JQuery
JQuery's **animate** function uses Javascript animation and not CSS. That means that it is executed in the browser's main thread and without acceleration. **Transit** is a plugin for JQuery that uses CSS transitions instead of Javascript to animate stuff, but not every property can be animated.
```javascript
$('.box').on('click', function(){
      $(this).transition({ x: "+=40px", color:"red", scale: [2, 1.5] }); 
});
```
You can learn more [here](https://ricostacruz.com/jquery.transit) and [here](https://ricostacruz.com/jquery.transit/source/).

### Blast
Blast is a plugin for JQuery that allows you to style text in many different ways.

##### Dividing text by words
```javascript
$(".text").blast({ delimiter: "word", aria: false }); // turn on
$(".text").blast(false); // turn off
```
HTML before division:
```html
<div id="text">Hello world!</div>
```
HTML after division:
```html
<div id="text"><span class="blast">Hello</span><span class="blast">world!</span></div>
```
Advanced options:
```javascript
$(".text").blast({
     delimiter: "word", //all, letter, word, sentence 
     tag: "div", 	//you can choose other tag than <span> to divide text
     customClass: "separate-word" //you can specify other css class name
});
```

##### Styling the searched phrase
Instead of **delimeter** use **search** and blast will apply the style only for the given phrase:
```javascript
$("#text").blast({ search: "banana", customClass: "search-phrase" });
```
```css
.searchPhrase { background-color: yellow; font-size: 18px; padding: 4px; }
```

### Error: a.indexof is not a function, after JQuery update
The following error can appear usually when you update JQuery to the newest version. For rexample the following expression from version 1.8 is incorrect:
```javascript
$(document).ready(function() { ... });
```
You should use event listener instead:
```javascript
$(document).on('ready', function() { ... });
```

## DataTables
DataTables is a fantastic plugin for JQuery that allow you to create super powerful tables! The only problem with this plugin is that it has so many feautures that sometimes it may be difficult to configure it exactly the way you want it. The basic usage of the plugin is very easy:
```html
<table class="my-table">
	<thead>
		<tr>
			<th>Col 1</th>
			<th>Col 2</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Data 1</td>
			<td>Data 2</td>
		</tr>
		<tr>
			<td>Data 3</td>
			<td>Data 4</td>
		</tr>		
	</tbody>
</table>
```
```javascript
$(document).ready(function(){ $('.my-table').DataTable(); });
```

##### Set default table options
```javascript
$.extend( $.fn.dataTable.defaults, {
    searching: false,
    ordering:  false,
    paging: false
} );
```

##### Change text for empty table
```javascript
$('.my-table').DataTable({ language: { emptyTable: "Brak danych w tabeli" } });
```

#### Modify change menu
```javascript
$('.my-table').DataTable({ "lengthMenu": [ [10, 25, -1], [10, 25, "All"] ] });
```

##### Cannot reinitialize datatable
The warning shown when you try to initialize the table which has already been initialized. Parameters of initialization can be only changed through the API.

### Filtering and searching

##### Set default filtering
```javascript
$('.my-table').dataTable( {
  "searchCols": [
    null, 			//Col 1 - No filter
    { "search": "phrase1" },	//Col 2
    null,                       //Col 3 - No filter
    { "search": "^[0-9]", "escapeRegex": false } //Col 4
  ]
} );
```

##### Disable filtering for given columns
```javascript
$('.my-table').DataTable({
      "columns": [ null, null, null, null, null, { "orderable": false }, { "orderable": false } ]
}); 
```
Here it will be impossible to filter the table by the 6th and 7th column.

##### Change text for search
```javascript
$('.my-table').DataTable({ language: { search: "Szukaj:" } });
```

##### Change style for search field
```css
div.my-table_filter input{
     /* Your CSS */
}
```
DataTables uses the name of your table to create some class names used for styling the components of the table (it uses [BEM](http://getbem.com/)).

##### Change text for no results
```javascript
$('.my-table').DataTable({ language: { zeroRecords: "Nie znaleziono wyników" } });
```

##### Adjust search field to Bootstrap
```javascript
$('.my-table').dataTables({
     initComplete: function () {
          $(".my-table_filter").addClass("form-group");
          $(".my-table_filter label").addClass("col-xs-12")
               .css("padding-left", "0px").css("padding-right", "0px");
          $(".my-table_filter input[type=search]").addClass("form-control")
               .attr("placeholder", "Search");
     }
});
```

### Sorting

#### Set default sorting
```javascript
$('.my-table').DataTable({ order: [[0, 'desc'], [3, 'asc'], [1, 'asc']] });
```

##### Turn off higlight for sorted column
```javascript
$('.my-table').DataTable({ orderClasses: false });
```
Instead of `false` you can also put a name of any CSS class that will be applied for the sorted column if you want to higlight it somehow.

##### Set icons for sorted columns
```css
.partialList th.sorting_desc:after{
   content: url("Images/sort_desc.png");
}
.partialList th.sorting_asc:after{
   content: url("Images/sort_asc.png");
}
.partialList th.sorting:after{
   content: url("Images/sortable.png");
}
.partialList th.sorting_desc:after,
.partialList th.sorting_asc:after,
.partialList th.sorting:after{
   display: inline;
   margin-left: 4px;
}
```

### Paging

##### Disable changing page length
```javascript
$('.my-table').DataTable({ "lengthChange" : false });
```

##### Set page length
```javascript
$('.my-table').DataTable({ pageLength: 20 });
$('.my-table').DataTable().page.len();		#get page length
$('.my-table').DataTable().page.len(15);	#set page length
```

##### Hide the information about the current page
```javascript
$('.my-table').DataTable({ "info": false });
```

##### Get the current page information
```javascript
$('.my-table').DataTable().page.info();
```
Here you can see an example of the object returned by this function:
```javascript
{
    "page": 1,
    "pages": 6,
    "start": 10,
    "end": 20,
    "length": 10,
    "recordsTotal": 57,
    "recordsDisplay": 57,
    "serverSide": false
}
```

##### Choose buttons for paging
The possible options for paging buttons are:
* numbers
* simple (Prev and Next)
* simple_numbers (Prev, Next and numbers)
* full (First, Prev, Next and Last)
* full_numbers (First, Prev, Next, Last and numbers)
```javascript
$('.my-table').DataTable({ "pagingType": "full_numbers" });
```

##### Change previous and next buttons
```javascript
$('.my-table').dataTable({
     initComplete: function () {
          configureNextPrevButtons();
     }
})
.on('draw.dt', function () {
     configureNextPrevButtons();
});

function configureNextPrevButtons() {
     $(".paginate_button.next")
          .html("<span class='glyphicon glyphicon-chevron-right'></span>");
     $(".paginate_button.previous")
          .html("<span class='glyphicon glyphicon-chevron-left'></span>");
}
```

## HTML and CSS
Both HTML and CSS are very easy to learn, but there are some more advanced topics or tricks that are not so obvious.

### Basic styling

##### Border
Adding border is extremely simple:
```css
div {
    border: 1px solid #C7C7C7;
    border-radius: 3px;
}
```

##### Shadow
Shadow can be added to text (**text-shadow**) or to the whole element (**box-shadow**):
```css
div {
    text-shadow: 0px 0px 8px #FFFFFF;
    box-shadow: inset 0px 0px 10px #000000, 0px 0px 8px #FFFFFF;
}
```
You have to specify x-offset, y-offset, blur and the shadow color. For the box shadow you can set both inner and outer shadow. If you will encounter problems with compatibility, you may also add prefixes: **-webkit-box-** and **-moz-box-**.<br />

##### Gradient
To add a gradient you may use the following CSS:
```css
div {
    background: #dddddd;    
    background: linear-gradient(#000000, #dddddd, #dddddd, #dddddd, #ffffff);
}
```
**background** is added only for the older browsers. Modern ones will display the gradient. You can also set the direction of the gradient, for example from left to right:
```css
div {
    background: #dddddd;    
    background: linear-gradient(to right, #000000, #ffffff);
}
```
Also other values are accepted, like **to left**, **to top**, **to bottom**. Also you can set the angle with degrees, for example **-45deg**. Those values are accepted in Chrome, in other browsers you should try **left**(from left to right) or **top**(from top to bottom). 

### Positioning 

##### Centered div
```css
.outer{ 
    width:100%;
    text-align:center;
}

.inner{ 
    display:inline-block;
}
```
```html
<div class="outer">
    <div class="inner">Centered div</div>
</div>
```

##### Text centered vertically
```css
p {
    display:table-cell;
    vertical-align:middle;
}
```

##### Div that doesn't take space
```html
<div class="wrapper">
    <div class="inner">
        This DIV is displayed, but it doesn't take space.
    </div>
</div>
```
```css
.wrapper { position: relative; }
.inner { 
    position: absolute;
    left: 0;
    top: 0;
    z-index: 1000;
}
```
Also you could manipulatre margins to negative values. Remember that you can use **z-index** only with the elements that have set **position** property.

##### Clear: both
```html
<div>
    <div style="float:left;">Na lewo</div>
    <div style="float:right;">Na prawo</div>
    <div style="clear:both;"></div>
    Other elements
</div>
```

### Forms

##### Placeholder for selection
```css
select:invalid { 
    color: gray; 
}
```
```html
<select id="week-select">
    <option value="" disabled selected hidden>Please select...</option>
</select>
```

##### Configuring textarea
To set placeholder for text area you have to use **placeholder** attribute. A very useful attribute is also **rows** which allows you to set the number of displayed rows.
```html
<textarea placeholder="Type your comment..." rows="5"></textarea>
```
With CSS you can disable resizing:
```css
textarea {
    resize:none;
    resize:vertical;
}
```

##### Autocomplete for input
```html
<input list="namelist" />
<datalist id="namelist">
   <option value="Albert Kozak">
   <option value="Alexander the Great">
   <option value="Jaimie Lannister">
</datalist>
```

##### Color input
```html
<input type="color" value="#00FF00" />
```

##### Date and time input
```html
<input type="date" min="1950-05-25" max="2050-07-29" value="2016-05-25" />
<br />
<input type="time" value="23:53:05" />
```
There are also other nice input types: week, month, datetime-local, number, range...

##### Overwrite Google Chrome autofill style
```css
input:-webkit-autofill, input:-webkit-autofill:hover, input:-webkit-autofill:focus, 
textarea:-webkit-autofill, textarea:-webkit-autofill:hover, textarea:-webkit-autofill:focus,
select:-webkit-autofill, select:-webkit-autofill:hover, select:-webkit-autofill:focus 
{
    -webkit-text-fill-color: green;
    -webkit-box-shadow: 0 0 0px 1000px #000 inset;
    transition: background-color 5000s ease-in-out 0s;
}
```

### Tables

##### Border or background for the whole table row
```css
table {
    border-collapse: collapse;
}

table tr {
    border: 1px gray solid;
}
```

##### Automatic row numeration
```html
<table>
    <tr><td>Header 1</td><td>Header 2</td></tr>
    <tr><td>A</td><td>B</td></tr>
    <tr><td>C</td><td>D</td></tr>
</table>
```
```css
:root{
  --row-counter-margin: 14px;
}

table {    
    /* Reset CSS row counter */
    counter-reset: rowNumber;
}  
table tr:not(:first-child) {    
    /* Skip header row from counter */
    counter-increment: rowNumber;
}
table tr:first-child td:first-child::before {
    margin-left: var(--row-counter-margin);
    margin-right: var(--row-counter-margin);
    content: '-';
}
table tr:not(:first-child) td:first-child::before {
    /* Count rows */
    margin-left: var(--row-counter-margin);
    margin-right: var(--row-counter-margin);
    content: counter(rowNumber);
}
```

### Paragraphs

##### Text in columns
```css
p {
    column-count: 3;
    column-gap: 10px;
    column-rule: 1px solid black;
}
```

##### Editable paragraph
```html
<p contenteditable="true">Lorem ipsum</p>
```

### CSS directives

##### Adding custom fonts
```css
@font-face {
    font-family: myPrettyFont;
    src: url('./fonts/font1.ttf');
}

div { font-family: myPrettyFont; }
```

##### Media queries
Example:
```css
@media screen and (orientation: landscape) and (max-width: 760px){}
```
* media types: all, screen, print, speech
* orientation: landspace, portrait  
* viewport's width (browser): min-width, max-width
* screen width: min-device-width, max-device-width

You can also use media queries to specify separate CSS stylesheet for given resolution:
```html
<link rel="stylesheet" media="mediatype screen and max-width(100px)" href="small.css">
```

##### Check if browsers supports given CSS properties
```css
@supports(transform:rotate(40deg)) { 
    div { background-color: green; }
}
```

##### CSS styles for IE10+
If you want to target some CSS styles for IE10 and IE11, with `@media` you can check if the browser supports `-ms-high-contrast` property because it is only implemented in IE10+.
```css
@media (-ms-high-contrast: none), (-ms-high-contrast: active) {
    /* IE10+ only here */
}
```

##### Calc function
Although it is not a directive, it is worth mentioning. It is an extremely handy and useful feature:
```css
div {
    background-color: red;
     width: calc((100% - 30% + 50px) / 2);  
}
```

##### Variables
Variables are also not directives but they are as much (if not more) useful as other instructions of CSS language. To define variables you have to put them in **:root** section:
```css
:root {
    --default-div-width: 400px;
}
```
And later you can use them with **var** function:
```css
div {
    var(--default-div-width);
}
```

### Stuff without Javascript

##### Drop down menu
It is possible to make a simple drop down menu with just HTML and CSS. Here a very simple example:
```html
<ol>
    <li>
	<span>Menu 1</span>
        <ul>
            <li>Sub menu 1</li>
            <li>Sub menu 2</li>
        </ul>
    </li>
    <li>
        <span>Menu 2</span>
        <ul>
            <li>Sub menu 3</li>
            <li>Sub menu 4</li>    
        </ul>
    </li>
</ol>
```
```css
ol > li > ul { display:none; }
ol > li:hover > ul { display:block; }
```

##### Tooltip
```html
<div class="tooltip">Show tooltip<div class="tooltip-text">Tooltip content</div></div>
```
```css
.tooltip { 
  position:relative; 
  display:inline-block; 
}
.tooltip .tooltip-text { 
  visibility:hidden; 
  position:absolute; 
  z-index:1; 
}
.tooltip:hover .tooltip-text { 
  visibility:visible; 
}
```

##### Tabs
```html
<a href="#tab1">Tab 1</a>
<a href="#tab2">Tab 2</a>
<a href="#tab3">Tab 3</a><br>
<span id="tab1" class="tab">Target 1</span>
<span id="tab2" class="tab">Target 2</span>
<span id="tab3" class="tab">Target 3</span>
```
```css
.tab { display: none; }
:target { display: block; }
```

### Meter and progress
Since HTML 5 there are many great features added, but some of them are not so well known. A nice new thing are **meter** and **progress** markups:
```html
<progress value="70" max="100">70%</progress>
<meter low="60" high="85" max="100" value="70">70</meter>
```

### Clipping
With clipping functionality you can achieve some interesting effects that was immpossible to achieve or required a lot ugly code to do. For example to add an image to the border is very easy:
```html
<div class="border-with-image">This div will have a nice border with an image :)</div>
```
```css
.border-with-image {
    border: solid 40px black;
    border-image: url('https://cdn.newsapi.com.au/image/v1/fb10274aebea980a0dfc0c6aaadfe950') 10% round;
}
```
Here is an example of real clipping. You can see how to clip an image or a div:
```html
<img class="clip" src="https://cdn.newsapi.com.au/image/v1/fb10274aebea980a0dfc0c6aaadfe950" />
<div class="clip">This will be a triangle</div>
```
```css
div.clip {
    background-color: red;
    width: 400px;
    height: 400px;
}
.clip {
    clip-path: polygon(50% 50%, 0% 100%, 100% 100%);
}
```
Also other shapes can be used to clip, for example a circle or an elipse: `clip-path: ellipse(90% 70% at 0% 50%)`. You can also set the outer shape of the element with **shape-outside**:
```css
div {
    shape-outside: ellipse(90% 70% at 0% 50%);
    shape-margin: 2em;
}
```

##### Old way of doing triangles
With clipping you can make triangles very easily, before it was a bit more tricky. Here you can see how to make - it is a nice example to understand in depth how borders work:
```css
div {
   width: 0px; 
   height: 0px;
   border-width:  0px 30px 50px 30px;
   border-color: transparent transparent green transparent;
   border-style: solid;   
}
```

### Add app to homescreen in Android
->Open URL in Chrome ->Options ->Add to homescreen<br />
You can add the following markups in the **head** section:
```html
<meta name="mobile-web-app-capable" content="yes">
<meta name="viewport" content="width=device-width, initial-scale=0.85, user-scalable=no" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />  
```
Also you can attach **manifest.json** to the app to configure how the application and its icon on the homescreen will be displayed.
```html
<link rel="manifest" href="~/App_Data/manifest.json">
```
```javascript
{
   "name": "Web App Mobile",
   "icons": [
      {
         "src": "...",
         "sizes": "192x192",
         "type": "image/png",
      }
   ],
   "start_url": "index.html",
   "display": "standalone",
   "orientation": "portrait"
}
```
Read more [here](https://developer.chrome.com/multidevice/android/installtohomescreen).

## Appendix A - Google Maps Api
If you want to learn and test the API you can add it to your HTML template like this:
```html
<div id="google-map"></div>
<script src="https://maps.googleapis.com/maps/api/js?callback=myMap"></script>
```
where **myMap** is the name of the function that will be responsible for the map configuration. The basic configuration of the map that will allow you display the map might look like here:
```javascript
function myMap(){
     var mapCanvas = document.getElementById("google-map");
     var mapOptions = {
          center: new google.maps.LatLng(51.508742, -0.120850),
          zoom: 5, 					// 0 - the lowest zoom
          mapTypeId: google.maps.MapTypeId.ROADMAP 	// ROADMAP, SATELLITE, HYBRID, TERRAIN
     }
     var map = new google.maps.Map(mapCanvas, mapOptions);
}
```

### Markers
Markers are easy way to mark some place on the map. They are built in the API and you can configure quite many properties.

##### Animated marker
```javascript
var marker = new google.maps.Marker({
    position: position,
    animation: google.maps.Animation.BOUNCE	// BOUNCE, DROP
});
marker.setMap(map);
```

##### Icon in place of marker
```javascript
var marker = new google.maps.Marker({
    position: position,
    icon: 'icon.png',
    draggable: true	// optional
});
marker.setMap(map);
```

##### Open information window on click
```javascript
var infowindow = 
      new google.maps.InfoWindow({
            content: 'Latitude: ' + location.lat() + '<br>Longitude: ' + location.lng()
      });

google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map, marker);
});
```

##### Remove events
```javascript
var listener = google.maps.event.addListener(marker, 'click', function() {});
google.maps.event.removeListener(listener);
```

##### Get current position of marker
```javascript
var pos = marker.getPosition();
```

##### Add marker on click
This is a nice example that will add a new marker on the map in the place where you will click and additionally it will open info window associated with the marker that will show the latitude and longitude. Moreover if you will click on the marker, it will be deleted.
```javascript
google.maps.event.addListener(map, 'click', function(event) {
     placeMarker(map, event.latLng);
});
	
function placeMarker(map, location) {
     var marker = new google.maps.Marker({
          position: location,
          map: map,
     });
		 
     var infowindow = new google.maps.InfoWindow({
          content: 'Latitude: ' + location.lat() + '<br>Longitude: ' + location.lng()
     });
     infowindow.open(map, marker);
		 
     google.maps.event.addListener(marker, 'click', function(event){
          marker.setMap(null);
     });
}
```
To delete a marker, the following line is used:
```javascript
marker.setMap(null);
```

### Drawing shapes
Sometimes markers are not enough to present some concepts on the map. But it is possible to draw any kind of shape.

##### Line
Line is the simplest shape you can draw.
```javascript
var flightPath = new google.maps.Polyline({
    path: [rome, amsterdam, london],
    strokeColor: "#0000FF",
    strokeOpacity: 0.8,
    strokeWeight: 2
});
flightPath.setMap(map);
```

##### Polygon
Polygon has the same properties as line with **fillColor** and **fillOpacity** additionaly.
```javascript
var flightPath = new google.maps.Polygon({
    path: [rome, amsterdam, london],
    strokeColor: "#0000FF",
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: "#0000FF",
    fillOpacity: 0.4
});
flightPath.setMap(map);
```

##### Circle
Circle has the same properties as Polygon but instead of defining the array of points (**path**), you define the center of the circle and radius in meters.
```javascript
var circle = new google.maps.Circle({
    center: new google.maps.LatLng(58.983991,5.734863),
    radius: 50000,
    strokeColor: "#0000FF",
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: "#0000FF",
    fillOpacity: 0.4,
    editable: true 		// optional
});
circle.setMap(map);
```

##### Rectangle
```javascript
var area = new google.maps.Rectangle({
    bounds: new google.maps.LatLngBounds(
        new google.maps.LatLng(17.342761, 78.552432),
        new google.maps.LatLng(16.396553, 80.727725)),
    strokeColor: "#0000FF",
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: "#0000FF",
    fillOpacity: 0.4	
});
```

### Adjusting the map
There are many different things that can be adjusted on the map, from zoom and the center point up to colors and general styling.

##### Basic adjustments
* Zoom
```javascript
var zoom = map.getZoom();
map.setZoom(10);
```
* Center
```javascript
var center = map.getCenter();
map.setCenter(new google.maps.LatLng(51.508742, -0.120850));
```
* Tilt / angle<br />
You can set tilt only in **satelite** and **hybrid** mode and only with zoom higher than 18. Setting tilt to 0 will block the perspective:
```javascript
map.SetTilt(0);
```

##### Language
```html
<script src="https://maps.googleapis.com/maps/api/js?language=pl">
```

##### Changing map style
You can easily generate your own style [here](https://mapstyle.withgoogle.com/). Here you can see an example of how Google Maps style looks:
```javascript
var styles = [
    { "elementType": "geometry", 
      "stylers": [{ "color": "#242f3e" }]
    },
    { "elementType": "labels.text.fill", 
      "stylers": [{ "color": "#746855" }]
    },
    { "elementType": "labels.text.stroke", 
      "stylers": [{ "color": "#242f3e" }]
    },
    { "featureType": "administrative.locality"
      "elementType": "labels.text.fill", 
      "stylers": [{ "color": "#d59563" }]
    },
    { "featureType": "poi"
      "elementType": "labels.text.fill", 
      "stylers": [{ "color": "#d59563" }]
    },
    //...
];
```
There are many other objects that you can style, actually you can change everything. To add a style to the map you have to use **styles** property:
```javascript
var map = new google.maps.Map(mapCanvas, {
    center: { lat: 51.508742, lng: -0.120850 },
    zoom: 5,
    styles: styles
});
```

##### Adding style as a new map type
First create a map and specify another map type, for example *night*:
```javascript
var map = new google.maps.Map(mapCanvas, {
    center: { lat: 51.508742, lng: -0.120850 },
    zoom: 5,
    mapTypeControlOptions: {
        mapTypeIds: [ 'roadmap', 'satelite', 'hybrid', 'terrain', 'night' ]
    }
});
```
And than create a new map type:
```javascript
var nightMapType = new google.maps.StyledMapType(
    styles, 
    { name: "Night" }
);
```
and finally and the type to the map and set it:
```javascript
map.mapTypes.set('night', nightMapType);
map.setMapTypeId('night');
```

### Controls

##### Turn off useless controls
You can use the following properties in the map options:
```javascript
disableDefaultUI: true // turn off all controls

zoomControl: true,
scaleControl: true,                
streetViewControl: false,
mapTypeControl: false
```

##### Select map type control
```javascript
mapTypeControlOptions: { 
     style: google.maps.MapTypeControlStyle.DROPDOWN_MENU, 
     mapTypeIds: [ 
           google.maps.MapTypeId.ROADMAP,                                            
           google.maps.MapTypeId.TERRAIN 
     ] 
}
```
Button styles to choose are **DROPDOWN_MENU** and **HORIZONTAL_BAR**.

### Advanced
You can do much more with Google Maps, especially when it comes to showing the data on the map. Visualizing the information in the geographical context is a really nice use case for Google Maps and there are many different tools available.

##### Heatmap
To use heatmap functionality you have to use this URL: `https://maps.googleapis.com/maps/api/js?callback=myMap&libraries=visualization`. Then you have to prepare the data:
```javascript
var data = [new google.maps.LatLng(51.508742, -0.120850)]
var pointArray = new google.maps.MVCArray(data);
```
And apply the heatmap to the map with the data you have:
```javascript
heatmap = new google.maps.visualization.HeatmapLayer({ data: pointArray });
heatmap.setMap(map);
```
You can dynamically change heatmap configuration:
```javascript
var radius = heatmap.get('radius');
heatmap.set('radius', 20);

var opacity = heatmap.get('opacity');
heatmap.set('opacity', 0.2);

var gradient = heatmap.get('gradient');
heatmap.set('gradient', ['rgba(0,255,255,0)', 'rgba(0,255,255,1)', 'rgba(0,191,255,1)']);
```

##### Clustering markups
To allow markup clustering you have to include the following JS library: `https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js
`. Then you have to specify the array of markers that you want to cluster:
```javascript
var markerCluster = new MarkerClusterer
	(map, markers, { imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m' });
```

## Appendix B - CSS Animations
With CSS you can style elements and a lot of quite advanced visual effects, but of the most advanced things that you can do with modern CSS are animations. The general syntax or configuration of the animation is show here in the example:
```css
div.animated-element {
   border: 1px solid black;
   width: 50px;
   height: 50px;
   animation-name: animate-size; 
   animation-duration: 5s; 
   animation-iteration-count: infinite; 
   animation-timing-function: ease;
}

@keyframes animate-size { 
   0% { width: 200px; } 
   100% { width: 350px; } 
}
```
There are quite many things that you can set. The most important one is to define key frames with **@keyframes** directive, they will describe which properties will be changed and how. Other animation properties have many different meanings:
* **animation-iteration-count** - it allows you to set precisely how many iterations you want to play. If you will set it to **infinite**, the animation will never end.
* **animation-fill-mode** - it allows you to set what will be the end result of the animation. The element can *come back* to the final state if you will set it to **backwards** or it can stay in the final state of the animation if you will set it to **forwards**. 
* **animation-direction** - can be set to **normal** or **reverse** - to make the animation play from the end to the start.
* **animation-play-state** - if this property is set to **running** the animation is played, if it is set to **paused** the animation is stopped.
* **animation-timing-function** - allows you to set the way that animation reaches the final state, there are many different options like **ease**, **linear**, **ease-in**, **ease-out** or **cubic**.

You can write animation properties in a much shorter way:
```css
div.animated-element {
    animation: animate-size 5s infinite ease;
}
```

### Performance
To improve animation performance you can add **will-change** property and put them the names of properties that will be animated. It doesn't guarantee that you animation will run faster but it can help the browser.
```css
div {
    will-change: transform, opacity;
    animation: rotation-fade 4s infinite ease;
}

@keyframes rotation-fade {
    0% {
        transform: translate(0px, 0px) rotate(0deg) scale(1);
        opacity: 1;
    }
    100% {
        transform: translate(300px, 50px) rotate(360deg) scale(3);
        opacity: 0;
    }
}
```
Also it is good to know that animating some properties is much slower than others. Website rendering is divided into 3 main phases which are run one after another in the following order:
* Layout (width, height, margin, padding, top, left, display...)
* Paint (box-shadow, border-radius, background, color, visibility...)
* Composite Layers (transform, opacity, filters)

If a change in some property requires to run the first phase, all other will also be executed. So the cheapest animations are those which animate properties that only require to run the last (Composite) phase of rendering.<br />
Different browsers treat properties differently but in general **transform** and **opacity** are among those which only require to the Composite phase, so they guarantee the best performance of the animation. If you want to know details about which property requires rendering in which phase go [here](https://csstriggers.com). Moreover, what is worth mentioning, CSS Composite layer-level animations are calculated by separate GPU thread which is additional performance boost (Javascript animations are calculated by main browser thread).

### Transform
With **transform** property you can do a few operations: translate(x,y), translateX, translateY, scale(x, y), scaleX, scaleY, rotate, skewX, skewY. It is of course possible to mix them:
```css
.box {
    transform: translate(300px, 50px) rotate(45deg) scale(2.5);
}
```
Sometimes it may be useful to change the center of transformation. By default it is the central point of the element (50%, 50%):
```css
.box {
    transform: translate(300px, 50px) rotate(45deg) scale(2.5);
    transform-origin: 0% 0%; --top left corner
}
```

### Transition
Transitions are special kind of animations. They are allow you to change the CSS property smoothly from one value to another. For example if you define a width of an element and another width on **:hover** with transition, the change of the width will be smoothly animated. It is an extremely useful feature.
```css
a { 
    width: 100px;
    transition: width 2s; 
}
a:hover { 
    width: 500px; 
}
```

### 3D animations
To be able to animate elements in 3 dimensions you have to add **perspective(0px)** to **transform**. 3D animations are not as easy as 2D, but with some practice you can achieve stunning effects! See here a very simple example of 3D rotation around Y-axis:
```css
.box {
  width: 30px;
  height: 30px;
  background-color: red;
  animation: 3d-rotation 3s infinite;
}

@keyframes 3d-rotation {
  0% { transform: perspective(0px) rotateY(0); }
  100% { transform: perspective(0px) rotateY(360deg); }
}
```
You can hide the *back* of the element wit **backface-visibility** property set to **hidden**. Also for animation of transparent elements you may need to use `transform-style: preserve-3d`.

##### Movement over the circle
You can simply achieve a movement of the element over the circle with just manipulating the central point of the animation. Here there is added 10px distance from the center of animated element, thanks to that it is rotating on the circle of 10px radius.
```css
.box {
  width: 30px;
  height: 30px;
  background-color: red;
  animation: 3d-rotation 3s infinite;
  transform-origin: 50% 50% 10px;
}

@keyframes 3d-rotation {
  0% { transform: perspective(0px) rotateY(0); }
  100% { transform: perspective(0px) rotateY(360deg); }
}
```

##### Movement around the vector
You can make an animation not only in the X, Y and Z axis. You can also set your preferable vector for the animation with **rotate3d** transformation:
```css
.box2 {
  width: 30px;
  height: 30px;
  background-color: red;
  animation: a12 3s infinite;
}

@keyframes vector-animation {
  0% { transform: perspective(0px) rotate3d(1,1,0,0deg); }
  100% { transform: perspective(0px) rotate3d(1,1,0,360deg); }
}
```
CSS animations are really powerful.

### Animate.css
There are some CSS libraries that work with CSS animations, one of them (which is really great!) is **animate.css**. It defines quite many classes, which are nice to use to show or hide some elements. It is very easy to use!
```html
<h1 class="animated infinite bounce">Big text animated infinitely</h1>
<h2 class="animated bounce">Not such a big text animated just once</h2>
```

##### Animate.css + JQuery
You can add a simple JQuery function that will allow you to add animate.css classes easily and dynamically:
```javascript
$.fn.extend({
    animateCss: function (animationName) {
        var animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
        this.addClass('animated ' + animationName).one(animationEnd, function() {
            $(this).removeClass('animated ' + animationName);
        });
    }
});

$('.box').animateCss('flash');
```

## Useful links

#### General stuff
[MDN - Mozilla Developer's Network](https://developer.mozilla.org/en-US/docs/Web/API)<br />
[Npm documentation](https://docs.npmjs.com/about-npm/index.html)<br />
[Traversy Media - Amazing viedo tutorials on YouTube](https://www.youtube.com/user/TechGuyWeb/videos)<br />
[Tutoriale po polsku](http://www.polskifrontend.pl/)<br />
[Tutorials in English](http://tutorialzine.com/)<br />
[TodoMVC - helping you to choose correct web framework](http://todomvc.com/)<br />
[Responsive Patterns](http://bradfrost.github.io/this-is-responsive/patterns.html)<br />
[Google Dev Web Fundamentals](https://developers.google.com/web/fundamentals/)<br />
[Callback Hell](http://callbackhell.com/)<br />
[Nice comparison of React and Vue](https://medium.com/javascript-in-plain-english/i-created-the-exact-same-app-in-react-and-vue-here-are-the-differences-e9a1ae8077fd)<br />
[Javascript Orientado a Objetos, ES6+, Webpack y LocalStorage - español](https://www.youtube.com/watch?v=yxT6ylPM7uM)<br />
[Web APIs You Probably Didn't Know Existed](https://youtu.be/EZpdEljk5dY?t=407)<br />
[Thanos Snap Effect](https://www.youtube.com/watch?v=fM791m4A_Pk)<br />

#### Online editors
<https://codesandbox.io/s/><br />
<https://jsbin.com/><br />

#### Webpack
[Webpack Tutorial](https://tutorialzine.com/2017/04/learn-webpack-in-15-minutes)<br />
[Wepback Video Tutorial - Ihatetomatoes](https://www.youtube.com/watch?v=JdGnYNtuEtE&list=PLkEZWD8wbltnRp6nRR8kv97RbpcUdNawY&index=1)<br />
[Webpack Video Tutorial - Academind](https://www.youtube.com/watch?v=GU-2T7k9NfI&list=PL55RiY5tL51rcCnrOrZixuOsZhAHHy6os)<br />
[Webpack config example](https://github.com/vuejs-templates/webpack-simple/blob/master/template/webpack.config.js)<br />
[How to integrate Webpack into VS2015](https://sochix.ru/how-to-integrate-webpack-into-visual-studio-2015/)<br />

#### Javascript libraries
[Axios - AJAX Library](https://github.com/mzabriskie/axios)<br />
[Axios Tutorial](https://alligator.io/vuejs/rest-api-axios/)<br />
[Lodash](https://lodash.com/)<br />
[Dexie - IndexedDB Wrapper](https://dexie.org/)<br />
[Chart.js - Charts based on canvas tag](https://www.chartjs.org/)<br />
[CamanJS - Image Manipulation Library](http://camanjs.com/)<br />
[Anime.js -Animation](http://animejs.com/)<br />
[Howler - Web Audio Library](https://goldfirestudios.com/blog/104/howler.js-Modern-Web-Audio-Javascript-Library)</br >
[Brain.js - Machine Learning for JS](https://harthur.github.io/brain/)<br />
[Zepto - lighter jQuery](http://zeptojs.com/)<br />
[DataTables - great JQuery plugin for working with tables](https://datatables.net/reference/index)<br /> 
[html2canvas](https://html2canvas.hertzen.com/)<br />

#### Vue
[Vue.js docs](https://vuejs.org/v2/guide/)<br />
[Vue.js tutorial for beginners](https://www.youtube.com/watch?v=z6hQqgvGI4Y)<br />
[Vuex tutorial for beginners](https://www.youtube.com/watch?v=2CSr2vBApSI&list=PL55RiY5tL51pT0DNJraU93FhMzhXxtDAo)<br />
[Vue.js feed - tutorials](https://vuejsfeed.com/)<br />
[7 Secret Patterns in Vue](https://www.youtube.com/watch?v=7YZ5DwlLSt8)<br />
[Animating Vue](https://www.youtube.com/watch?v=Vp37fWKOlV4)<br />
[How to encapsulate common functionality in Vuejs?](https://laracasts.com/discuss/channels/vue/how-to-encapsulate-common-functionality-in-vuejs)<br />
[Watch for Vuex State changes!](https://dev.to/viniciuskneves/watch-for-vuex-state-changes-2mgj)<br />
[Vue I18n](http://kazupon.github.io/vue-i18n/)<br />
[Vuetify](https://vuetifyjs.com/)<br />
[Vue components for Bulma](https://buefy.github.io/)<br />

#### React
[React Developer Roadmap](https://github.com/adam-golab/react-developer-roadmap)<br />
[Classnames](https://github.com/JedWatson/classnames)<br />
[Egghead Redux Cheat Sheet](https://github.com/linkmesrl/react-journey-2016/blob/master/resources/egghead-redux-cheat-sheet-3-2-1.pdf)<br />

#### Test data
[JSON test data](https://jsonplaceholder.typicode.com/)<br />
[JSON editor](http://jsoneditoronline.org/)<br />
http://lorempixel.com/<br />

#### HTML Notations
http://learnjade.com/ <br />
http://html2jade.org/ <br />

#### CSS Preprocessors
[SASS Documentation](http://sass-lang.com/documentation/file.SASS_REFERENCE.html)<br />
[SASS online editor](https://www.sassmeister.com/)<br />
[LESS online editor](http://less2css.org/)<br />
[Stylus](http://stylus-lang.com/)<br />

#### CSS frameworks and libraries
[Materialize](https://materializecss.com/)<br />
[Bootstrap](https://getbootstrap.com/)<br />
[Bootswatch - free themes for Bootstrap](https://bootswatch.com/)<br />
[Bulma](https://bulma.io/)<br />
[Tent CSS](https://css.sitetent.com/index.html)<br />
[Metro](https://metroui.org.ua/)<br />
[Animate.css](https://github.com/daneden/animate.css)<br />
[Importing animate.css in Vue.js](https://gist.github.com/chris-schmitz/f6dd6aa471113ad07ae83cced3e71d69)<br />
[Pure CSS Image Hover Effect Library](http://imagehover.io/)<br />

#### HTML and CSS
[Graphics on the Web](https://developer.mozilla.org/en-US/docs/Web/Guide/Graphics)<br />
[Sara Soueidan's tutorials](https://www.sarasoueidan.com/blog/)<br />
[CSS Transforms](https://css-tricks.com/almanac/properties/t/transform/)<br />
[9 Incredible CodePen Demos](https://davidwalsh.name/incredible-codepen-demos)<br />
[21 niesamowitych projektów - Polish](https://devcorner.pl/21-niesamowitych-projektow-wykonanych-css/)<br />
[10 Stunning CSS 3D Effects](https://redstapler.co/10-stunning-css-3d-effect-must-see/?fbclid=IwAR0vbGpNIFxiICIT0c7L3OJQjeHUDMvh-eR8o1GOWLf0E8nMH3SVZzrG2_M)<br />
[Awwwards](https://www.awwwards.com/)<br />
[CSS Filters](http://html5-demos.appspot.com/static/css/filters/index.html)<br />
[Cubic curves generator](http://cubic-bezier.com/)<br />
[Clip-path generator](http://bennettfeely.com/clippy/)<br />
[Loader generator](http://loading.io/)<br />
[Gradient generator](http://www.colorzilla.com/gradient-editor/)<br />
[uiGradients](https://uigradients.com)<br />

#### Icons
[Flag icons](http://www.iconarchive.com/show/flag-icons-by-gosquared.1.html)<br />
[Flag icons 2](http://www.freeflagicons.com/)<br />
[Rounded flag icons](https://www.flaticon.com/packs/countrys-flags)<br />
[Material icons](https://material.io/tools/icons/?style=baseline)<br />
[Font Awesome](https://fontawesome.com/icons)<br />
[RPG-Awesome](http://nagoshiashumari.github.io/Rpg-Awesome/)<br />

#### Images
[Unsplash](https://unsplash.com/)<br />
[Freeimages - former sxc.hu](https://www.freeimages.com/)<br />

#### Maps
[Google Maps Tutorial](https://developers.google.com/maps/documentation/javascript/tutorial)<br />
[Google Maps Style Wizard](https://mapstyle.withgoogle.com/)<br />
[Stylowanie mapy - Polish](https://www.youtube.com/watch?v=yTnmWXgcFi8)<br />
[Google Geocode Api - tutorial](https://www.youtube.com/watch?v=pRiQeo17u6c)<br />
[Mapbox GL](https://docs.mapbox.com/mapbox-gl-js/api/)<br />

#### SVG
[Snap.svg](http://snapsvg.io/)<br />
[Raphaël](https://dmitrybaranovskiy.github.io/raphael/)<br />
[SVG Visual Cheat Sheet](http://www.cheat-sheets.org/own/svg/index.xhtml)<br />
[A Guide to SVG Animations (SMIL)](https://css-tricks.com/guide-svg-animations-smil/)<br />
[How SVG Line Animation Works](https://css-tricks.com/svg-line-animation-works/)<br />
[SVG Tips](https://coderwall.com/t/svg/popular)<br />

#### Chrome
DevTools - chrome://inspect/<br />
Chrome URLs - chrome://about/<br />
Turn off saving passwords in Chrome - chrome://settings/passwords<br />
