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
