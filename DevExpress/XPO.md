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
->Right click in the background ->Properties ->Generate Stored Procedures<br />
->Right click in the background ->Update Model from Database ->Choose your stored procedure<br /><br />
**Code:**
```csharp
SelectedData data = _session.ExecuteSproc("procName", new OperandValue(ID));
if (data != null && data.ResultSet != null && data.ResultSet[0].Rows != null)
{
     string employeeName = data.ResultSet[0].Rows[0].Values[4].ToString();
}
```
If your procedure is in different scheme than the default one (**dbo**), you have to specify the schema name with the name of procedure, for example if your schema is called **corp** you should call your procedure like this:
```csharp
SelectedData data = _session.ExecuteSproc("corp.procName", new OperandValue(ID));
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

### Unit Testing XPO with NUnit
A really nice way to test logic that works closely with XPO is to use InMemoryDataStore which allows you to create a temporary data store in memory. Here you can see an example of test's base class that creates and deletes the data store:
```csharp
using NUnit.Framework;
using DevExpress.Xpo;
using DevExpress.Xpo.DB;
using DevExpress.Xpo.DB.Helpers;
using System;
 
namespace Project.Tests.Core
{
   [TestFixture]
   public class InMemoryBaseTests
   {
      protected IDisposable[] disposablesOnDisconect;
      protected IDataLayer dataLayer;
      
      protected virtual IDataStore CreateProvider()
      {
         return new InMemoryDataStore(AutoCreateOption.DatabaseAndSchema);
      }
 
      [SetUp]
      public virtual void SetUp()
      {
         IDataStore ds = CreateProvider();
         ((IDataStoreForTests)ds).ClearDatabase();
         dataLayer = new SimpleDataLayer(ds);
      }
 
      [TearDown]
      public virtual void TearDown()
      {
         dataLayer.Dispose();
         if (disposablesOnDisconect != null)
         {
            foreach (IDisposable disp in disposablesOnDisconect)
            {
               disp.Dispose();
            }
         }
      }
   }
}
```
Here is a class that derives from the one above:
```csharp
using Moq;
using Moq.Protected;
using DevExpress.Xpo;
using Project.Logic.Infrastructure;
 
namespace Project.Tests.Core
{
   public class InMemoryBaseLogicTests<T> : InMemoryBaseTests where T : BaseLogic
   {
      protected Mock<T> logicMock;
 
      protected virtual void PrepareMock(UnitOfWork uow)
      {
         logicMock = new Mock<T>(uow);
         logicMock.Protected().Setup<UnitOfWork>("_uow").Returns(uow);
      }
   }
}
```
It extends the class to mock the logic class of given type. And here is a class with unit tests:
```csharp
using NUnit.Framework;
using DevExpress.Xpo;
using Project.Logic;
using System;
using System.Collections.Generic;
 
namespace Project.Tests.Logic
{
   public class UserLogicTests : InMemoryBaseLogicTests<UserLogic>
   {
      [Test]
      public void TestGetAllUsers()
      {
         using(UnitOfWork uow = new UnitOfWork(dataLayer))
         {
            User u1 = new User(uow){ Name = "Albert", Gender = "M" };
            User u2 = new User(uow){ Name = "Paulina", Gender = "F" };
            uow.CommitTransaction();
         }
 
         using (UnitOfWork uow = new UnitOfWork(dataLayer))
         {
            PrepareMock(uow);
            var users = logicMock.Object.GetAllUsers();
            Assert.AreEqual(2, users.Count);
         }
      }
   }
}
```
