## SQLite
SQLite is very lightweight library that allows you to manage database saved in a single file. It is quite unique approach, easily embedable, allowing to bring local DB storage for every application.

### SQLite database as linked server
SQLie can be attached to SQL Server as Linked Server and queried from SQL Server, follow the steps to achieve this goal.
1. Install ODBC driver for SQLite
2. ->Start Menu ->Administrative tools ->Data Sources (ODBC) ->System DSN ->Add
3. Choose driver and fill its data
4. ->SQL Server ->Server Objects ->Linked Servers ->Right click on New<br /> 
Provider = Microsoft OLE DB Provider for ODBC Drivers,<br /> 
Product Name = SQLite,<br /> 
Data source = (The same as created in Data Sources)

Now you can query SQLite from SQL Server using **openquery** function
```sql
select * from openquery(SQLITEsrv , 'select * from db_emp') --SQLITEsrv is linked server name
```

### Add 32-bit data source on 64-bit machine
On 64-bit systems the default Data Source configuration tool manges 64-bit sources and drivers. If you need to use 32-bit software then you have to use 32-bit Data Source configuration tool which you will find here: `C:\Windows\SysWOW64\odbcad32.exe`

### SQLite for .Net
There is a **dll** library that allows you to manage and use SQLite databases in .Net. Here you can see how to use it with Powershell.
```powershell
### Importing System.Data.SQLite.dll ###
Add-Type -path 'C:\Program Files\System.Data.SQLite\2013\bin\System.Data.SQLite.dll'

### Connecting to SQLite db ###
$connection = New-Object System.Data.SQLite.SQLiteConnection
$connection.ConnectionString = 'Data Source=sqlite.db'
$connection.Open()

### Create SQL command ###
$command = $connection.CreateCommand()
$command.CommandText = 'SELECT * FROM employee'

### Execute query and retrive data ###
$adapter = New-Object System.Data.SQLite.SQLiteDataAdapter $command
$data = New-Object System.Data.Set
[void]$adapter.Fill($data)
(0..($data.Tables[0].Rows.Count)) | % { $data.Tables[0].Rows[$_] } | Out-GridView #ft -a

### Close and dispose ###
$command.Dispose()
$connection.Close()
```

### Commands
To manage SQLite database you have to use specified set of commands.
* `.help` shows available commands with description
* `.databases` shows existing dabatases
* `.dbinfo` shows database information
* `.show` shows database configuration options
* `.tables` shows existing tables
* `.schema Tab1` shows CREATE command of the given table Tab1

There are also special tables that contain some metadata. For example, to shows tha data about tables existing in the database use must use the following query:
```sql
select * from sqlite_master
```

#### Backup
* `.backup main D:\\DB\\db.bak`
* `.restore main D:\\DB\\db.bak`

#### Format results
* `.header on` adds column name in the first row of results
* `.mode column` shows results formated in columns
* `.timer on` shows query execution time statistics in the last row of results

### SQL Commands
```sql
create table tab1(
	id integer, 
    name text, 
    primary key(id) --first method to add primary key
);

create table tab1(
	col1 integer primary key autoincrement, --second method to add primary key
    name text
);

insert into tab1 values(null, 'Albert'); --null value should be put for autoincremented columns

explain query plan select * from employee; 
--it works for MySQL also and shows query execution plan
```
