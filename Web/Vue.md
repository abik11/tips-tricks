## Vue
Vue.js is a modern, practical web front-end framework that allows you to quickly build well-structured modularized applications. It is quite easy to learn and very powerful when mixed with Webpack and Vuex (its state management library). Working with Vue.js is a real fun! 

## Table of contents
* [Handling forms](#handling-forms)
* [Routing](#routing)
* [Component](#component)
* [Advanced tips](#advanced-tips)
* [Vuex](#vuex)

## Handling forms

### V-model
To create two-way binding with input tags you have to use **v-model** directive.
```html
<input v-model="message">
```

### Multiple checboxes
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

### Select
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

## Routing

### Keep the component's state
If you will wrap **router-view** with **keep-alive** tags, it will keep the state of components between different routes, otherwise every time you will leave a route, its data will be lost.
```html
<keep-alive>
    <router-view></router-view>
</keep-alive>
```

### Access URL parameters
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

### Pass route parameters as component's props
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

## Component

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

## Advanced tips

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

## Vuex

### Access property from another module in Vuex
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

### Vuex2.default is not a function
If you encounter the following error: `TypeError: (0 , _vuex2.default) is not a function` while working with Vue and Vuex, the possible reason is that your imports from Vuex are incorrect, for example:
* error: `import mapGetters from 'vuex';`
* correct: `import { mapGetters } from 'vuex';`
