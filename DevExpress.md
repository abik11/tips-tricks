# DevExpress
This is not a documentation or a complete tutorial, just a bunch of tricks and tips that have been useful to me while working with an amazing libraries shipped by DevExpress. DevExpress has a huge and very detailed documentation, but sometimes it is difficult to find something there because of its size so I hope you will find something useful or interesting here.

* [XPO](#xpo)
* [WinForms Controls](#winforms-controls)
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

## WinForms Controls
DevExpress developed a really big number of high quality WinForms controls. The only problem with them is that if you will use them once, you will never want to use WinForms without DevExpress again.

### LookUpEdit
LookUpEdit is similar to ComboBox but it has much more functionality.

##### Data binding
```csharp
private XPCollection<UserType> _userTypes = new XPCollection<UserType>(_uow);
private XPCollection<User> _users = _uow.Query<User>().FirstOrDefault(x => x.Oid == userOid);

lueUserType.Properties.DataSource = _userTypes;
lueUserType.Properties.DisplayMember = "Name";
lueUserType.Properties.ValueMember = "This";
lueUserType.Properties.Columns.Clear();
lueUserType.Properties.Columns.Add(new LookUpColumnInfo("Name")); //this column will be displayed in LookUpEdit
lueUserType.Properties.BestFitMode = BestFitMode.BestFitResizePopup;
lueUserType.Properties.SearchMode = SearchMode.AutoComplete;
lueUserType.Properties.AutoSearchColumnIndex = 0;
lueUserType.Properties.DropDownRows = 10;

lueUserType.DataBindings.Add("EditValue", _user, "UserType!", false, DataSourceUpdateMode.OnPropertyChanged);
```

##### Allow manually typing in LookUpEdit
Set the following properties:
* Properties.TextEditStyle = Standard
* Properties.SearchMode = AutoComplete

### Block picture changes in PictureEdit
Set the following properties:
* Properties.ReadOnly = True 
* Properties.ShowMenu = False

## ASP.NET MVC Extensions
DevExpress ships a huge number of ASP.NET MVC Extensions that will make web development much easier. There are grids, lists, menus, charts, buttons and much more.

### Using UnitOfWork in ASP.NET MVC
This is a very simple method and usually not very recommendable, but in small applications it may be useuful, just remember it is not a best practice. Access data layer should be spearated from controllers.
```csharp
const string UnitOfWorkKey = "UnitOfWorkKey";
public static UnitOfWork uow
{
     get
     {
          if (HttpContext.Current.Items[UnitOfWorkKey] == null)
          {
               HttpContext.Current.Items[UnitOfWorkKey] = new UnitOfWork();
          }
          return (UnitOfWork)HttpContext.Current.Items[UnitOfWorkKey];
     }
}
```

### Grid
DevExpress brings a really good grid control to MVC, it is worthing using although some less common configuration may be a bit difficult.

##### Add custom column to grid
```csharp
GridViewSettings settings = new GridViewSettings();
settings.KeyFieldName = "Oid";
settings.Name = "Project";
settings.CallbackRouteValues = new { Controller = "Report", Action = "ProjectsGridViewPartial" };
settings.Columns.Add("Oid", "Project ID");
settings.Columns.Add(column => { column.Caption = "Cost"; });

settings.CustomColumnDisplayText = (sender, e) => 
{
    if (e.Column.Caption == "Cost") 
    {
        int projectOid = (int)e.GetFieldValue("Oid");
        e.DisplayText = ProjectDataProvider.GetProjectCost(projectOid).Sum(x => x.Cost).ToString();
    }
};
```

##### Cell color - Grid View
```csharp
settings.HtmlDataCellPrepared = (sender, e) =>
 {
    if (e.DataColumn.FieldName == "Status")
    {
        if ((ProjectStatus)e.GetValue("Status") == ProjectStatus.Reject)
            e.Cell.BackColor = System.Drawing.Color.FromArgb(0xFF, 0xAE, 0xAE);
        else if ((ProjectStatus)e.GetValue("Status") == ProjectStatus.Finished)
            e.Cell.BackColor = System.Drawing.Color.FromArgb(0xB2, 0xFF, 0xC4);
    }
};
```

### Chart
DevExpress charts for MVC are not easy to configure but the effect is really great. An interesting thing to note is that the chart is generated as an image and put on the web application, it is not generated as HTML.

##### Chart
```csharp
@Html.DevExpress().Chart(settings =>
{
    //GENERAL
    settings.Name = ProductionPlan";
    settings.Width = 1500;
    settings.Height = 900;

    //SERIES - you can add more than only one series
    Series chartSeries = new Series("Plan", DevExpress.XtraCharts.ViewType.Bar);
    chartSeries.ArgumentScaleType = DevExpress.XtraCharts.ScaleType.Auto;
    chartSeries.ArgumentDataMember = "Month";
    chartSeries.ValueDataMembers[0] = "YearPlan"; 
    ((BarSeriesView)chartSeries.View).BarWidth = 0.4;
    ((BarSeriesView)chartSavingsSeries.View).FillStyle.FillMode = FillMode.Solid;
    chartSeries.View.Color = System.Drawing.Color.FromArgb(180, 80, 10);
    settings.Series.Add(chartSeries);
    
    //CHART APPEARANCE
    settings.BorderOptions.Visibility = DefaultBoolean.False;
    settings.BackColor = System.Drawing.Color.FromArgb(255,255,255);
    XYDiagram diagram = (XYDiagram)settings.Diagram;
    diagram.DefaultPane.BackColor = System.Drawing.Color.FromArgb(255,255,255);

    //AXIS APPEARANCE - you can make it for X axis the same way
    Axis2D axisY = ((XYDiagram)settings.Diagram).AxisY;
    axisY.Interlaced = false;
    axisY.GridLines.Color = System.Drawing.Color.Black;
    axisY.NumericScaleOptions.GridSpacing = 5;
    axisY.Label.Font = new System.Drawing.Font("Calibri", 16, System.Drawing.FontStyle.Regular);
    axisY.Label.TextColor = System.Drawing.Color.White;
    axisY.Lablel.EnabelAntialiasing = DefaultBoolean.True;

    //LEGEND
    settings.Legend.Visible = true;
    settings.Legend.AlignmentVertical = LegendAlignmentVertical.Center;
    settings.Legend.Font = new System.Drawing.Font("Calibri", 12, System.Drawing.FontStyle.Bold);
    settings.Legend.TextColor = System.Drawing.Color.White;
    settings.Legend.BackColor = System.Drawing.Color.FromArgb(0x14, 0x20, 0x2F);
    settings.CrosshairEnabled = DefaultBoolean.False;
     
    //LABELS
    chartSeries.LabelsVisibility = DefaultBoolean.True;
    chartSeries.Label.BorderVisibility = DefaultBoolean.False;
    chartSeries.Label.FillStyle.FillMode = FillMode.Empty;
    chartSeries.Label.Font = new System.Drawing.Font("Calibri", 12, System.Drawing.FontStyle.Bold);
    chartSeries.Label.TextColor = System.Drawing.Color.White;
    chartSeries.Label.LineVisibility = DefaultBoolean.False;
    chartSeries.Label.LineLength = 10;
    chartSeries.Label.Antialiasing = true;

    //TITLE
    settings.Titles.Add(
        new ChartTitle()
        {
            Text = String.Format("{0} Production Plan", DateTime.Now.Year),
            Alignment = System.Drawing.StringAlignment.Center,
            Font = new System.Drawing.Font("Calibri", 24, System.Drawing.FontStyle.Bold),
            TextColor = System.Drawing.Color.White,
            Visible = true,
            Indent = 5
        });

    //LABEL FORMAT
    settings.CustomDrawSeriesPoint = (sender, e) =>
    {
        decimal labelValue = 0;
        if (decimal.TryParse(e.LabelText, out labelValue))
            e.LabelText = DisplayHelper.DecimalToString(labelValue, 2);
    };
}).Bind(Model).GetHtml()
```

##### Overlapping labels
Sometimes in charts you may find labels are overlapping on each other. This is rather an undesirable effect. You can control overlapping with **ResolveOverlappingMode** property:
```csharp
exampleSeries.Label.ResolveOverlappingMode = ResolveOverlappingMode.Default;
```
### Errors

##### Uncaught ReferenceError: ASPx is not defined
If you such error in javascript console and the web app is not looking good that means that your installed JQuery version is too low for DevExpress or DevExpress javascript files are not linked to the web app.

##### Uncaught ReferenceError: ko is not defined
If you such error in javascript console and the web app is not looking good that means that Knockout.js is not linked or JQuery and Knockout are linked after and not before DevExpress javascript files.

##### Uncaught RangeError: Maximum call stack size exceeded
Such error in javascript console may be cause by multiple calls to `Html.GetScripts()`.

## Useful links

#### XPO
[XPO Documentation](https://documentation.devexpress.com/CoreLibraries/1998/DevExpress-ORM-Tool) <br />