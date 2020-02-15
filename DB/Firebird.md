## Firebird

### Connect to the database through isql
There is a command line tool **isql.exe** that allows to connect to Firebird database. You have to use **connect** command, see an example:
```sql
connect 'C:\Program Files\App\export.fdb' user dbuser1 password xjfHad1;
```
An important thing to keep in mind is that the commands in **isql** have to be terminated with semicolon. Also you have to remember that if some data will be added or modified to the database after you have connected to it, you will not be able to access this data. You can only work with the data that was in the database in moment of the connection.<br />
If you want to be sure that the connection is correct, you can check the database file path with the following query:
```sql
select mon$database_name from mon$database;
```
The table called **mon$database** is a system table that contains information about the current connection. There are other system tables that may be quite useful like **rdb$database**. You can take the current datetime from this table for example. To see all the tables in the database type:
```sql
show tables;
```
And if you are interested in the table's structure type:
```sql
show table tab1;
```

### Execute system commands
You can execute system commands from **isql**. To make it you have to use **shell** command like this:
```sql
shell dir;
```

### Working with dates
Almost every database is handling dates in a different way, so does Firebird. Here you is an easy example of a query that is going to return the rows from last 3 days - a nice example how to work with dates:
```sql
select locationName, dt, value from dataScans 
where dt > (select dateadd(-3 day to current_timestamp) from rdb$database);
```

### Remote connections
To connect to a remote database you have to specify the remote server address before the database file path, here you can see an example:
```sql
connect '102.101.65.125:C:\Program Files\App\export.fdb' user dbuser1 password xjfHad1;
```

### .Net Provider for Firebird
If you want to connect to Firebird from C# or SSIS, it is a good idea to use free .Net Provider for Firebird. You can download **FirebirdSql.Data.FirebirdClient-6.0.0.msi** from [here](https://www.firebirdsql.org/en/additional-downloads/) and easily install it.
