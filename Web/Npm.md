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

### ERR Code E401: Unable to authenticate, need: Bearer authorization
Remove `%USERPROFILE%\.npmrc`(if exists) and run: `npx vsts-npm-auth -config .npmrc`.
