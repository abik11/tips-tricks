## React
ReactJS is a UI library to allow you to build better views and SPA (Single Page Applications), it is developed by Facebook and became an extremely popular library/framework used to build modern web applications. It is very fast by the way!

### Magic behind JSX
All the magic behind **JSX** is done by `React.createElement` method, for example, the following code:
```javascript
const element = (
    <h1 className="greeting">Hello</h1>
);
```
is equivalent to simple execution of `createElement` method:
```javascript
const element = React.createElement(
    'h1', {className:'greeting'}, 'Hello'
);
```

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
