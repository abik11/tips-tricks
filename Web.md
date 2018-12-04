# Web development

* [Javascript](#javascript)
* [Useful links](#useful-links)

## Javascript

### Syntax
Some syntax construction or details in Javascript may not be so obvious for developers that are used to other languages, so it is nice to learn a little bit about that.

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
Actually in Javascript there is no such thing as class in the same meaning that is used in other programming languages like C#, C++, PHP or Python. It works differently in Javascript. You can create new objects that are based on other objects - this way you can implment inheritance and classes. To make it all work you have to heavily use object's **prototype**. Here you can see a very simple example of how it works: 
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
In Javascript there plenty of asynchronous operations. 

##### Promise
Promises are amazing. They are really amazing. There is no better way to handle asynchronous programming in Javascript.
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
Promises are getting more and more commmon and now they have became a real standard in Javascript. There is a new AJAX API called **fetch** which returns promises. See here an example:
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

### DOM
One of the most important use cases of Javascript is to work with Document Object Model - DOM.

## Useful links

#### General stuff
[MDN - Mozilla Developer's Network](https://developer.mozilla.org/en-US/docs/Web/API)<br />
[Npm documentation](https://docs.npmjs.com/about-npm/index.html)<br />
[Traversy Media - Amazing viedo tutorials on YouTube](https://www.youtube.com/user/TechGuyWeb/videos)<br />
[Tutoriale po polsku](http://www.polskifrontend.pl/)<br />
[Tutorials in English](http://tutorialzine.com/)<br />
[TodoMVC - helping you to choose correct web framework](http://todomvc.com/)<br />
[Responsive Patterns](http://bradfrost.github.io/this-is-responsive/patterns.html)<br />

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
[Brain.js - Machine Learning for Javascript](https://harthur.github.io/brain/)<br />

#### Test data
[JSON test data](https://jsonplaceholder.typicode.com/)<br />
http://lorempixel.com/<br />

#### Chrome
DevTools - chrome://inspect/<br />
Chrome URLs - chrome://about/<br />
