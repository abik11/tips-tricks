## ADO .Net
Active Data Objects for .Net is a set of classes, a part of .Net framework that allows to work with databases. You will find here Powershell and C# examples.

### Connection String
Connection string is the starting point of every connection made with ADO .Net. Here is an example of a connection string (with no timeout, be careful about that):
```
Data Source=srv124;Initial Catalog=TestDB;Connection Timeout=0;Integrated Security=true
```
Here is an example which also specifies connection's port:
```
Data Source=sepmsrv124,1433;Initial Catalog=TestDB;Integrated Security=true
```
And if you want to specify the suer and its password, put this in your connection string `user id=a.kozak;password=abc123`.

### Connect to a database and execute a query
```powershell
$connection = new-object System.Data.SqlClient.SqlConnection $connectionString 

$connection.Open()
$command = new-object System.Data.SqlClient.SqlCommand $query, $connection
$dataSet = new-object System.Data.DataSet
$dataAdapter = new-object System.Data.SqlClient.SqlDataAdapter $command
$dataAdapter.Fill($dataSet)
$conn.Close()

$dataSet.Tables[0]
```

### Bulk load data
```powershell
$connection.Open()
$bulkCopy = new-object Data.SqlClient.SqlBulkCopy $connectionString 
$bulkCopy.DestinationTableName = $tableName 
$bulkCopy.BatchSize = 50000 
$bulkCopy.BulkCopyTimeout = 0
$bulkCopy.WriteToServer($data) # $data is of type System.Data.DataTable
$connection.Close()
```
If you want to know how to handle **System.Data.DataTable** type, you will find some notes later in this chapter.

### Parametrized insert
```powershell
$cmd.CommandText = 'INSERT INTO Employee VALUES (null, @name)'
$cmd.Parameters.AddWithValue('@name', 'Albert')
$cmd.ExecuteNonQuery()
```
To oprimize insert operation you should specify what is the parameter's type. It will avoid unnecessary type casting (this example is C#):
```csharp
command.Parameters.Add("FirstName", SqlDbType.VarChar, 256).Value = "Albert"
```

### Connection String Builder
There is an interesting class called **SqlConnectionStringBuilder** that allows to easily manage connection strings. Here is an example showing how to use this class:
```csharp
string connectionString = ConfigurationManager.ConnectionStrings["TestDB"]?.ConnectionString; 
SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connectionString); 
builder.IntegratedSecurity = false; 
builder.UserID = "user1"; 
builder.Password = "password"; 
using (SqlConnection connection = new SqlConnection(builder.ConnectionString)){ /*...*/ }
```

### Get a column by its index
```csharp
using (SqlDataReader reader = command.ExecuteReader()) 
{
   while (reader.Read()) 
   {
      int lastNameIndex = reader.GetOrdinal(nameof(Person.LastName));
      if (!reader.IsDBNull(lastNameIndex)) 
         p.LastName = reader.GetString(lastNameIndex);
   }
}
```
**GetOrdinal** returns the index of a column with given name. Here we take the name from some class property name.

### Working with DataTable class
DataTable class allows to build structures that looks like tables in the database. Here you can see a simple example:
```csharp
DateTable table = new DateTable("data");
AddColumn(table, "System.String", "key", "Klucz");
AddColumn(table, "System.String", "value", "Wartosc");
AddRow(table, "imie", "Albert");
AddRow(table, "naziwsko", "Kozak");
AddRow(table, "numer", "99432007");
gridControlName.DataSource = table; //bind some grid's data source

private void AddColumn(DataTable table, string type, string name, string caption)
{
   DataColumn column = new DataColumn();
   column.DataType = System.Type.GetType(type);
   column.ColumnName = name;
   column.Caption = caption;
   column.ReadOnly = true;
   table.Columns.Add(column);
}

private void AddRow(DataTable table, string key, string value)
{
   DataRow row = table.NewRow();
   row["key"] = key;
   row["value"] = value;
   table.Rows.Add(row); 
}
```
