## WinForms Controls
DevExpress developed a really big number of high quality WinForms controls. The only problem with them is that if you will use them once, you will never want to use WinForms without DevExpress again.

### Grid

##### Grid View

* Add grouping panel<br />
->Run Designer ->Feature Browser ->Grouping ->Group Panel
* Allow in-place editors (editable grid)<br />
->Run Designer ->Feature Browser ->Editing ->In-place Editors
* Filtering data in the grid (Auto Filter Row)
->Run Designer ->Feature Browser ->Filtering ->Auto Filter Row
* Summing up the columns<br />
->Run Designer ->Feature Browser ->Summary ->Total Summary ->Show Footer
* Merging cells<br />
->Go to grid view's properties ->OptionsView ->AllowCellMerge
* Turn off row selected row highlighting<br />
->Go to grid view's properties ->OptionsSelection ->EnableApperanceFocusRow = false
* Export grid data to excel<br />
```csharp
gridView.ExportToXlsx(stringFileName);
```

##### Grid Control
* Delete a plus sign in a row<br />
->Properties (GridControl) ->ShowOnlyPredefinedDetails = true
* Getting a row<br />
```csharp
User obj = gvUsers.GetFocusedRow() as User;
if (obj != null)
{}
```
* Add control to the grid<br />
->Run Designer ->Main ->Columns ->Add Column<br />
->Go to ColumnEdit properties ->New ->SimpleButton (or other control) ->Properties ->OptionsColumn ->AllowEdit = True<br />
->Repository ->In-place Editor Repository (select your control) ->Buttons ->Kind = Glyph, Image = Select your image, TextEditStyle = HideTextEditor
* Add data source through XPCollection
1. Add XPCollection component
2. Rebuild project
3. Set property ObjectClassInfo of XPCollection to some class from domain
4. Rebuild project (build)
5. Click little triangle of GridControl
6. Set Choose Data Source as XPCollection<br />
Add this in code
```csharp
gcSomeGrid.DataSource = _data;
gcSomeGrid.RefreshDataSource();
```

### NavbarControl

##### Changing icon's size
```csharp
private void setIconsSize() 
{ 
   List<NavBarGroup> groups = navBarLeft.Groups.ToList();
   List<NavBarGroup> noChange = new List<NavBarGroup>() { nbgImage  };
   if((bool)Properties.Settings.Default["BigIcons"])
   {
      groups.Where(g => !noChange.Contains(g)).ToList()
          .ForEach(g => g.GroupStyle = NavBarGroupStyle.LargeIconsText);
   }
   else
   {
      groups.ForEach(g => g.GroupStyle = NavBarGroupStyle.SmallIconsText);
   }
}
```

##### Showing only some navbar groups
```csharp
private void setNavBarItemVisible(List<NavBarGroup> visibleGroup)
{
   visibleGroup.ForEach(g => g.Visible = true);
   navBar.Groups.Where(g => !visibleGroup.Contains(g))
     .ToList().ForEach(vg => vg.Visible = false);
}
```

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

### RibbonControl
It is a nice idea to create a form with RibbonControl from which other forms will inherit (*CustomRibbonForm*). To add a new DevExpress form: ->Right Click ->Add DevExpress Item ->Form. To edit the ribbon: ->Triangle ->Add PageGroup ->Right click on a group ->Add Button.<br />
To delete red triangle set **ShowToolbarCustomiseItem** property of RibbonControl to **false**. If you want to hide ribbon set **RibbonVisibility** property of main form to **Hidden**.

### Setting icon in application with RibbonControl
* Set icon in RibbonControl<br />
Set property: **ApplicationIcon**
* Set application's icon<br />
->Right click on Project ->Properties ->Application ->Icon and manifest

### Splash screen - wait form
Add control **SplashScreenManager**, click on little triangle and click on **Add Wait Form**. In the background a *WaitForm1* class is created which you can modify to change your wait form view. Now you can show and close a wait form when you need it:
```csharp
splashScreenManager1.ShowWaitForm();
//...
splashScreenManager.CloseWaitForm();
```

### Manually adding event handler
```csharp
this.teMatrixNumber.EditValueChanged += new System.EventHandler(this.ReadAndSendData);

protected void ReadAndSendData(object sender, EventArgs e){ }
```
