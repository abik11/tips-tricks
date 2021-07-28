## CSS Animations
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

## Web Animations API

### How to check if a property can be animated with Web Animation API?
```javascript
const svgPath = document.getElementById("svg-path-1");
const svgPathAnimation = svgPath.animate([
  { test1: 0, opacity: 1, offset: 0 },
  { test1: 1, opacity: 0, offset: 1 }
], {
  duration: 1000,
  fill: 'forwards'
});

console.log(svgPathAnimation.effect.getKeyframes());
```
If the property you specified in key frames is not present on the list, then it cannot be animated with WAAPI.
