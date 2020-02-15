## SMO
SQL Sever Management Objects is a set of classes that allow to manage SQL Server programmatically with the same functionality as is provided in SQL Server Management Studio. Extremely interesting and useful technology! The examples are written with Powershell, in all of them variable *$class* is used, it is initalized like this:
```powershell
$class = 'Microsoft.SqlServer.Management.Smo'
```
It is nice to know that there is no magic beneath SMO. Every call to SMO methods or cmdlets are later simply translated to TSQL.

### Load SMO
Loading SMO became much easier in SQL Server 2016.
* **SQL Server 2008**
```powershell
[Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.Smo')
Add-PSSnapin SqlServerCmdletSnapin100   #Additional cmdlets
Add-PSSnapin SqlServerProviderSnapin100 #SQL Server PSProvider
```
* **SQL Server 2016**
```powershell
ipmo sqlps -disableNameChecking
```

### Access to SQL Server instance
SMO allows easy access to SQL Server instance and many methods that allow to retrive some information and change configuration. Here some little example, but be careful, it is **not** a connection to the database yet!
```powershell
$srv = New-Object -type "$class.Server" srv1  # sepmsrv1,1433
$srv.EnumAvailableMedia(2)  # 2 - media type - physical disks
$srv.EnumProcess($false)
$srv.KillAllProcesses('TestDB')
$srv.ReadErrorLog()
$srv.Information
$srv.Configuration.MaxServerMemory.RunValue / 1MB 
$srv.Configuration.MaxServerMemory.ConfigValue = 2048
$srv.Alter()  # save configuration changes
```
**$srv.Configuration** contains objects that can be configured also with the TSQL **sp_configure** procedure from SQL Server. To see which properties can be changed by SMO you can use the following code:
```powershell
$srv.Parameters | ? writable -eq $True
```

### Check connection
The following example shows how to safey connect to the SQL Server instance with exception handling. The handle to the connection is kept in **ConnectionContext** property.
```powershell
try {
    $srv.ConnectionContext.ConnectTimeout = 5
    $srv.ConnectionContext.Connect()
    $srv.Name
}
catch {
    $_.Exception.Message
}
finally {
    $srv.ConnectionContext.Disconnect()
}
```

### SQL Server authentication
Here is an example of how to login to the SQL Server:
```powershell
$login = Get-Credential -Message "SQL Server credentials"
$srv.ConnectionContext.LoginSecure = $false
$srv.ConnectionContext.Login = $login.UserName
$srv.ConnectionContext.set_SecurePassowrd($login.Password)
$srv.ConnectionContext.Connect()
```

### SQL Server PSProvider
SQL Server PSProvider allows to work with SQL Server structure (databases, tables, procedures, anything actually) as it was a directory on your local PC, using commands like **ls**, **gi**, **cd**, etc.
```powershell
cd sqlserver:\sql\sepmsrv124\DEFAULT\Databases\TestDB
gi dbo.Employee #get-item
ls Tables | % { $_.Script() + "`n`n`" }
```

### Commands for SQL Server 2016
Since SQL Server 2016 in SMO there also new cmdlets added that allow you to make a huge number of database operation, here is just some example list:
```powershell
Get-SqlDatabase
Backup-SqlDatabase
Restore-SqlDatabase
Read-SqlTableData
Write-SqlTableData  # download write-dataTable script for older versions
Invoke-SqlCmd -OutputAs  # download invoke-sqlcmd2 script for older
Get-SqlLogin
Add-SqlLogin
Remove-SqlLogin
Get-SqlAgent
Get-SqlAgentJob
```

### Get databases 3 different ways
***There is more than one way to do it*** ([TIMTOWTDI](https://en.wikipedia.org/wiki/There%27s_more_than_one_way_to_do_it)) with SMO. Almost everything you can make on at least 3 ways:
* Using SMO object model (1) 
* Using SMO PSProider (2)
* Using cmdlets provided by SMO - since SQL Server 2016 (3)
```powershell
$srv.databases # 1
ls sqlserver:\sql\sepmsrv124\default\databases # 2
get-sqlDatabase -serverInstance sepmsrv124 # 3
```

### Databases
Database management in SMO is very intutivie. Here you can see how to create a new database:
```powershell
$db = new-object -type "$class.Database" $srv, 'TestDB'
$db.Create()
```
Just after creating new database you can get some information about it, change configuration or rename it, anything you could do with SQL Server Management Studio:
```powershell
$srv.Databases['TestDB'] | select Name, CreateDate | ft -a
$srv.Databases['TestDB'].DatabaseOptions
$srv.Databases['TestDB'].Rename("MyDB")
```
Usually there is more than one way to do some task. Compare those two, first we drop a database using a method of **Database** object, later a database is drop using SQL Server PSProvider and **rm** command:
```powershell
$db.Drop()
rm sqlserver:\sql\sepmsrv124\DEFAULT\Databases\TestDB
```

### Tables
Just like databases, you can to anything with tables. Here is an example that shows how to create a new table. The most difficult thing about creating a table is that you must create every column and manually attach it to a new table (possibly that would be a good idea to encapsulate this functionality into separate function). But in general the process is quite simple:
```powershell
$tab = new-object -type "$class.Table" -arg $db, "Tab1"

$intType = new-object -type "$class.Datatype" -arg "Int" 
$ID = new-object -type "$class.Column" -arg $tab, "ID"
$ID.DataType = $intType
$ID.Nullale = $false
$tab.Columns.Add($ID)

$varcharType = new-object -type "$class.Datatype" -arg "VarChar", 50
$Name = new-object -type "$class.Column" -arg $tab, "Name"
$Name.DataType = $varcharType
$Name.Nullale = $true
$tab.Columns.Add($Name)

$tab.Create()
```

### Modify columns collation
A very practical example of SMO is how to change the collations of columns. It would be quite time-consuming to make it manualy, but it can be easily automized with SMO. First let's list available collations, use the following command:
```powershell
$srv.EnumCollations()
```
Now choose the collation and use the following script to change it:
```powershell
$db.Tables | % {
    $_.columns | ? { $_.datatype -match "char|varchar|nvarchar" } | % {
        $_.Collation = 'SQL_Latn1_General_Cp437_BIN'
        $_.alter()
    }
}
```

### Logins and users
The following example shows how to create and delete a login and create and delte a user. 
```powershell
$login = new-object -type "$class.Login"
$login.Parent = $srv
$login.Name = 'mylogin'
$login.LoginType = 'SqlLogin' #WindowsLogin, WindowsGroup
$login.PasswordPolicyEnforced = $false
$login.Create('mypassword1')

rm sqlserver:\sql\sepmsrv124\DEFAULT\Logins\mylogin

$user = new-object -type "$class.User" -arg $db, 'mylogin'
$user.Login = 'mylogin'
$user.DefaultSchema = 'dbo'
$user.Create()

rm sqlserver:\sql\sepmsrv124\DEFAULT\Databases\Users\mylogin
```
After we attach user to login, we can access the user's database with login's name and password. So, more or less, login gives us access to the server and user gives us access to the database.<br />
There are many things that SMO allows us to do. If you want to get all the users with their roles, just use the following query:
```powershell
ls sqlserver:\sql\sepmsrv124\default\databases\TestDB\users | % `
    -Begin { $data = @() } `
    -Process { $data += @{ User=$_; Role=$_.EnumRoles() } } `
    -End { $data }
```
It us also possible to search for logins across multiple servers. Here you can see how to do this:
```powershell
'srv79', 'srv93', 'srv114' | % { ls sqlserver\sql\$_\default\logins } `
    | ? { $_.ismebrt('sysadmin') | select Parent, Name

'sepmsrv79', 'sepm93', 'sepm114' | % { ls sqlserver\sql\$_\default\logins } `
    | ? { $_.Name -eq 'a.kozak' } | select Parent, Name
```
The first piece of code finds all the users of role *sysadmin* and the second finds all the users with *Name* equal to *a.kozak*. So thanks to SMO and Powershell syntax we have very easy and practical way to find anything in the database.

### Stored procedures and UDFs
Stored procedures and User Defined Functions can be also manged by SMO.
```powershell
$db.StoredProcedures | select Parameters, TextBody, Script # SP
$db.UserDefinedFunctions `
	| select Parameters, TextBody, Script, FunctionType, RetrunsNullOnNullInput # UDF
```

### Rebuild and reorganize indexes
```powershell
$index = $db.Tables['Employee'].Indexes['i_Employee_Oid']
$index.rebuild()
$index.reorganize()
```

### Execute TSQL
```powershell
$db.ExecuteNonQuery("INSERT INTO dbo.Employee VALUES ('Albert Kozak')")

$dataSet = $db.ExecuteWithResults("SELECT * FROM dbo.Employee")
$dataSet.Tables[0]

$dataRows = invoke-sqlcmd -serverInstance sepmsrv124 -database Period `
  -query 'SELECT * FROM dbo.PadPrintingMatrix'  # System.Data.DataRow
```

### Backup
Of course we can do bakcup with SMO. If want to backup just one database, use the following code:
```powershell
Backup-SqlDatabase -serverInstance sepmsrv124 -database TestDB -backupFile test.bak 
# -Incremental -Initialize -CopyOnly -backupAction Log -passThru # nice stuff
```
Also it is possible to do backup of many databases at once:
```powershell
$srv.Database | ? { $_.Name -ne 'tempdb' } | backup-sqlDatabase
```
It is not allowed to backup tempdb database, so we filter it out. Also it is not allowed to do log backup for databases with SIMPLE recovery model.<br />
Like evertyhing in SMO, backup can be done in more than one way. Here is how to do backup with **Backup** object:
```powershell
$backup = new-object "$class.Backup"
$backup.Action = 'Database' # Log, File
$backup.Database = 'TestDB'
$backup.Devices.Add('dbbackup.bak', 'File')
$backup.SqlBackup($srv)

# Additional optional settings:
$backup.Incremental = $True
$backup.CopyOnly = $True
$Initialize = $True
```
To get information about backups, default backup directory, last backup, etc. you can use the following code:
```powershell
(gi sqlserver:\sql\sepsrv124\default).BackupDirectory
$srv.BackupDirectory # $srv.Settings.BackupDirectory
$db.LastBackupDate
$db.LastDifferentialBackupDate
$db.LastLogBackupDate
$db.RecoveryModel
```

### Insert data into database
```powershell
$result = invoke-sqlcmd -database TestDB -query $query -outputAs DataTables
write-sqlTableData -serverInstance sepmsrv124 -database TestDB -schemaName dbo
    -tableName importData$ -inputData $result -force
```
Use **-force** to create a table if it doesn't exist

### Manage server jobs
Here you can see how to list server jobs. The following script shows only jobs that are enabled:
```powershell
$srv.JobServer.Jobs | ? { $_.IsEnabled -eq $True } `
    | select Name, LastRunOutcome, LastRunName
```
And here you cans see how to modify job configuration:
```powershell
$job.IsEnabled = $False
$job.Alter()
```
It is also quite easy to get all the history of a specified job:
```powershell 
get-sqlAgentJobHistory -serverInstance sepmsrv124 -Jobname 'Full backup' -since yesterday
```

### SMO for C#
->Add references ->Browse ->C:\Program Files\Microsoft SQL Server\130\SDK\Assemblies
* Microsoft.SqlServer.Management.Sdk.Sfc
* Microsoft.SqlServer.Smo.dll
* Microsoft.SqlServer.SqlEnum.dll
```csharp
using Microsoft.SqlServer.Management.Smo;

Server srv = new Server("srv114");
Console.WriteLine(srv.ToString());
foreach(Database db in srv.Databases)
{
     Console.WriteLine(db.Name + " " + db.Tables.Count.ToString());
}
```
