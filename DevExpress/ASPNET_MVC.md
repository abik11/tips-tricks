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
