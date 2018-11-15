# DevExpress
This is not a documentation or a complete tutorial, just a bunch of tricks and tips that have been useful to me while working with an amazing libraries shipped by DevExpress. Hope you will find something useful or interesting here.

* [XPO](#xpo)
* [ASP.NET MVC Extensions](#asp.net-mvc-extensions)
* [Useful links](#useful-links)

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

## ASP.NET MVC Extensions
DevExpress ships a huge number of ASP.NET MVC Extensions that will make web development much easier. There are grids, lists, menus, charts, buttons and much more.

### Menu

##### Menu
```csharp
@Html.DevExpress().Menu(
     settings =>
          {
               settings.Name = "mainMenu";
               settings.ControlStyle.Font.Size = 12;
               settings.ControlStyle.CssClass = "roundedBorders";

               settings.Items.Add(item =>
               {
                  item.Text = "Summary";
                  item.NavigateUrl = "/Report/Summary";
                  item.Image.IconID = "grid_pivot_16x16";
               });

               settings.Items.Add(item =>
               {
                  item.Name = "ReportsMenu"
                  item.Text = "Reports";
                  item.Image.IconID = "grid_pivot_16x16";
                  item.Items.Add(items =>
                  {
                     items.Text = "Production Report";
                     items.Image.IconID = "chart_drilldownonseries_chart_16x16";
                     items.NavigateUrl = "/Report/Production";
                  });
                  item.Items.Add(items =>
                  {
                     items.Text = "Delivery Report";
                     items.Image.IconID = "chart_kpi_16x16";
                     items.NavigateUrl = "/Report/Delivery";
                  });
           });
}).GetHtml()
```

##### Menu with XML
```csharp
@Html.DevExpress().Menu(
     settings => 
          {
               settings.Name = "mainMenu";
               settings.NavigateUrlField = "NavigateUrl";
          })
          .BindToXML(Server.MapPath("~/App_Data/MainMenu.xmll"), "//MenuItem").GetHtml()
```
```xml
<menu>
     <MenuItem Text="Summary" NavigateUrl="/Report/Summary"></MenuItem>
</menu>
```

## Useful links

#### XPO
[XPO Documentation](https://documentation.devexpress.com/CoreLibraries/1998/DevExpress-ORM-Tool) <br />
