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
```javascript
for(obj in arrayOfObjects){ 
  //... do something
}
```

##### Classes and inheritance
Actually in Javascript there is no such thing as class in the same meaning that is used in other programming languages like C#, C++, PHP or Python. It works differently in Javascript. You can create new objects that are based on other objects - this way you can implment inheritance and classes. To make it all work you have to heavily use object's **prototype**. Here you can see a very simple example of how it works: 
```javascript
//PERSON --- --- --- --- --- ---
var Person = function() {
  this.canSpeak = true;
};

Person.prototype.greet = function() {
  if (this.canSpeak) {
    console.log('Hello!');
  }
};

//EMPLOYEE --- --- --- --- --- ---
var Employee = function(name, title) {
  Person.call(this); //!!!
  this.name = name;
  this.title = title;
};

Employee.prototype = Object.create(Person.prototype); //!!!
Employee.prototype.constructor = Employee; //!!!

Employee.prototype.greet = function() {
  if (this.canSpeak) {
    console.log('Hello, I am ' + this.name + ', ' + this.title);
  }
};
```
In ECMAScript 2017 there was added **class** and **extends** keywords but this is just a syntactic sugar which is under the hood translated to the code that looks like the one above.

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
