# DB Progamming - Tips for beginners
Most useful (but basic) tips and tricks that will make DB programming much easier task. It is not a complex guide from zero to hero, just a set of advices and things that might be usefulf, life- and time-saving.
* XPO
* Entity Framework
* Code First in EF
* Linq
* ADO .Net
* T-SQL
* SQL Server 
* SMO
* SQLCLR ***(in progress)***
* Tools for SQL Server
* SSIS
* SQLite
* Useful links

## XPO
XPO is an ORM (Object-Relational Mapper) shiped by DevExpress. It is quite efficient and easy to use. Really good ORM.

### Create database domain project for your solution
->File ->New ->Project ->Class Library (type of a new project)

### Add ORM Data Model
->Right click on domain project ->Add ->New Item ->**DevExpress ORM Data Model Wizard**<br />
You can then choose if you want to create new database or map your model to already existing database. Whatever you will choose, you have configure connection with your SQL Server instance.

### Add and edit new entity (XPObject)
->Drag and drop XPObject (from Toolbox window) ->Double click on XPObject name to change it
->Right click on field list ->Add new field ->Click on field ->Change field’s type and name in Properties window

### Fields referencing other tables (Foreign Keys)
->In Properties window set type for another XPObject ->Change Persistent Name, for example: reference to table Process should be named ProcessOid (**Persistent Name**), that’s a good practice.<br />
You can also add Association Object. It must start from the referenced XPObject to the referencing one. For example Table Employee referenes table Process, so the association must start from Process. That’s counterintuitive so remember that! 

### Many to many relationships 
Must be done with additional table. For example employee can have many tasks and many tasks can have many employees, so we need 3 tables (XPObjects): Employee, Task and EmployeeTask which will store the assosciation between Employee and Task (Oid numbers only).<br />
There also exists another option, in Toolbox there is ManyToManyRelationshiop that may be helpful.

### Add enum type
->ORMDataModel window (it should be somewhere near to Solution Explorer window) ->Right click on Data Model ->Add New External Type ->Go to Properties window of your new external type and set correct name and namespace of your enum ->Now you should be able to choose your enum type as a type for a field.

### Apply optimistic locking on field instead of the whole row
->Click on XPObject and go to Properties window<br /> ->Set **Optimistic Locking = True** and **Optimistic Locking Behaviour = LockModified**

### Use views from Linked Servers
->Create new XPLiteObject ->Set Persistent property to the name of your view ->Add fields exactly the same as your view has ->Choose one field of XPLiteObject and set its property **Key = True**

### Use stored procedures
**SQL Server:**<br />
->Right click on a procedure ->Properties ->Permissions ->Search ->Browse ->Select the role or user that you want ->Check Grant for Execute in the Permissions table<br /><br />
**XPO Designer:**<br />
->Right click in the background ->Update Model from Database ->Choose your stored procedure<br /><br />
**Code:**
```csharp
SelectedData data = _session.ExecuteSproc("ProcName", new OperandValue(ID));
if (data != null && data.ResultSet != null && data.ResultSet[0].Rows != null)
{
     string employeeName = data.ResultSet[0].Rows[0].Values[4].ToString();
}
```

### Database connection XPO v16.2

In the **ConnectionHelper** class in **Connect** method, before v16 you can use the following code:
```csharp
XpoDefault.DataLayer = XpoDefault.GetDataLayer(ConnectionString, autoCreateOption);
XpoDefault.Session = null;
```
After v16 it throws an exception: **Reentrancy or cross thread operation detected**. It is shown here only for historical and educational purpose.<br />

This is the code you should put there:
```csharp
XPDictionary dict = new ReflectionDictionary();
IDataStore store = 
    XpoDefault.GetConnectionProvider(ConnectionString, AutoCreateOption.SchemaAlreadyExists);
XpoDefault.DataLayer = new ThreadSafeDataLayer(dict, store);
XpoDefault.Session = null;
```

And then, finally you should execute **Connect** method in some *main* file of your application (Program.cs, Global.asax, etc):
```csharp
string connectionString = ConfigurationManager.ConnectionStrings["Connection"].ToString();
IDataLayer dl = XpoDefault
    .GetDataLayer(connectionString, AutoCreateOption.DatabaseAndSchema);
using (Session session = new Session(dl))
{
    System.Reflection.Assembly[] assemblies = new System.Reflection.Assembly[] 
    {
        typeof(User).Assembly
    };
    session.UpdateSchema(assemblies);
    session.CreateObjectTypeRecords(assemblies);
}
ConnectionHelper.ConnectionString = connectionString;
ConnectionHelper.Connect(AutoCreateOption.DatabaseAndSchema);
```

Attention! If you will call **Connect** method before **GetDataLayer** it will throw an exception: **Dictionary cannot be modified while it's being used by the ThreadSafeDataLayer**. 

### Add and delete rows with XPO
Adding a new row is very straightfoward. First create a new instance of some of your domain class and then just commit it.
```csharp
SomeClass newData = new SomeClass(_uow)
{
   someValue = 1,
   someOther = "test",
};
if (_uow.InTransaction)
{
   _uow.CommitChanges();
}
```

Deleting is even easier.
```csharp
SomeClass rowToDelete = _uow.Query<SomeClass>().FirstOrDefault(x => x.oid = 10);
_uow.Delete(rowToDelete);
if (_uow.InTransaction)
{
   _uow.CommitChanges();
}
```

Just be careful when deleting some items from the list. If you will try to delete items (rows) before casting to list, it will throw an exception saying that the collection is modified.
```csharp
//Throws exception
foreach (Employee emp in department.EmployeeCollection)
{
    if (!emp.IsDeleted)
        emp.Delete();
}

//Works well
foreach (Employee emp in department.EmployeeCollection.ToList())
{
    if (!emp.IsDeleted)
        emp.Delete();
}
```

### Moniker error
If you wil encounter **Cannot resolve the moniker** error while trying to open XPO diagram, open the diagram (.xpo.diagram file) as XML and delete the line that causes the error.

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

### Left outer join
Here we want to left outer join *Processes* with *Sections*. Every *Process* is associated to some *Section* and we want make a join basing on this association. To achieve this we must combine **join** statement with **into** statement, and that's it!
```csharp
from section in GetSections()
join process in GetProcesses() 
on section.Oid equals process.Section.Oid into processToSections
```

### Linq triple combo
Here I present quite advanced example of LINQ query with left outer join, group by and select new statements. It is really neat, here you go:
```csharp
List<WorkInstructionSummaryForSection> sectionSummaries =
	(from section in GetSections()
	join instructions in GetInstructions().Where(x => x.Employee != null
                      && x.Employee.Status != "Terminated"
                      && x.Employee.Process != null
                      && x.Employee.Process.Section != null
                      && x.Employee.Process.Section.LayoutLocation != null
                      && x.Employee.Process.Section.LayoutLocation.SummaryLayout != null)
     on section.Oid equals instructions.Employee.Process.Section.Oid 
     into instructionToSections
     from instructionWithSection in instructionToSections.Where(x => x.Employee != null
                      && x.Employee.Process != null
                      && x.Employee.Process.Section != null)
     group instructionWithSection by instructionWithSection.Employee.Process.Section 
     into grouped
     select new WorkInstructionSummaryForSection()
     {
     	Line = grouped.Key.LayoutLocation.Line,
		Section = grouped.Key,
     	Authorized = grouped.Select(x => x.Employee).Distinct().Count(),
		Pending = grouped.Where(x => x.Status != SWSWorkInstructionStatus.Confirmed)
                         .Select(x => x.Employee).Distinct().Count()
     }).ToList();
```
The important thing is to check some properties if they are not null. Especially those which are used for left outer join and grouping. That's extremely important if we want to avoid **Null Reference Exception** and a lot of stress. So keep that in mind - check if something *is not null*.

### Use delegate to define where clauses
Using delegates of type **Func<T, bool>** is a smooth way to change the **where** clause in the runtime depending on some variable. See an example:
```csharp
IEnumerable<Student> GetStudents(bool goodStudentsOnly = true)
{
	Func<Student, bool> isGoodStudent;
	if(goodStudetnsOnly)
		isGoodStudent = s => s.Grade > 4;
	else 
		isGoodStudent = s => true;
	
	return _uow.Query<Students>().Where(isGoodStudent);
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

### Linq to XML 
* Example XML
```csharp
string testXML = @"
<departaments>
   <departament code="a01">Account</departament>
   <departament code="s55">Sales</departament>
   <departament code="mk34">Marketing</departament>
</departaments>
";
```
* Read - There two ways to retrive XML data. You can load XML document as a string and parse it or you can load some XML file.
```csharp
XDocument xdoc = new XDocument();
xdoc = XDocument.Parse(testXML);
xdoc = XDocument.Load("file.xml");
```
* Get attribute value
```csharp
XElement s55 = xdoc.Descendants().First(x => x.Attribute("code").Value == "s55");
XAttribute code = s55.Attributes().First();
```
* Add new element and delete existing element
```csharp
xdoc.Element("departaments").Add(new XElement("departament", "IT"));  
xdoc.Descendants().Where(x => x.Value == "Marketing").Remove();
```
* Print
```csharp
foreach(XElement item in xdoc.Element("departaments").Descendants())
   Console.WriteLine(item.Value);
```
* Generate elements
```csharp
XElement employees = new XElement("employees", 
    from e in employees
    select new XElement("employee", e.Name, new Attribute("age", e.Age))
    );
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
TVF (Table Valued Function) or UDF (User Defined Function) are SQL functions that return tables and their results may be used to query similarily to a typical table or view. Their definition may look like stored procedures but functionality is rather closer to views.
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
SELECT TOP 5 total_worker_time/execution_count AS [Avg CPU Time], 
     SUBSTRING(st.text, (qs.statement_start_offset/2)+1, 
          ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(st.text)
            ELSE qs.statement_end_offset
            END - qs.statement_start_offset)/2) + 1) AS statement_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY total_worker_time/execution_count DESC;
```
The following query returns all the queries from last 10 minutes that were executed in more than 1000000 miliseconds:
```sql
SELECT 
     SUBSTRING(st.text, (qs.statement_start_offset/2)+1, 
     ((CASE qs.statement_end_offset
	   WHEN -1 THEN DATALENGTH(st.text)
	   ELSE qs.statement_end_offset
	   END - qs.statement_start_offset)/2) + 1) AS statement_text,
     *, last_elapsed_time /1000000 AS last_execution_time_in_s
FROM sys.dm_exec_query_stats AS qs 
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
WHERE last_execution_time > DATEADD(MINUTE, -10, GETDATE()) AND last_elapsed_time > 1000000
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
SELECT qt.TEXT AS SQL_Query, usecounts, size_in_bytes, cacheobjtype, objtype
FROM sys.dm_exec_cached_plans p 
CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) qt
WHERE qt.TEXT not like '%dm_exec%
```

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
bcp "select * from Corpo.dbo.Employee" queryout D:\test.csv -S sepmsrv79 -T -c -t ';'
```
Here is an example of importing CSV file to Employee table:
```batch
bcp DB.dbo.Employee in .\data.csv -S sepmsrv79 -T -w -t; -k
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

### Deploy packages from command line
Use ISDeploymentWizard tool to deploy SSIS packages from command line, here is an example:
```batch
C:\Program Files (x86)\Microsoft SQL Server\130\DTS\Binn\isdeplyomentwizard.exe /S /ST:File /SP:data_import.ispac /DS:106.116.82.93/SQL /DT:/SSISDB/Imports/CorpoProject
```
To see how to deploy package from GUI go to *Useful links*.

### Copy only backup from SSIS package
->SSIS Toolbox ->Other Tasks ->Back Up Database Task ->Right click ont the task ->Edit ->Options 
->Copy-only backup

### Debugging packages
Here are two nice features that makes SSIS debugging much easier:<br />
->Right click on the block ->Edit Breakpoints...<br />
->Right click on pipeline (the line connecting two blocks) ->Enable Data Viewer

### Execute package from command line
It is very useful way to get some additional information about some weird errors in SSIS packages. Command line output contains some more information. It is especially useful when you will encounter **VS_NEEDSNEWMETADA** error. Here is how to do that:
```batch
DTEXEC /FILE data_import.ispac
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

## Useful links

##### Database programming - general stuff
[SQLPedia](http://www.sqlpedia.pl/) <br />
[SQL Server Central - Stairway](http://www.sqlservercentral.com/stairway/) <br />
[Many free e-books about DB programming](https://www.syncfusion.com/resources/techportal/ebooks) <br/>
[Connection strings](https://www.connectionstrings.com/) <br />
[Advanced free-books](https://www.red-gate.com/simple-talk/books/sql-books/) <br />

##### XPO
[XPO Documentation](https://documentation.devexpress.com/CoreLibraries/1998/DevExpress-ORM-Tool) <br />

##### Entity Framework
[EF Tutorial](http://www.entityframeworktutorial.net/) <br />

##### SQL Server
[SQL Server Agent](https://stackoverflow.com/questions/6712811/how-do-i-create-a-step-in-my-sql-server-agent-job-which-will-run-my-ssis-package/6713464#6713464) <br />
[SQL Documentation](https://docs.microsoft.com/pl-pl/sql/#pivot=sdkstools&panel=sdkstools-all) <br />
[Optymalizacja](http://www.sqlpedia.pl/tag/optymalizacja/) <br />

##### BCP, SQLCMD and other tools
[BCP](https://docs.microsoft.com/en-us/sql/relational-databases/import-export/import-and-export-bulk-data-by-using-the-bcp-utility-sql-server) <br />
[BCP](http://www.sqlpedia.pl/import-i-export-danych-do-bazy-sql-za-pomoca-bcp/) <br />
[SQLCMD](https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility) <br />
[SQLCMD](http://www.sqlpedia.pl/tag/sqlcmd/) <br />
[Sqlpsx](http://sqlpsx.codeplex.com/) <br />

##### SMO
[SMO Reference](https://technet.microsoft.com/en-us/library/mt571730.aspx) <br />
[Stairway to Powershell](http://www.sqlservercentral.com/stairway/91327/) <br />
[Stairway to SMO](http://www.sqlservercentral.com/stairway/140967/) <br />

##### SSIS
[Deployment 1](http://sqlmag.com/sql-server-integration-services/ssis-deployment-sql-server-2012) <br />
[Deployment 2](https://www.mssqltips.com/sqlservertip/2450/ssis-project-deployment-model-in-sql-server-2012-part-1-of-2/) <br />
[Deployment 3](https://www.sqlshack.com/deploying-packages-to-sql-server-integration-services-catalog-ssisdb/) <br />

##### Markdown
[Markdown cheetysheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) <br />
[Markdown editor](https://jbt.github.io/markdown-editor/) <br />
[Syntax highlighting](https://highlightjs.org/static/demo/) <br />
