## Postman

### Test code in Postman
Go to *Tests* tab of a request and there you can write a test code that will be executed every time for this request:
```javascript
pm.test("Response time is less than 100ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(100);
});
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});
```
You can also use variables defined in *environment*:
```javascript
let time = parseInt(pm.environment.get("time"))
pm.environment.set("time", time + pm.response.responseTime);
```
