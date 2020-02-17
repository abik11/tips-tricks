## HTML and CSS
Both HTML and CSS are very easy to learn, but there are some more advanced topics or tricks that are not so obvious.

## Table of contents
* [Basic styling](#basic-styling)
* [Positioning](#positioning)
* [Forms](#forms)
* [Tables](#tables)
* [Paragraphs](#paragraphs)
* [CSS directives](#css-directives)
* [Stuff without Javascript](#stuff-without-javascript)
* [Advanced stuff](#advanced-stuff)

## Basic styling

### Border
Adding border is extremely simple:
```css
div {
    border: 1px solid #C7C7C7;
    border-radius: 3px;
}
```

### Shadow
Shadow can be added to text (**text-shadow**) or to the whole element (**box-shadow**):
```css
div {
    text-shadow: 0px 0px 8px #FFFFFF;
    box-shadow: inset 0px 0px 10px #000000, 0px 0px 8px #FFFFFF;
}
```
You have to specify x-offset, y-offset, blur and the shadow color. For the box shadow you can set both inner and outer shadow. If you will encounter problems with compatibility, you may also add prefixes: **-webkit-box-** and **-moz-box-**.<br />

### Gradient
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

## Positioning 

### Centered div
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

### Text centered vertically
```css
p {
    display:table-cell;
    vertical-align:middle;
}
```

### Div that doesn't take space
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

### Clear: both
```html
<div>
    <div style="float:left;">Na lewo</div>
    <div style="float:right;">Na prawo</div>
    <div style="clear:both;"></div>
    Other elements
</div>
```

## Forms

### Placeholder for selection
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

### Configuring textarea
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

### Autocomplete for input
```html
<input list="namelist" />
<datalist id="namelist">
   <option value="Albert Kozak">
   <option value="Alexander the Great">
   <option value="Jaimie Lannister">
</datalist>
```

### Color input
```html
<input type="color" value="#00FF00" />
```

### Date and time input
```html
<input type="date" min="1950-05-25" max="2050-07-29" value="2016-05-25" />
<br />
<input type="time" value="23:53:05" />
```
There are also other nice input types: week, month, datetime-local, number, range...

### Overwrite Google Chrome autofill style
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

## Tables

### Border or background for the whole table row
```css
table {
    border-collapse: collapse;
}

table tr {
    border: 1px gray solid;
}
```

### Automatic row numeration
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

## Paragraphs

### Text in columns
```css
p {
    column-count: 3;
    column-gap: 10px;
    column-rule: 1px solid black;
}
```

### Editable paragraph
```html
<p contenteditable="true">Lorem ipsum</p>
```

## CSS directives

### Adding custom fonts
```css
@font-face {
    font-family: myPrettyFont;
    src: url('./fonts/font1.ttf');
}

div { font-family: myPrettyFont; }
```

### Media queries
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

### Check if browsers supports given CSS properties
```css
@supports(transform:rotate(40deg)) { 
    div { background-color: green; }
}
```

### CSS styles for IE10+
If you want to target some CSS styles for IE10 and IE11, with `@media` you can check if the browser supports `-ms-high-contrast` property because it is only implemented in IE10+.
```css
@media (-ms-high-contrast: none), (-ms-high-contrast: active) {
    /* IE10+ only here */
}
```

### Calc function
Although it is not a directive, it is worth mentioning. It is an extremely handy and useful feature:
```css
div {
    background-color: red;
     width: calc((100% - 30% + 50px) / 2);  
}
```

### Variables
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

## Stuff without Javascript

### Drop down menu
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

### Tooltip
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

### Tabs
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

## Advanced stuff

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
