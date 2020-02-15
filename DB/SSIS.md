## SSIS
SQL Server Integration Services is a Microsoft ETL tool (Extract Transform Load). It allows to import, export, combine, filter, sort data from any different sources like SQL Server, MySQL, Oracle, Excel, CSV and many more. It is very powerful and even allows to write C# scripts.

### Import and Export Data tool 
This tool is actually just a little wizard that generates SSIS package in the background that do all the data operations for you. You can find it like this: ->Start Menu ->Search: **Import and Export Data** or alternatively: ->Start Menu ->Run: **DtsWizard**

### Problem with importing excel files
You may encounter some errors while trying to import data from excel files in Import and Export Data tool. If the error you encounter is `MICROSOFT.ACE.OLEDB.12.0 is not registered`, then you have to download and install this: [AccessDatabaseEngine.exe](http://www.microsoft.com/download/en/confirmation.aspx?id=23734)<br />
Moreover, if you use any encryption software, excel file will be not readable for the import tool.

### Convert numbers stored as text to text
It may sometimes crush your Excel import when the data in some column is inconsistent. Some cells are saved as numbers or dates, others are saved as string. You can go to: ->Data ->Text to Columns, and it should help.

### Package version error
If you see the error: *The version number in the package is not valid. The version number cannot be greater than current version number* that means that your package build was configured for the higher version of SQL Server than the version of SQL Server where the package is deployed. For example you have SQL Server 2012, but your package is configured for SQL Server 2016. To change this configuration: ->Right click on the SSIS project ->Properties ->Configuration Properties ->General ->**TargetServerVersion** ->Choose your version.

### Deploy packages from command line
Use ISDeploymentWizard tool to deploy SSIS packages from command line, here is an example:
```batch
C:\Program Files (x86)\Microsoft SQL Server\130\DTS\Binn\isdeplyomentwizard.exe /S /ST:File /SP:data_import.ispac /DS:106.116.82.93/SQL /DT:/SSISDB/Imports/CorpoProject
```
To see how to deploy package from GUI go to *Useful links*.

### Execute package from T-SQL
There is an easy way to get the T-SQL code that will execute your package. In SSIS catalog in SQL Server just right click on your package and choose **Execute**. In the top left corner of the **Execute Package** window, there is a **Script** button. If you will click this button it will generate execution script of your package which you can easily copy or adjust for your T-SQL scripts. 

### Copy only backup from SSIS package
->SSIS Toolbox ->Other Tasks ->Back Up Database Task ->Right click ont the task ->Edit ->Options 
->Copy-only backup

### Debugging packages
Here are two nice features that makes SSIS debugging much easier:<br />
->Right click on the block (in the control flow) ->Edit Breakpoints...<br />
->Double click on pipeline (the line connecting two blocks) ->Data Viewer ->Enable Data Viewer ->Choose columns you want to see

### Package Configurations
There is a nice way of putting the configuration of a package out of it to be able to externaly change it. You have to right click on your project and select **Convert to Package Deployment Model**. Then in **Control Flow** right click in the background and choose **Package Configurations** then **Add**. In the wizard in the first window called **Select Configuration Type** you will have to speficy the source of configuration. A recommended value for **Configuration type** is **SQL Server**, this will allow to create a new database table and store the configuration there. SSIS can create a table for you. In the second window called **Select Properties to Export** you have to choose which variables and properties to put into configurations. A good idea is to choose only to import the **Value** of selected variables or propertes. <br />
After the whole process is finished you can change the values inside the SQL Server and it will affect the execution of SSIS package.

### Access variables from Script Task
You can easily access variables inside of a Script Task. First you have to edit properties of the task and set the list of variables that the script can read or modify. To do that use **ReadOnlyVariables** or **ReadWriteVariables**. Then when you edit script you can access the variable with the following line of code:
```csharp
string counter = Dts.Variables["User::Counter"].Value.ToString();
MessageBox.Show(counter);
```

### RecordSet Destination
There is a really nice data destination in SSIS called **RecordSet Destination**. It allows to put the data into memory and work with it inside the **Script Task**. You have to create a new variable of type **Object** because **RecordSet Destination** will store the data in the given variable. Then there are at least two ways of consuming the data.<br />
If you don't like to write C# code, you can use **Foreach Loop Container**. Editing the container, in the **Collection** tab, set the **Enumerator** as **Foreach ADO Enumerator** and in **ADO object source variable** choose the variable where do you store your results. Then in **Variable Mappings** tab you have to create new variables for every data column that you want to use later. Inside of a container you can put a simple Script Task that will refer to those newly created variables in Variable Mappings tab.<br />
If you like to write C# code, then there is also another way. You can directly specify the variable that stores the result as **ReadOnlyVariables** in Script Task and use it in the C# code for example like this:
```csharp
DataTable dataTable = new DataTable();
OleDbDataAdapter dataAdapter = new OleDbDataAdapter();
dataAdapter.Fill(dataTable, Dts.Variables["User::Results"].Value);

foreach (DataRow row in dt.Rows)
{
    MessageBox.Show(row["Column1"].ToString());
}
```

### How to keep data synchronized
A very common use case for SSIS is to keep some data table synchronized with some data source. For example there is some external database that gathers data all the time and you want to import that data once a day into your own database to be able to transform it or show some statistics. You have to insert all the new rows or update those which are modified. These kinds of operations are often called incremental data loading, incremental load or incremental data synchronization.<br />
There are quite many ways to make it with SSIS. For example you have to get the source data and the target data, so you need two **Data Sources** which then have to be sorted (by **Sort**) and then put as input for a **Merge Join**. If you want to have the new data, you have to use **Left Outer Join** to join the target to the source (which should contain the new rows). Then you should put the merged data into **Conditional Split** and add a condition to check if some field is null, an ID from target data is a good candidate for such check, for example `ISNULL(Target_ID)`. Also if you want to synchronize modifications in existing data you can add another condition, for example `Target_Name != Source_Name || Target_Value != Source_Value`. Then you can directly put the new data into target (one output from Conditional Split) and using **OLE DB Command** update the modified data (second output of Conditional Split) or put it into some temporary table and then use **Execute SQL Task** update it with single SQL update command.

### Stop running SSIS packages
In general if you run **SSIS packages** through **SQL Server Agent** all you need to do to stop the package is to stop the job that runs this package. But if something goes wrong and tha package does not stop or you have started it manually then you need another way:<br />
->Right click on a package ->Reports ->All Executions ->Get the operation ID from the ID column for the package that you want to stop ->Run the following SQL command:
```sql
USE SSISDB
GO
 
EXEC [catalog].[stop_operation] 3033717 --here put your ID of course
```
