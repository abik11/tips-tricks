# DB Progamming - Tips for beginners
Most useful (but basic) tips and tricks that will make DB programming much easier task. It is not a complex guide from zero to hero, just a set of advices and things that might be usefulf, life- and time-saving. All that you will encounter here is written from the perspective of a .Net developer.
* [XPO](#xpo)
* [Entity Framework](#entity-framework)
* [Code First in EF](#code-first-in-ef)
* [Linq](#linq)
* [ADO .Net](#ado-net)
* [T-SQL](#t-sql)
* [SQL Server](#sql-server) 
* [SMO](#smo)
* [SQLCLR ***(in progress)***](#sqlclr)
* [Tools for SQL Server](#tools-for-sql-server)
* [SSIS](#ssis)
* [Oracle DB](#oracle-db)
* [SQLite](#sqlite)
* [Firebird](#firebird)
* [MongoDB](#mongodb)
* [XML](#xml)
* [Useful links](#useful-links)

## XPO
XPO is an ORM (Object-Relational Mapper) shiped by DevExpress. It is quite efficient and easy to use. Really good ORM, go [here](https://github.com/abik11/tips-tricks/blob/master/DevExpress.md#xpo) for more informations.

## Entity Framework
EF is Microsoft open source ORM (Object-Relational Mapper). It has some very nice features but in general seems a bit less intuitive than XPO. Still, it is a very good ORM.

### Create EF project
->File ->New ->Project ->Class Library (type of a new project)<br />
Add Entity Framework 6 package from NuGet to your project and decide what approach you want to use.<br /><br />
**DB First:**<br /> 
->Right click in the background of edmx diagram ->Update Model from Database...<br />
**Model First:**<br /> 
->Right click in the background of edmx diagram ->Generate Database from Model... ->...<br /> 
->Open edmx.sql file ->Execute

### New association in Model First
->Right click on some entity ->Add New ->Association ->Set options according to your needs and check the option: Add foreign key properties to the 'Entity1' Entity

### Add enum type
**Method 1** - add new enum type:<br />
->Right click in the background of edmx diagram ->Add new ->Enum Type...<br />
**Method 2** - convert field to enum:<br />
->Right click on a field of entity ->Convert to Enum...

### Common errors and exceptions
**Model class of name System** <br />
If you will add a new model class which will be called **System**, you will encounter problems because there will be name conflict between your class and .Net System namespace (System.DateTime, System.Data, etc). So take it into consideration while naming your classes.

**The type DbSet<> is defined in an assembly that is not referenced**<br />
EF is not referenced in this project! (Add it from NuGet)

**Invalid object name 'dbo.TableX'**<br />
Table exists in the model, but doesn't exist in the database.

**Concurency**<br />
->Add **RowVersion** column of **timestamp** type in the database<br />
->Update the model in Visual Studio<br />
->For the **RowVersion** field in Visual Studio, set the property **Concurency Mode = Fixed**<br />
->You must handle **DbUpdateConcurrencyException** exception for every update operation

### Eager and lazy loading
**Lazy loading** - default, loading associated data only when referenced:
```csharp
var machine = context.Machines.FirstOrDefault(x => x.Id == 5).ToList(); //machine.Logs == null
var logs = machine.Logs; //exactly in this moment Logs are loaded
```

**Eager loading** - Logs are loaded toegether with Machines, thanks to **Include** method:
```csharp
var machine = context.Machines.Include(x => x.Logs).FirstOrDefault(x => x.Id == 5); 
```

**Explicit lazy loading** - available after turning off default lazy loading:
```csharp
context.Configuration.LazyLoadingEnabled = false; //turn off lazy loading
context.Entry(machine).Collection(x => x.Logs).Load();  //explicitly use lazy loading for Logs
var logs = machine.Logs; //load Logs
```

### Disconnected mode
Disconnected mode is used when you are dealing with objects without context (DBContext). It may occur when you get some object using some context, but you want to modify it when this context is disposed. To handle objects in disconnected mode, they must be attached to a new context and its state must be updated (**EntityState** - Unchanged, Added, Modified, Deleted, Detached). 
```csharp
Student student = null; 
using (var context = new SchoolDBEntities())
{
    context.Configuration.ProxyCreationEnabled = false;
    student = context.Students.FirstOrDefault(s => s.Id == 1);
}
student.Name = 'New student';

using (var context2 = new SchoolDBEntities())
{
    context2.Entry(student).State = EntityState.Modified;
    context2.SaveChanges();
}
```
When it comes to adding and deleting objects in disconnected mode, it is a bit easier because Add and Delete methods can automatically attach objects to context and update their state.

### Use TVF in LINQ
->Write your own Table Value Function ->Right click in the background of edmx diagram ->Select your TVF ->**Model Explorer** (You should find it next to Solution Explorer tab) ->Function Imports ->Right click on your TVF ->Edit ->Check **Function Import is composable** and **Returns a collection of: Entites** and select what type it should return.<br />
Now you should be able to use your TVF toegether with LINQ statements:
```csharp
context.YourTableValuedFunction(10).OrderBy(x => x.Id);
```

### Print out generated SQL query
Put the following line of code before the line that generates the query:
```csharp
context.Database.Log = Console.Write;
```

### Add partial class
The model classes generated by EF in model or database first approach are **partial** classes, so it is easy to extend their set of properties or methods, all you have to is to create a new partial class with the same name as the one that is already generated in your model. Here is an example:
```csharp
// partial class generated by EF
public partial class Log
{
	public int Id { get; set; }
	public System.DateTime Date { get; set; }
	public int MachineId { get; set; }
	public string Message { get; set; }
    
	public virtual Machine Machine { get; set; }
}

// your own partial class, with additional property for Log class
public partial class Log
{
   public string FullMessage
   {
      get
      {
         return $"{Machine?.Name}:{Date.ToShortDateString()} {Message}";
      }
   }
}
```

## Code First in EF
Code Frst approach allows you to first write your domain model classes and then create database schema according to those classes. EF brings you stuff as Data Annotations and Fluent API to be able to specify some details about how to generate tables and columns (not null, primary key etc). It also allows to update the DB structure without deleting tabeles (Migrations). Moreover, you can also specify some test data that will be put into the database after each creation - that's a quite useful feature. In general, Code First approach is worth taking into consideration while creating application domain.

### Basic domain structure
Here we can see two classes with **one-to-many** relationship. One *Machine* can have many *Logs*. So wht we have to do is to add **ICollection** of type *Log* in *Machine* class and a *Machine* property in *Log* class so that would be clear that it is one-to-many relationship.<br />
Moreover we have to define our own class that will inherit from **DBContext**. It must have two **DBSet** collections of *Machine* and *Log* types. And actually that's all, we can now use our model domain classes after configuring connection string.
```csharp
public class Log
{
	public int Id { get; set; }
	public string Message { get; set; }
	public DateTime Date { get; set; }
	public int MachineId { get; set; }
	public Machine Machine { get; set; }
}

public class Machine
{
	public int Id { get; set; }
  	public string Name { get; set; }
  	public MachineType? Type { get; set; }
  	public virtual ICollection<Log> Logs { get; set; }
}

public class ExampleContext : DbContext
{
	public ExampleContext() : base("name=Example"){}
	public DbSet<Log> Logs { get; set; }
	public DbSet<Machine> Machines { get; set; }
}
```

### Disable pluralized table names
Deafult table names generated by EF are pluralized, so for example the table generated for the *Log* class will be named *Logs*. If you don't like this convention you can turn it off with Fluent API by overriding **OnModelCreating** method of your context class, here is how to do this:
```csharp
protected override void OnModelCreating(DbModelBuilder modelBuilder)
{
	modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
}
```

### Data Annotations
Data Annotations serve to set a bit more details about how to map your class properties into database columns. For example you can define which properties cannot be null with **Required** attribute or what is the maximum size of string (or other type) with **MaxLength** attribute. We can also ignore some properties and not map them at all with **NotMapped** attribute, but if a property has only a getter or only a setter it won't be mapped anyway, even without the attribute. Table name and schema can also be defined as wella as columns type and order. See the example:
```csharp
[Table("LogMaster", SchemaName="admin")]
public class Log
{
	[Required]
	[MaxLength(256)]
	public string Message { get; set; }
	
	[Column("LogDate", Order=1, TypeName="smalldate")]
	public DateTime Date { get; set; }
	
	//[NotMapped] - we don't need this attribute 
	//because this property has only getter so it won't be mapped anyway
	public string FullMessage
	{
		get
		{
    			return $"{Machine?.Name}:{Date.ToShortDateString()} {Message}";
		}
	}
}
```

### Fluent API
Fluent API serves for the same goal as Data Annotations but allow to do much more! All the Fluent API stuff goes inside of the **OnModelCreating** method of context class. Here we seen an example where we change the name of a column that will be generated and its type:
```csharp
protected override void OnModelCreating(DbModelBuilder modelBuilder)
{
   modelBuilder.Entity<Log>()
      .Property(p => p.Date)
      .HasColumnName("LogDate")
      .HasColumnType("smalldatetime");
}
```
A nice thing you can achieve with **Fluent API** is to split your model class into two separate tables! Here is how to do this:
```csharp
protected override void OnModelCreating(DbModelBuilder modelBuilder)
{
   modelBuilder.Entity<Machine>()
      .Map(m =>
      {
         m.Properties(p => new { p.MachineId, p.MachineName});
         m.ToTable("Machine");
      })
     .Map(m => {
         m.Properties(p => new { p.MachineId, p.Type, p.SerialNumber, p.ProductionDate });
         m.ToTable("MachineDetail");
      });
}
```
Be careful, to later match the rows from two separate tables you should attach *MachineId* for both of them.

### Migrations
Migrations allow the database to be update according to the change made in model class code, without having to delete and recreate the tables (what of course means loosing data) or altering the structure by hand (which means loosing a lot of time).<br />
There are two main types of migrations: Automatic and Code-based. Automatic Migration is implicit and as the name suggests totally automatic. It is easy to use but very difficult to debug if some problems will occur. Code-based Migration allows you to have full control over your database structure, so it is really good to choose this type of migration, but if you expect your database to be allways up-to-date, not support multiple versions then Automatic Migration may serve you well. 

### Automatic Migration
To enable migrations follow the steps: ->Tools ->NuGet Package Manger ->Package Manager Console, and type the following command in the PM console:
```powershell
enable-migrations -ProjectName 'Example.Domain'
```
The **Configuration** class should be generated for you in **Migration** folder. Change its constructor so it looks like this:
```csharp
public Configuration()
{
	AutomaticMigrationsEnabled = true;
	AutomaticMigrationDataLossAllowed = true; //be careful with this one!
    ContextKey = "Example.Domain.ExampleContext";
}
```
Go to your context class and change its contructor to:
```csharp
public ExampleContext() 
	: base("name=Example")
{
   Database.SetInitializer
      (new MigrateDatabaseToLatestVersion
         <ExampleContext, Migrations.Configuration>("CodeFirst"));
}
```
Now you an change your model and it should be automatically updated.

### Code-based Migration
To use Code-based Migrations you must `enable-migrations` in Package Manager Console, but **AutomaticMigrationsEnabled** in **Configuration** class must be set to **false**. And just the same like in Automatic Migration you must put **Database.SetInitializer** call in your db context class constructor.<br />
Now you can change something in your model classes. Anything. After you make a change, run the following commands in Package Manager Console:
```powershell
add-migrations 'Migration name' -ProjectName 'Example.Domain'
update-database -verbose -ProjectName 'Example.Domain'
```
In case of some problems difficult to resolve try using the following commands:
```powershell
add-migration initial -ignoreChanges -ProjectName 'Example.Domain'
update-database -verbose -targetMigration:'Migration name' -ProjectName 'Example.Domain'
```

### Seed
In **Configuration** class that was added to enable migrations, there is a method called **Seed**, it allows us to put some code there that will be executed after migrations, for example adding some test data. It is quite useful, here is some examle:
```csharp
protected override void Seed(ExampleContext context)
{
   context.LogCategories.AddOrUpdate(new[] {
		new LogCategory { Id = 1, Name = "Application" },
		new LogCategory { Id = 2, Name = "System" },
		new LogCategory { Id = 3, Name = "Security" },
		new LogCategory { Id = 4, Name = "User" }
   });
}
```

### Concurency check
Use such configuration:
```csharp
[TimeStamp]
public byte[] RowVersion { get; set; }
```
for automatic concurency check.

### Unit Testing EF Core with NUnit
```csharp
using NUnit.Framework;
using Microsoft.EntityFrameworkCore;
using Microsoft.Data.Sqlite;
using System;
 
namespace Corp.Project..Tests.Core
{
   [TestFixture]
   public class InMemoryBaseTests<T> where T : DbContext, new()
   {
      //Microsoft.EntityFrameworkCore.Sqlite
      protected DbContextOptions<T> options;
      protected T context;
      protected SqliteConnection connection;
 
      [SetUp]
      public virtual void SetUp()
      {
         connection = new SqliteConnection("DataSource=:memory:");
         connection.Open();
 
         options = new DbContextOptionsBuilder<T>()
            .UseSqlite(connection)
            .Options;
 
         context = Activator.CreateInstance(typeof(T), new object[] { options }) as T;
         context.Database.EnsureCreated();
      }
 
      [TearDown]
      public virtual void TearDown()
      {
         connection.Close();
      }
   }
}
```

## Linq

### Linq statements and functions
* **Take, Skip and Orderby** - Allow to modify the final collection<br />
Take(int), TakeWhile(x => x.property == value)<br />
Skip(int), Skip(x => x.property == value)<br />
OrderBy, ThenBy, OrderByDescending, ThenByDescending, Reverse
* **Set operations**<br />
Concat, Union, Distinct, Intersect, Except
* **Types** - Linq allows to get items from a collection of a selected type and also cast items<br />
ToArray, ToList, ToDictionary
```csharp
input.OfType<string>();
input.Cast<string>();
```
* **Single items**<br />
First, FirstOrDefault, Last, LastOrDefault,<br />
Single, SingleOrDefault, ElementAt, ElementAtOrDefault<br />
DefaultIfEmpty
* **Quantifiers**<br />
Contains, Any(x => condition), All(x => condition), SequenceEqual
* **Generators** - Allow to generate collection.
```csharp
Enumerable.Empty<Employee>();
Enumerable.Range(5, 8);
Enumerable.Repeat("a", 10);
```

##### FirstOrDefault vs. SingleOrDefault
**FirstOrDefault** returns the first element of given collection no matter how many items it contains while **SingleOrDefault** will throw an exception if given collection will contain more than one item, otherwise it will return this single item.

### Best practices and common mistakes
* Check if any item exists in a collection
```csharp
if(dataCollection.Any()){ ... } // + GOOD
if(dataCollection.Count() > 0){ ... } // - BAD
```
* Order by more than one property
```csharp
dataCollection.OrderBy(x => x.name).ThenBy(x => x.age); // + GOOD
dataCollection.OrderBy(x => x.name).OrderBy(x => x.age); // - BAD
```
* Count big amount of data
```csharp
dataCollection.CountLong; // + GOOD
dataCollection.Count; // - BAD
```

### Group by multiple columns
```csharp
var result =
    from pp in productionPlanData
    group pp by new 
    {
        pp.ProductionLine,
	pp.ProductionStartHour
    }
    into groupedPlan
    select new GroupedPlan 
    {
        Line = groupedPlan.Key.ProductionLine,
	Hour = groupedPlan.Key.ProductionStartHour,
	PlanItems = groupedPlan.ToList()
    };
```

### Join
Here we've got very simple example. There are two structures, one with recipes and other with reviews. What we want to achieve is to get as a result a list of recipes toegether with their reviews. So here is how we do that:
```csharp
Recipe[] recipes = 
{
   new Recipe {Id = 1, Name = "Mashed Potato"},
   new Recipe {Id = 2, Name = "Crispy Duck"},
   new Recipe {Id = 3, Name = "Sachertorte"}
};
Review[] reviews = 
{
   new Review {RecipeId = 1, ReviewText = "Tasty!"},
   new Review {RecipeId = 1, ReviewText = "Not nice :("},
   new Review {RecipeId = 1, ReviewText = "Pretty good"},
   new Review {RecipeId = 2, ReviewText = "Too hard"},
   new Review {RecipeId = 2, ReviewText = "Loved it"}
};

var query = 
    from recipe in recipes
    join review in reviews 
    on recipe.Id equals review.RecipeId
    select new 
    {
        RecipeName = recipe.Name,
        RecipeReview = review.ReviewText
    };
```

### Multiple join condintions
It is often required to specify more than one join conditions and it is very easy to do with Linq, here is an example of the syntax:
```csharp
var data = 
   from x1 in d1
   join y1 in d2
   on new { A = x1.Prop1, B = x1.Prop2 } equals new { A = y1.P1, B = y1.P2 }
   select new 
   {
      Name = y1.Name,
      Quantity = x1.Qty
   }
```
A very important thing to remember is that the names of properties of the anonymous objects for the join conditions must have exactly the same names, otherwise an exeception will be thrown.

### Use delegate to define where clauses
Using delegates of type **Func<T, bool>** is a smooth way to change the **where** clause in the runtime depending on given condition. See an example:
```csharp
IEnumerable<Student> GetBestStudents()
{
	Func<Student, bool> isGoodStudent = s => s.Grade > 4;
	return GetStudents(isGoodStudent).OrderByDescending(s => s.Grade).Take(10);
}

IEnumerable<Student> GetWorstStudents()
{
	Func<Student, bool> isBadStudent = s => s.Grade < 3;
	return GetStudents(isBadStudent).OrderBy(s => s.Grade).Take(10);
}

IEnumerable<Student> GetStudents(Func<Student, bool> where)
{
	return _uow.Query<Student>().Where(where);
}
```
The above example is totally correct but one thing could be done a lot better. In this form, the **Where** method inside of the *GetStudents* will return **IEnumerable** instead of **IQueryable**. In some cases it is acceptable or even desired but here it would be much better to get the **IQueryable** because there are other Linq operation performed on the result of *GetStudents* method, **OrderBy** and **Take**. **OrderBy** and **Take** will work on the whole collection of students that are good or bad which is unnecessary because we only want to get 10 students - **Take(10)**. If *GetStudents* would return **IQueryable** an SQL query would be generated and executed and it would be much faster here. 
There is **no** override of **Where** method that takes **Func<T, bool>** and returns **IQueryable**. An parameter of type **Expression<Func<T, bool>>** must be passed instead, so in general the change to the above code is not too big and finally it should look like this:
```csharp
IEnumerable<Student> GetBestStudents()
{
	Expression<Func<Student, bool>> isGoodStudent = s => s.Grade > 4;
	return GetStudents(isGoodStudent).OrderByDescending(s => s.Grade).Take(10);
}

IEnumerable<Student> GetWorstStudents()
{
	Expression<Func<Student, bool>> isBadStudent = s => s.Grade < 3;
	return GetStudents(isBadStudent).OrderBy(s => s.Grade).Take(10);
}

IEnumerable<Student> GetStudents(Expression<Func<Student, bool>> where)
{
	return _uow.Query<Student>().Where(where);
}
```

### Create Linq to SQL domain project
->Right click on project (Class Library) ->Add New Item ->Data ->**Linq to SQL Classes**<br />
->Server Explorer ->Right click on Data Conections ->Add Connection<br /> 
->Drag and drop tables that you want import and rebuild project from your new connection<br />
Example usage in the code:
```csharp
TestDBDataContext dc = new TestDBDataContext ();
List<Customer> customers = dc.Customers.ToList();
Customer customer = dc.Customers.FirstOrDefault();
dc.Customers.DeleteOnSubmit(customer); //there is also InsertOnSubmit
```

### Change connection string in Linq to SQL
->Open .dbml file ->Properties ->Connection

### Stored procedures in Linq to SQL
->Server Explorer ->Connection ->Select your sever ->Stored Procedures ->Drag procedures to the window next to the model schema
Example usage in the code:
```csharp
TestDBDataContext dc = new TestDBDataContext ();
List<SomeStoredProcedureResult> results = dc.SomeStroredProcedure();
```

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

## T-SQL 
**Transact-SQL** is Microsoft extension for SQL and it is used in Microsfoft SQL Server. It is really complex, actually T-SQL is full featured programming language with variables, procedures, functions, transactions, error handling and many many more. Probably the best SQL dialect ever!
 
### Stored procedures
One of the most important SQL features! A poor thing is that almost every database management system has its own syntax to define stored procedures. You can use transactions, variables, input and output parameters and many more! 
```sql
CREATE PROCEDURE EmployeeReport
(
    @StartDate datetime = '2017-01-01 00:00:00.000' --a parameter with default value
)
AS
BEGIN
    SELECT *
    FROM Employees
    WHERE HireDate > @StartDate
END

--Usage:
EXEC EmployeeReport
```

### TVF
TVF (Table Valued Function) or UDF (User Defined Function) are SQL functions that return tables and their results may be used in a query in **SELECT**, **WHERE** or **HAVING** statement. Their definition may look like stored procedures but functionality is rather closer to views.
```sql
CREATE FUNCTION EmployeeReport
(
    @StartDate datetime = '2017-01-01 00:00:00.000' --a parameter with default value
)
RETURNS TABLE
AS
RETURN
    SELECT *
    FROM Employees
    WHERE HireDate > @StartDate

--Usage:
SELECT EmployeeNumber FROM dbo.EmployeeReport('2017-06-01 00:00:00.000')
```
It is good to know that there are quite many other differences bettween UDFs and procedures. You cannot use **INSERT**, **UPDATE** or **DELETE** inside of a function. Also you cannot change the function's parameters as you can do in procedures (with **out** keyword). It is impossible to use transactions inside of a function which make sense if you cannot change anything. A function must take at least one parameter and must return a value (procedure mustn't). You cannot call stored procedure inside of a function and you cannot use **try-catch** block.

### Case
Case statement allows to select some specified value depending on some column. It is like switch statement in C# or C++. It is very easy to use and sometimes life-saving!
```sql
SELCT CASE [Type] 
	WHEN 0 THEN 'Normal'
    WHEN 1 THEN 'Important' 
    WHEN 2 THEN 'Critical'
FROM Task
```
Really nice use of case statement is to return some specified value if some column is **null**.
```sql
SELECT CASE 
	WHEN [Image] IS NULL THEN 'NO_IMAGE'
    ELSE 'IMAGE_OK'
    END
FROM Employee
```

### Coalesce 
**Coalesce** can be used to set some default value that will be returned in results instead of **null**. It is easy to use and very handy and useful! Here in the following example everytime when there will be **null** in *Work* column, the value *Unemployeed* will be returned.
```sql
SELECT [Name], COALESCE([Work], 'Unemployeed')
FROM Employee
```
Inside **Coalesce** some statements can be used, see the following example:
```sql
SELECT
	COALESCE(CASE du.NewName
		WHEN '' THEN NULL
		WHEN '-' THEN NULL
		ELSE du.NeweName 
		END, d.Name) AS Name
FROM Department d
LEFT OUTER JOIN [DeptUpdate] du 
ON d.CostCenter = du.CostCenter AND d.Name = du.Name
```

### Rollup 
**Rollup** is an another way to group date. It groups the result by specified hierarchy. In the following example *MovementHistoryReport* will be grouped first by *Week* and then each group will be internally grouped also by *Location*.
```sql
SELECT  COALESCE([Week], 'TOTAL'), 
		[Location], 
        COUNT(*) AS WrongCount
FROM MovementHistoryReport
GROUP BY ROLLUP([Week], [Location])
```

### CTE
**Common Table Expression** allows to extract some parts of a query, especially subqueries, into a structure that is similar to a temporary table or a view and can be used in your query to make it much more readable and cleaner. This is by far the most useful syntax structure to build advanced and complex SQL queries that will still be very clean and easy to understand. Moreover what is worth knowing, CTE has better efficiency for large data sets than most other methods (but worse for small). Here is a very simple example presenting the syntax:
```sql
WITH TmpEmployee AS (
	SELECT [EmployeeNo], [Name] 
    FROM Employee
 ),
 TmpAccess As (
	SELECT [EmployeeNo], [Date] 
    FROM EmployeeAccess
 )
 SELECT * 
 FROM TmpEmployee te
 JOIN TmpAccess ta ON te.[EmployeeNo] = ta.[EmployeeNo]
 WHERE [Name] LIKE '%Kozak%'
```
Here you can see a bit more complex examplem where CTE allows to keep the query very simple and easy to understand!
```sql
WITH CommentCount AS (
	SELECT EmployeeOid, COUNT(Oid) AS CommentCount
	FROM Comment
	WHERE GCRecord IS NULL AND Date > '2017-06-01 00:00:00.000'
	GROUP BY EmployeeOid
),
LeaderTmp AS (
	SELECT EmployeeOid, SectionOid
	FROM Leader
)
SELECT 
	e.Name, e.EmployeeNo, s.Name as Section, ll.Line, 
    COALESCE(cc.CommentCount, 0) AS [Count], e.Title
FROM LeaderTmp lt 
LEFT OUTER JOIN CommentCount cc ON lt.EmployeeOid = cc.EmployeeOid
LEFT OUTER JOIN Employee e ON lt.EmployeeOid = e.OID
LEFT OUTER JOIN Section s ON lt.SectionOid = s.OID
LEFT OUTER JOIN LayoutLocation ll ON s.LayoutLocationOid = ll.OID
WHERE e.Status != 'Terminated' AND ll.Line IS NOT NULL
```
In the given example, *Comment* can be joined with *Leader* by *EmployeeOid* to count how many comments has each leader. To achieve this goal, first we've got CTE with comments and then we've got CTE with leaders. Then we left outer join those two CTE. It must be this kind of join because we want to see also leaders that have no comments at all and for **null** values in *CommentCount* using **coalesce** we put there 0 in results.<br />
This is a great example of how CTE can keep complex queries very tidy and a good example how to count some rows with left outer join, allowing us to see where there are no associated rows.

### Merge
**Merge** statement allows to *compare* two tables and decide what to do with the differences between, to do some inerts, update or deletes. It can express quite a lot with just a few lines of code. The following query is a great example. It compares *Employee* and *NewEmplImport* tables basing on *Oid* field (it looks similar to **join**) and then when two rows match in both tables, the first one is updated according to the second. All not matching rows are added to the first table. This way *Employee* will have its old content but also all the new data from *NewEmplImport*. This operation is sometimes called **upsert** as it is a mix of **up**date and in**sert**.
```sql
MERGE Employee AS T       --Target
USING NewEmplImport AS S  --Source
ON T.Oid = S.Oid
WHEN MATCHED THEN
	UPDATE SET T.SalesAmount = S.SalesAmount
WHEN NOT MATCHED THEN
	INSERT (Name, Number) VALUES (S.Name, S.Number);
```
Merge can be combined with **CTE** becoming really powerfull combo. Here is an example:
```sql
WITH DepartmentUpdate AS (
	SELECT
		d.Name,
		COALESCE(CASE du.ChangeName
			WHEN '' THEN NULL
			WHEN '-' THEN NULL
			ELSE du.ChangeName 
			END, d.Name) AS [NewName],
		du.CostCenter,
		CASE du.[Delete]
			WHEN 'delete' THEN 20171010
			ELSE NULL
			END AS GCRecord
	FROM Department d
	LEFT OUTER JOIN [DeptUpdate$] du 
	ON d.CostCenter = du.CostCenter AND d.Name = du.Name
)
MERGE Department AS T
USING DepartmentUpdate AS S
ON T.Name = S.Name AND T.CostCenter = S.CostCenter
WHEN MATCHED THEN
	UPDATE SET 
		T.Name = S.[NewName],
		T.GCRecord = S.GCRecord;
```

### Date-time functions
Handling dates is very often used and crucial skill while programming in SQL. Thankfully there are few extremely useful and easy to use functions that makes programmers lifes easier. 
```sql
SELECT GETDATE() --returns current datetime
SELECT DATEPART(DAY, GETDATE())
SELECT DATEPART(WEEK, GETDATE())
SELECT DATEPART(MONTH, GETDATE())
SELECT DAY(GETDATE())
SELECT MONTH(GETDATE())
SELECT YEAR(GETDATE())
SELECT DATEDIFF(WEEK, GETDATE(), '1995-05-25 00:00:00.000')
SELECT DATEDIFF_BIG(WEEK, GETDATE(), '1995-05-25 00:00:00.000')
SELECT EOMONTH('1995-05-25 00:00:00.000') --returns the last day of the month of given date
SELECT DATEADD(YEAR, 10, GETDATE())
```

### Convert string of yyyyMMddhhmmss format to datetime
It is very common that a string has to be converted to datetime, but the format of `yyyyMMddhhmmss` may cause some more problems. You can use the **STUFF** function to change the format of the string, put some chars into the string and prepare it to be converted, see the example:
```sql
SELECT CAST(STUFF(STUFF(STUFF('20180525222200', 13, 0, ':'), 11, 0, ':'), 9, 0, ' ') AS DATETIME)
--it will create the string: '20180525 22:22:00', and such string can be easily converted
```

### Find rows from last 20 minutes
A nice use case for **DATEDIFF** function is to find all the rows from last 20 minutes by some date. Here is an example:
```sql
SELECT ScanDate, Code FROM Material
WHERE DATEDIFF(MINUTE, ScanDate, GETDATE()) < 20
```
Be careful with **DATEDIFF** because it can be very slow in comparison with simple datetime comparison. The above query can be also written like this - being quite faster:
```sql
SELECT ScanDate, Code FROM Material
WHERE ScanDate > DATEADD(MINUTE, -20, GETDATE())
```

### Complex order by
It is possible to switch the column that you want to use for **order by** using **case** statements, so that some data will be ordered by different column than other. Nice trick!
```sql
SELECT * 
FROM Employees
ORDER BY Sex, 
	CASE Sex
    WHEN 'M' THEN Name
    WHEN 'F' THEN CAST(Birthdate AS NVARCHAR)
    ELSE EmployeeNumber
    END
```
Remember that all of the columns you put in **case** statement to order by must be of the same type, otherwise you will have to cast them.

### Find a table by name or phrase
```sql
SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Impo%Data'
```

### Create table if not exists
In many SQL scripts it may be useful to create a table only if it doesn't exist yet. To make it you just have to use the **if not exists** expression that will check the result of a little query trying to find a table with the given name. If the result set will be empty the **create table** command will be executed: 
```sql
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ImportantData' AND xtype='U')
    CREATE TABLE [Corpo].[dbo].[ImportantData]([Text] [varchar](256) NULL);
```
Also you can make it like this (which is really great way):
```sql
IF OBJECT_ID('[dbo].[ImportantData]') IS NULL
    CREATE TABLE [dbo].[ImportantData]([Text] [varchar](256) NULL);
```

### Transaction with Try/Catch
It might be a very good idea to put a transaction in try-catch block, here is how to do it correctly:
```sql
BEGIN TRY
BEGIN TRANSACTION
--sql code
COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@trancount > 0
        ROLLBACK TRANSACTION
    ;THROW
END CATCH
```
Read more, much more, [here](http://www.sommarskog.se/error_handling/Part1.html).

### Strings with diacritical marks
To be able to store strings with diacritical marks or even more - different alpabets, you should use **nvarchar** type (which uses UTF) and mark the string as unicode with **N** prefix:
```sql
SELECT 'ęóąśłżźć' --eoaslzzc
SELECT N'ęóąśłżźć' --ęóąśłżźć
```

### How to get string length with spaces
There is a very popular function in T-SQL called **LEN**, it is often used to get the length of some string value. It has one disadvantage that it is not counting spaces, so if you want to know the total length of the raw string you have to use another function called **DATALENGTH**. It is very simple to use. Here you can see an example showing the difference between both functions:
```sql
SELECT LEN(' '), DATALENGTH(' ') --returns 0 and 1
```
Be careful with **nvarchar** type because **DATALENGTH** actually returns the number of bytes of a given string, for **nvarchar** it will return the number of characters multiplied by two because every char is encoded as 16 bits (2 bytes). See the result of the following query as proof:
```sql
SELECT DATALENGTH('A'), DATALENGTH(N'A') --returns 1 and 2
```

## SQL Server
Microsoft SQL Server is complex Database Management System (DBMS), shiped by Microsoft, implementing T-SQL.

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

### Basic query statistics
You can turn on few features that will give you basic query statistics after execution (they will put in *Messages* tab, next to *Results* tab).
```sql
set statistics io on;
set statistics time on;
set nocount off;
```
This method of measuring query effciency is not very good since it is not  very accurate. <br >
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
And remember this, in case of joins: **Merge join** is faster than **loop join** or **hash join**. So if you will see that your join is done by loop or hash join, there is a place for optimization.

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

### Open Activity Monitor
To open Activity Monitor just press **CTRL + ALT + A**

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

Server srv = new Server("srv114);
Console.WriteLine(srv.ToString());
foreach(Database db in srv.Databases)
{
     Console.WriteLine(db.Name + " " + db.Tables.Count.ToString());
}
```

## SQLCLR 
SQLCLR is a technology that allows to store and execute CLR code inside SQL Server. It allows to write stored procedures, user defined functions with C# rather than with TSQL. It is available since SQL Server 2005 and is disabled as default.

### Unlock SQLCLR
```sql
EXEC sp_configure 'show advanced option', '1'; 
reconfigure;
EXEC sp_configure 'CLR Enabled', 1;
reconfigure;
```

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
On 64-bit systems the default Data Source configuration tool manges 64-bit sources and drivers. If you need to use 32-bit software then you have to use 32-bit Data Source configuration tool which you will find here:
`C:\Windows\SysWOW64\odbcad32.exe`

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

### Backup
* `.backup main D:\\DB\\db.bak`
* `.restore main D:\\DB\\db.bak`

### Format results
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

## XML

### Linq to XML 
* Example XML<br />
This document will be used for the following C# examples: 
```xml
<people>
	<person id="4245323">
		<lastName>Jones</lastName>
		<firstName>Henry</lastName>
		<address>
			<city lang="en">Cracow</city>
			<street>Żeromskiego</street>
			<houseNumber>43</houseNumber>
			<appartmentNumber>10</appartmentNumber>
			<postalCode>31-400</postalCode>
		</address>
		<phoneNumber>555-111-444</phoneNumber>	
	</person>
</people>
```
* Read<br />
There two ways to retrive XML data. You can load XML document as a string and parse it or you can load some XML file like in the example below:
```csharp
XDocument xdoc = new XDocument();
xdoc = XDocument.Load("file.xml");
```
* Get attribute value
```csharp
int id = 4245323;
XElement person = xdoc.Descendants().First(x => x.Attribute("id").Value == id.ToString());
XAttribute personId = person.Attributes().First();
```
Linq to XML allows you to use methods as **Descendants** or **Attributes** for every element. They return, accordingly, the complete list of descendants of the given element or its attribute list. You can use typical Linq methods with such list, like **FirstOrDefault**, **OrderBy**, etc.<br />
You can also set attribute value like this:
```csharp
person.SetAttribute("id", 23234234);
```
There are many other very useful methods in Linq to XML, like **SetValue** and so on!
* Add new element and delete existing element
```csharp
XElement newPerson = 
	new XElement("person", 
		new Attribute("id", 134523),
		new XElement("firstName", "Lucy"),
		new XElement("lastName", "Richards"),
		new XElement("address", 
			new XElement("city", "Smallville"),
			new XElement("street", "Smallville"),
			new XElement("houseNumber", "14")
		)
	);	
xdoc.Element("people").Add(newPerson);  
xdoc.Descendants("person").Where(x => x.Element("lastName").Value == "Henry").Remove();
```
To create new elements you can create new instance of **XElement** class. Its constructor requires the name of the element that is going to be created and its content. As content, the list of other nested **XElement** instances may be given or **Attribute** class instance or simply some literal value (string, integer etc.). 

### XmlDocument class
It is another way to read and manipulate XML in C#. It reads an XML document into memory. A nice thing about it, is that it alows to execute XPath queries against XML document.
* Read 
```csharp
XmlDocument doc = new XmlDocument();
doc.Load("file.xml");
string id = doc.DocumentElement.ChildNodes[0].Attributes["id"].Value;
```
* XPath
```csharp
XmlNodeList phoneNumberNodes = doc.SelectNodes("//person[@id!='34252']/phoneNumber");
XmlNode streetNode = doc.SelectSingleNode("//person[last()]/address/street");
string streetName = streetNode.InnerText;
```
* Add
```csharp
XmlNode person = doc.CreateElement("person");

XmlAttribute id = doc.CreateAttribute("id");
id.Value = 234235;
person.Attributes.Append(id);

XmlNode lastName = doc.CreateElement("lastName");
lastName.InnerText = "Kozak";
person.AppendChild(lastName);

doc.DocumentElement.AppendChild(person);
doc.Save("file.xml");
```

## Useful links

#### Database programming - general stuff
[SQLPedia - po polsku](http://www.sqlpedia.pl/) <br />
[SQL Server Central - Stairway](http://www.sqlservercentral.com/stairway/) <br />
[SQL Shack - SQL Server articles](https://www.sqlshack.com/)<br />
[Many free e-books about DB programming](https://www.syncfusion.com/resources/techportal/ebooks) <br/>
[Connection strings](https://www.connectionstrings.com/) <br />
[Advanced free-books](https://www.red-gate.com/simple-talk/books/sql-books/) <br />
[SQL Server articles](http://www.sommarskog.se/)<br />

#### Entity Framework
[EF Tutorial](http://www.entityframeworktutorial.net/) <br />

#### EF Core Testing
[Database Integration Testing with Entity Framework Code First in .NET Framework](https://medium.com/@reyronald/database-integration-testing-with-entity-framework-code-first-in-net-framework-2c669153cf03)<br />
[Testing with SQLite](https://docs.microsoft.com/pl-pl/ef/core/miscellaneous/testing/sqlite)<br />
[Testing with InMemory](https://docs.microsoft.com/pl-pl/ef/core/miscellaneous/testing/in-memory)<br />

#### SQL Server
[SQL Server Agent](https://stackoverflow.com/questions/6712811/how-do-i-create-a-step-in-my-sql-server-agent-job-which-will-run-my-ssis-package/6713464#6713464) <br />
[SQL Documentation](https://docs.microsoft.com/pl-pl/sql/#pivot=sdkstools&panel=sdkstools-all) <br />
[Optymalizacja](http://www.sqlpedia.pl/tag/optymalizacja/) <br />
[Execution Plan E-Book](https://www.red-gate.com/library/sql-server-execution-plans-2nd-edition)<br />
[Cursors options performance](https://sqlperformance.com/2012/09/t-sql-queries/cursor-options)<br />

#### BCP, SQLCMD and other tools
[BCP](https://docs.microsoft.com/en-us/sql/relational-databases/import-export/import-and-export-bulk-data-by-using-the-bcp-utility-sql-server) <br />
[BCP](http://www.sqlpedia.pl/import-i-export-danych-do-bazy-sql-za-pomoca-bcp/) <br />
[SQLCMD](https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility) <br />
[SQLCMD](http://www.sqlpedia.pl/tag/sqlcmd/) <br />
[Sqlpsx](http://sqlpsx.codeplex.com/) <br />

#### SMO
[SMO Reference](https://technet.microsoft.com/en-us/library/mt571730.aspx) <br />
[Stairway to Powershell](http://www.sqlservercentral.com/stairway/91327/) <br />
[Stairway to SMO](http://www.sqlservercentral.com/stairway/140967/) <br />

#### SSIS
[Deployment 1](http://sqlmag.com/sql-server-integration-services/ssis-deployment-sql-server-2012) <br />
[Deployment 2](https://www.mssqltips.com/sqlservertip/2450/ssis-project-deployment-model-in-sql-server-2012-part-1-of-2/) <br />
[Deployment 3](https://www.sqlshack.com/deploying-packages-to-sql-server-integration-services-catalog-ssisdb/) <br />
[Useful tips](http://www.itprotoday.com/microsoft-sql-server/5-tips-developing-sql-server-integration-services-packages) <br />
[Lookup vs. Merge Join](https://social.technet.microsoft.com/wiki/contents/articles/32009.ssis-lookup-vs-merge-join.aspx) <br />

#### Firebird
[ISQL docs](https://www.firebirdsql.org/pdfmanual/html/isql.html) <br />
[Firebird .Net Provider](https://www.firebirdsql.org/en/net-provider/) <br />
[Firebird FAQ](http://www.firebirdfaq.org/) <br />

#### MongoDB
[Why you should never use MongoDB](http://www.sarahmei.com/blog/2013/11/11/why-you-should-never-use-mongodb/)<br />

#### Markdown
[Markdown cheetysheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) <br />
[Markdown editor](https://jbt.github.io/markdown-editor/) <br />
[Syntax highlighting](https://highlightjs.org/static/demo/) <br />
