# Web development

* [Javascript](#javascript)
* [Libraries](#libraries)
* [Npm](#npm)
* [Useful links](#useful-links)

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

##### Delayed function
```javascript
var debounced = _.debounce(validateInput, 750);
debounced.cancel(), debounced.flush()
```

##### Setting functions intervals
```javascript
var throttled = _.throttle(someFunction, 1500);
```

##### Chaining lodash methods
```javascript
_.chain(users)
  .sortBy('age')
  .map(function(u){ return u.name + '/' + u.age })
  .head()
  .value()
```

##### Delete an array element of given index
```javascript
var numbers = [1, 2, 3, 4, 5];
_.remove(numbers, function(n, i){ return i == 2; });
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

### Delete files with long names
There is an amazing package available in npm - **rimraf**. It simply deletes files and directories without taking into consideration how long is its name. It is especially useful while working with npm on Windows to delete `node_modules` directory when needed.
```
npm install rimraf -g
rimraf .\node_modules
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
[Howler - Web Audio Library](https://goldfirestudios.com/blog/104/howler.js-Modern-Web-Audio-Javascript-Library)</br >
[Brain.js - Machine Learning for JS](https://harthur.github.io/brain/)<br />
[Anime.js -Animation](http://animejs.com/)<br />

#### Test data
[JSON test data](https://jsonplaceholder.typicode.com/)<br />
http://lorempixel.com/<br />

#### HTML Notations
http://learnjade.com/ <br />
http://html2jade.org/ <br />

#### CSS Preprocessors
[SASS Documentation](http://sass-lang.com/documentation/file.SASS_REFERENCE.html)<br />
[Sassmeister - SASS online editor](https://www.sassmeister.com/)<br />
[Stylus](http://stylus-lang.com/)<br />

#### Chrome
DevTools - chrome://inspect/<br />
Chrome URLs - chrome://about/<br />
