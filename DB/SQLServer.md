## SQL Server
Microsoft SQL Server is complex Database Management System (DBMS), shiped by Microsoft, implementing T-SQL.

## Table of contents
* [Configuration](#configuration)
* [Performance](#performance)
* [Tools for SQL Server](#tools-for-sql-server)

## Administration

### Change isolation transaction level
```sql
set transaction isolation level read uncommitted
```
Actually it is only useful in testing environment. Default level is `read commited`.

### Set description for a table
->RIght click on a table ->Properties ->Extended Properties

### Check database and table storage size
* Database: ->Right click on DB ->Properties ->**Size**, or:
```sql
EXEC sp_helpdb 'DB1';
```
* Table: ->Right click on table ->Properties ->Storage ->**Data space**, or:
```sql
EXEC sp_spaceused @objname = 'Table1'
```

### Force database restore
->Right click on DB ->Tasks ->Restore ->Options ->Close existing connections to destination database [Server connections]

### Transparent queries to linked servers
It is possible to query linked server like it was some additional database, but only if it is a SQL Server instance. To make it, follow the steps: ->Right click on linked server ->Properties ->Server Options ->**RPC = True**.<br />
Now you should be able to run queries like this:
```sql
SELECT * FROM SRV124.FactoryDB.dbo.Machine; --SRV124 is linked server name
```

### Login failed for a query with linked server
If you will encounter the following error `Login failed for user 'NT AUTHORITY\ANONYMOUS LOGON'.` while executing a query that references to some linked server it is very probable that you must map your login for the current connection to some login from linked server (that has access to the database that you want to query of course). To do this follow the steps: ->Server Objects ->Linked Servers ->Right click on linked server ->Properties ->Security and add new login. In the column `Local Login` you must type the name of your current connection login and than in `Remote User` and `Remote Password` specify the user that you want to map to your login.

### XML field in a query with linked server
In general it is not allowed to execute a select that queries for a **XML** field from a table from linked server, at least up to SQL Sever 2016. But it can be done with **OPENQUERY**. You have to select the **XML** field converted as **NVARCHAR(MAX)** in an **OPENQUERY** and than converted back to **XML** type. See here for an example:
```sql
SELECT CONVERT(XML, DataXml) 
FROM OPENQUERY(SERVER1, '
	SELECT CONVERT(NVARCHAR(MAX), DataXml) as DataXml 
	FROM Table1')
```

### Error: SQLServerAgent is not currently running
If you will encounter the following error: `SQLServerAgent is not currently running so it cannot be notified of this action`, the first thing you should check is the SQL Server Agent service in SQL Server Configuration Manager (SQL Server Services), if it is started or not.<br />
If the problem is more serious and starting the service doesn't help, it is good idea to check SQL Server Agent's log file - `SQLAgent.out`. If you don't know where to find this file: ->Right click on the **SQL Server Agent** in SQL Server Management Studio ->Properties ->General ->File name.

### Connection information
To get information about all the connections to SQL Server you can use the following query:
```sql
SELECT * FROM sys.dm_exec_connections
```
If you are interested in the current connection only, there are to ways to get information. You can ask for the particular parameter with `connectionproperty` function, or use the previous query and filter the resuts to your session ID thanks to `@@SPID` server variable.
```sql
--It returns only selected parameter of current connection
SELECT connectionproperty('protocol_type');

--It returns all the information of current connection
SELECT * FROM sys.dm_exec_connections
WHERE session_id = @@SPID;
```

### Set SQL Server authentication mode
To change it you must edit the following windows register value: `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQLServer\LoginMode`<br />There are two possible options:
* 1 = Windows Authentication
* 2 = Mixed Authentitaction

### Unlock XP_CMDSHELL
**XP_CMDSHELL** is a setting that allows to execute system commands from SQL Server, combining them with queries or procedures. It is disabled as default, for security issues, think twice before enabling it.<br />
->Right click on Server ->Facets ->**Facet = Server Security** ->**XpCmdShellEnabled = true**, or execute this TSQL command:
```sql
EXEC sp_configure 'show advanced option', '1'; 
reconfigure;
EXEC sp_configure 'xp_cmdshell', 1;
reconfigure;
```
Here is how to execute some command:
```sql
EXEC xp_cmdshell 'dir *.exe'
```

### Default log catalog
`C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\Log`

### Export table data as inserts
->Right click on database ->Tasks ->Generate Scripts ->Choose Objects (for example choose some tables) ->Set Scripting Options ->Advanced ->**Type of data to script = Schema and data**<br />

## Performance

### Basic query statistics
You can turn on few features that will give you basic query statistics after execution (they will put in *Messages* tab, next to *Results* tab).
```sql
set statistics io on;
set statistics time on;
set nocount off;
```

You can use the following query right after your own command to count how many rows were modified:
```sql
SELECT @@rowcount
```

### Examining query efficiency
There are some built-in tools in SQL Server that you can use to examine and improve query efficiency.
1. Profiler - it analyzes queries for a selected database<br />
->Tools ->SQL Server Profiler<br />
->General Tab ->**Use the template = Tuning**<br /> 
->Events Selection ->ColumnFilter ->DatabaseName ->Like = DBName (for examle: Promise_db)<br />
Such configuration of Profiler will allow you to focus on some specified database. Also when you will run the profiler it is useful to filter the results by application name (it can be specified in connection string in your application) or by user name that executed the query. Also you can see duration to easily track slow queries.
2. Tuning Advisor - it suggests where to add an index or statistics<br />
->Tools ->Database Engine Tuning Advisor 
3. Query Execution Plan<br />
To turn it on you must click on the **Include Actual Execution Plan** icon in the toolbar (it should be somewhere near to the **Execute** button). When you will turn it on, after query will be executed you will see next to **Results** tab a new tab called **Execution plan**. Remember that execution plan must be read from right to left.<br />
In case of very long queries that you don't want to wait to finish you may also click on **Display Estimated Execution Plan**. It will show you only estimated plan, not actual, but often the estimated plan is very accurate and it is better than waiting hours for some query to finish (because you will see the actual plan only after the query is finished).<br />

### The least efficient queries 
Here are presented two very useful queries to track the least efficient queries and then optimize them. The first query returns 5 queries with the highest execution time:
```sql
SELECT TOP 5 
     total_worker_time/execution_count AS avg_CPU_time, 
     SUBSTRING(st.text, (qs.statement_start_offset/2)+1, 
          ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(st.text)
            ELSE qs.statement_end_offset
            END - qs.statement_start_offset)/2) + 1) AS statement_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY total_worker_time/execution_count DESC;
```
The following query returns all the queries from last 5 minutes that were executed in more than 1 second with their executlion plans:
```sql
SELECT
   SUBSTRING(st.text, (qs.statement_start_offset/2)+1, 
      ((CASE qs.statement_end_offset 
         WHEN -1 THEN DATALENGTH(st.text) 
         ELSE qs.statement_end_offset 
         END - qs.statement_start_offset)/2) + 1) AS statement_text,
   qp.query_plan, 
   CAST(last_elapsed_time AS DECIMAL(19,0))/1000000 AS last_elapsed_time_in_s, 
   last_execution_time,
   db_name(CONVERT(SMALLINT, dep.value)) AS db_name
FROM sys.dm_exec_query_stats AS qs 
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
CROSS APPLY sys.dm_exec_plan_attributes(qs.plan_handle) AS dep
WHERE last_execution_time > DATEADD(MINUTE, -5, GETDATE()) AND last_elapsed_time > 1000000 AND st.dbid IS NULL AND dep.attribute = N'dbid'
ORDER BY last_elapsed_time DESC
```
Both queries extensively use **DMV**s (Dynamic Management Views), especially **sys.dm_exec_query_stats**.

### Examining execution plan buffer
Execution plan buffer is an important factor for query execution. If a query can use an execution plan that is already in the buffer it is much more efficent than creating new execution plan for each query or for every execution.<br />
To test and examine the buffer first you should clear the SQL Server cache and execution plan buffer like this:
```sql
dbcc FREEPROCCACHE;    --clear cache
dbcc DROPCLEANBUFFERS; --clear execution plan buffer
```
And now look at that:
```sql
SELECT * FROM dbo.Orders WHERE CustomerID = 'PX43'
SELECT * FROM dbo.Orders WHERE CustomerID = 'KR94'
```
Those two queries are actually the same, but for both of them SQL Server will have to create two separate execution plans. To optimize it you have to use parametrized query, like this:
```sql 
EXEC sp_executesql
    N'SELECT * FROM dbo.Orders WHERE CustomerID = @CustomerID',
    N'@CustomerID char(4)', N'PX43' 
```
Now SQL Server will use just one execution plan even if you will change the parameter value.<br > 
With the following query you can explore execution plan buffer:
```sql
SELECT qt.TEXT AS SQL_Query, usecounts, size_in_bytes, cacheobjtype, objtype, p.plan_handle
FROM sys.dm_exec_cached_plans p 
CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) qt
WHERE qt.TEXT not like '%dm_exec%'
```
A very useful thing about this query is that you can get the execution plan handle and you can use it to clear the query's execution plan from cache while not clearing all the rest cached plans. You can make it like this:
```sql
dbcc FREEPROCCACHE(0x0600050037E01805B8A00757000000000000000000000000);
```

### Currently running queries
```sql
SELECT r.session_id, s.TEXT, r.[status], r.blocking_session_id, r.cpu_time, r.total_elapsed_time
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s
```

### Currently running cursors
```sql
SELECT ec.session_id, ec.name,ec.properties, ec.creation_time, ec.is_open, ec.writes,ec.reads,t.text
FROM sys.dm_exec_cursors (0) ec
CROSS APPLY sys.dm_exec_sql_text (ec.sql_handle) t
```

### Clustered vs. Non-clustered indexes
* Rows indexed by **clustered index** are physically stored on the disk in the same order as the index. Because of that each table can have only one clustered index. It is very fast to read but a bit slow to delete or add new rows because index may need to be rearranged. While creating a new table in SQL Server, if you will set a column as a PRIMARY KEY it will add automatically new clustered index for this table (if one doesn't exist yet).
* **Non-clustered index** is a list of pointers to physical rows. So there may be many non-clustered indexes in a table.

### Currently open transctions
```sql
SELECT * FROM sys.sysprocesses WHERE open_tran = 1
```

### Open Activity Monitor
To open Activity Monitor just press **CTRL + ALT + A**

### Performance tips for large data sets
* Use temporary table instead of table variables. Table variables do not contain any statistics so SQL Server does not know if a date set is large or not and it can mistakenly use an inefficient algorithm to perform joins, for example Nested Loops (good for small sets) over Hash Match (good for large sets)
* Be very careful while using UDFs
* Try to avoid type conversion. If you use a temporary table in a query to store some large data set, choose exact column data types 
* Some function used on columns with index do not allow the index to be used. For example `WHERE YEAR(table.CreationDate) = 1995` might scan the whole table instead of using the column's index.

## Tools for SQL Server
There are many great tools allowing DB design, development and automating DB tasks. Of course almost everything can be achieved through SQL Server or T-SQL but sometimes it is simply easier and faster to do things from external tools.

### Develop databases with Data Tools
It is an extension for Visual Studio and SQL Server. It allows to use Reporting Services, Analysis Services, Integration Services (SSIS) for SQL Server but also it allows to create DB project from Visual Studio.<br />
->File ->New ->Project ->Templates ->SQL Server ->**SQL Server Database Project**<br />
->Right click on project ->Import ->Database, or you can create everything from scratch.<br />
->Right click on project ->Properties ->Project Settings ->Target platform - must be set according to your SQL Server version<br />
->Right click on project ->Publish ->Publish<br />
In the **Publish Database** window there is **Advanced** but when you can set some additional settings. The most important are:
* Always re-create database
* Block incremental deployment if data loss might occur
* Back up database before deployment

A very useful feature is comparing database schemas: ->Right click on project ->Schema Compare

### Command line tools
There are some very useful command line tools to work with SQL Server. They allow to make some scripts and automize repeatable work. They are also very cool, since working with console is always fun! SQLCMD and BCP are installed toegether with SQL Server but there are also some third party tools.

### SQL Server queries from command line
To execute queries from command line you can use **SQLCMD** tool. Here is an example:
```batch
sqlcmd -S sepmsrv79 -E -Q "select * from DB.dbo.Employee"
```
SQLCMD has some useful options, here is a small list:
* **-S** server address or name
* **-E** trusted connection (windows authentication)
* **-q** execute query and enter interactive mode
* **-Q** execute query without entering interactive mode
* **-i** input file with SQL commands to be executed

Instead of Windows Authentication you can use SQL login with **-U** and **-P** parameters for user login and password.

### Parametrized SQL queries from command line 
Here is an example of executing parametrized SQL query with SQLCMD. You have to use **-v** option to attach values to query's parameters.
```batch
sqlcmd -S sepmsrv -E -v Name = "Test" -Q "select * from DB.sys.objects where name = '`$(Name)'"
```

### SQL Server import and export from command line
To bulk import or export data from SQL Server you can use **BCP** tool. It has few modes:
* **queryout** use SQL query and export the results to a file
* **out** export selected table
* **in** import given file to selected table

Here is an example of exporting results of some SQL query:
```batch
bcp "select * from Corpo.dbo.Employee" queryout D:\test.csv -S sepmsrv79 -T -c -t";"
```
Here is an example of importing CSV file to Employee table:
```batch
bcp DB.dbo.Employee in .\data.csv -S sepmsrv79 -T -w -t";" -k
```
BCP has some useful options, here is a small list:
* **-S** server address or name
* **-T** trusted connection (windows authentication)
* **-c** results as char
* **-t** specify field separator (for CSV files)
* **-k** keep null's in results
* **-w** use unicode

### SQLPSX
You can download SQLPSX [here](https://github.com/MikeShepard/SQLPSX). It is third party tool that can be used with powershell. Here you can see just the very basic usage:
```powershell
$db = Get-SqlDatabase -sqlserver sepmsrv114 -dbname Promise
$connection = New-Connection -server sepmsrv114 -database Promise
$data = Invoke-Query -connection $connection -sql "SELECT * FROM Employee"
```
There of course many other useful and important cmdlets provided by SQLPSX. The most important are `invoke-sql` that allows to execut update, insert and delete commands and returns the number of modified rows and
`invoke-query` that allows to execute select queries and returns the results of the query.<br />
It is a nice tool but it is worth thinking if using SMO with Powershell is not a better solution?

### dbForge SQL Complete
It is a great plugin for **SQL Server Management Studio** which adds autocompletion features. The express version is free and you can download it [here](https://marketplace.visualstudio.com/items?itemName=DevartSoftware.dbForgeSQLCompleteExpress).
