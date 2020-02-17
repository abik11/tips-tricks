## JQuery
JQuery is a library that allows you to write less javascript code that will be more portable among different browsers. Nowadays JQuery is not such a fundamental library as it was in the past, loosing the market with modern javascript frameworks like Vue, React or Angular, but it is still in use.

## Table of contents
* [Forms](#forms)
* [AJAX](#ajax)
* [Animations](#animations)
* [Blast](#blast)

### Get tag's name
```javascript
$(".box").prop("tagName");
```

## Forms

### Submitting a form
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

### Submitting a form when pushing enter
```javascript
$('body').keypress(function(event) {
     if (event.which == 13) {
          event.preventDefault();
          $('.send-button').click();
     }
});
```

### File upload
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

### Uncheck a checkbox
```javascript
$("input").is(":checked").attr("checked", false);
```

## AJAX

### Call an external API
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

### Default values for AJAX
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

### Cancel AJAX request
```javascript
var xhr = $.ajax({
    error: function(jqXHR, textStatus, errorThrown){
        if(textStatus == "abort"){}
    }
});

xhr.abort();
```

### AJAX request timeout
```javascript
$,ajax({
    timeout: 3000,
    error: function(jqXHR, textStatus, errorThrown){
        if(textStatus == "error"){}
        else if(textStatus == "timeout"){}
    }
});
```

### Reload whole page
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

## Animations

### Built-in
```javascript
$('.box').on('click', function(){
      $(this)
            .animate({ opacity: 0.8 }, 1500)
            .animate({ opacity: 0.0 }, 1500);      
});
```

### Transit - plugin for JQuery
JQuery's **animate** function uses Javascript animation and not CSS. That means that it is executed in the browser's main thread and without acceleration. **Transit** is a plugin for JQuery that uses CSS transitions instead of Javascript to animate stuff, but not every property can be animated.
```javascript
$('.box').on('click', function(){
      $(this).transition({ x: "+=40px", color:"red", scale: [2, 1.5] }); 
});
```
You can learn more [here](https://ricostacruz.com/jquery.transit) and [here](https://ricostacruz.com/jquery.transit/source/).

## Blast
Blast is a plugin for JQuery that allows you to style text in many different ways.

### Dividing text by words
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

### Styling the searched phrase
Instead of **delimeter** use **search** and blast will apply the style only for the given phrase:
```javascript
$("#text").blast({ search: "banana", customClass: "search-phrase" });
```
```css
.searchPhrase { background-color: yellow; font-size: 18px; padding: 4px; }
```
