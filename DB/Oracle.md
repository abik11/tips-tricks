## Oracle DB
The Oracle DB is very well known and commonly used RDBMS. It uses **PL/SQL** programming language. If you are familiar with **T-SQL** be careful with the semicolons at the end of the statement. :) To be able to run and test queries against Oracle DB you can download **SQL Developer** from [Oracle website](https://www.oracle.com/database/technologies/appdev/sql-developer.html). If you are used to work with **SQL Server**, selecting some lines of T-SQL code and pressing **F5** to run the selected query, in SQL Developer you will have to press **CTRL + ENTER** instead. The F5 key runs the whole script. You can also download **Oracle Db XE** (Express Edition) which you can use for free - great for learning.

### Oracle for .Net
To enable ADO .Net to work with Oracle databases you have to add Oracle.DataAccess.dll as a reference to your project. Be careful because there are x86 and x64 versions and it is important whih version to chose!<br />
Here is C# example of how to connect and execute a query:
```csharp
string connectionString = "Password=1234;User ID=admin;Data Source=//100.100.12.12/srv";
string commandString = "SELECT Id, Name, Hiredate FROM Employee WHERE Name = :1";
string nameString = "Albert";
try{
    OracleConnection connection = new OracleConnection(connectionString);
    OracleCommand command = new OracleComand(commandString); //Paremeters :1, :2, etc
    connection.Open();
    OracleParameter pName = new OracleParameter("@name", OracleDbType.Varchar2, 8);
    pName.Value = nameString;
    cmd.Parameters.Add(pName);
    OracleDataReader rdr = command.ExecuteReader();
    while(rdr.Read())
    {
        int id = (int) rdr["Id"];
        string Name = (string) rdr["Name"];
        DateTime startDate = 
        	DateTime.ParseExact((string) rdr["Hiredate"], "yyyyMMddHHmmss", null);
        //Your code here
    }
    connection.Close();
}
catch(OleDbException){ /*Your code here*/ }
```
And here is Powershell example:
```powershell
Add-Type -path C:\oracle\odp.net\bin\4\Oracle.DataAccess.dll
$connectionSting = "Password=1234;User ID=admin;Data Source=//100.100.12.12/srv";
$commandString = "SELECT Field1, Field2 FROM Tab1";
$connection = New-Object Oracle.DataAccess.Client.OracleConnection
$connection.ConnectionString = $connectionSting
$connection.Open()
$command = New-Object Oracle.DataAccess.Client.OracleCommand
$command.CommandText = $commandString
$command.Connection = $connection
$rdr = $command.ExecuteReader()
while($rdr.read()){
    $rdr['Field1']
}
$rdr.Close()
$connection.Close()
```

### Get current date
```sql
SELECT TO_CHAR(CURRENT_DATE, 'YYYYMMDD') FROM dual;
```

### Add days to a date
```sql
SELECT CURRENT_DATE + 10 FROM dual;
```

### Get top 100 rows
There is no such thing in Oracle DB as **TOP** in SQL Server. Instead you have to use **rownum**, see the following example:
```sql
SELECT * FROM
(SELECT * FROM ProductionData)
WHERE rownum <= 100;
```
