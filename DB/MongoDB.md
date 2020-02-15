## MongoDB
MongoDB is a document database, (probably) the most popular NoSQL database. It is especially often used in combination with Node.js because it stores data in BSON (Binary JSON) format which looks like JSON (native for JavaScript) and is easily convertible to and from JSON. Toegether with Express (Node.js framework for building web servers) and modern front-end frameworks it is a part of web application stack called as MEAN, MERN or MEVN for MongoDB, Express, Angular/React/Vue and Node.js.<br />
The easiest way to try (for free) and work with MongoDB is through [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) which serves MongoDB databases as a service.

### Tools
You can connect to MongoDB and manage your database with command line tool called Mongo Shell or use a graphical tool called [Compass](https://www.mongodb.com/products/compass). Compass has a nice feature that if you will copy to clipboard a connection string to a database, it will read the configuration from clipboard, here is a scheme of the connection string:
```
mongodb+srv://<username>:<password>@<cluster-name>.mongodb.net/test
```

### Basic queries
Mongo Shell allows you to query the database almost the same way as you would do from JavaScript, which is really useful for testing and development. To connect to DB you should the following command:
```
.\mongo "mongodb+srv://<server>" --authenticationDatabase admin --username <user> --password <password>
```
Then you can use the MongoDB commands:
```
show dbs	#list all the databases
use test-db	#use or create a database
db		#display the name of current database
```
Inside the database you can store data grouped in collections. To create a collection you have to simply add some data:
```
db.users.insertOne({ name: 'Paulina', height: 172 })
db.users.insertMany([{ name: 'Albert' }, { name: 'Ada', height: 164 }, { name: 'Ewa', address: { street: 'Agrestowa' }}])
show collections
```
Differently than in SQL databases the data in one collection doesn't have to be structured as it has to be in SQL tables. To display and filter (select) data you can use the **find** method:
```
db.users.find() #shows all the data in the collection
db.users.find({ name: 'Albert' })
db.users.find({ height: { $gt: 165 } })
db.users.find({ 'address.street': 'Agrestowa' })
```
There are of course many other different possibilites to query the data, if you want to know more details, go [here](https://docs.mongodb.com/manual/tutorial/query-documents/).<br />
You can also easily update and delete the data with **update** and **delete** methods:
```
db.users.update(
    { name: 'Ada' }, 
    { $set: { height: 170 } }
)

db.users.deleteOne({ name: 'Albert' })
```
You can delete all documents with **remove** method:
```
db.users.remove({})
```

### Conect to MongoDB through JavaScript
To work with MongoDB in Node.js you have to install **mongodb** package, you can make it with npm: `npm i mongodb`.
```javascript
const mongodb = require('mongodb');
const client = await mongodb.MongoClient.connect
	('mongodb+srv://<username>:<password>@<server-name>/<db-name>?retryWrites=true', { useNewUrlParser: true });
const usersCollection = client.db('db-name').collection('users');
const allUsers = usersCollection.find({}).toArray();
```
In general, on the collection object you can use the same methods as in the Mongo Shell, so you can easily add, modify and delete records too.

##### Mongoose
A very popular way of working with MongoDB through JavaScript is to use **Mongoose** ORM or actually ODM (Object-Document Mapper). Go [here](https://mongoosejs.com/) to learn more.
