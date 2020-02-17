## DevExtreeme
DevExtreeme is a Javascript library with a really big set of controls. They can be used with JQuery, Angular, React and Vue.

### Grid

##### Edit only selected columns
```javascript
var editbaleColumns = ["Name", "Category"];

container.dxDataGrid({
     dataSource: data,
     editing: {
          allowUpdating: true,
          mode: 'batch'
     },
     onEditingStart: function(info){
          if(editableColumns.indexOf(info.column.caption) != -1){
               info.cancel = false;
          }
          else {
               info.cancel = true;
          }
     },
     onRowUpdated: function(info){
          console.log(info.key.Oid);
          console.log(info.data.Name);
          console.log(info.data.Category);
     },
     //columns: [ ... ]
});
```

##### Styling a column
```javascript
columns: [{ dataField: "Name", caption: "User Name", cssClass: "dx-grid-your-class" }]
```

##### Turn off sorting on selected columns
```javascript
columns: [{ dataField: "Name", caption: "User Name", allowSorting: false }]
```

##### Turn off row selection
```javascript
selection: { mode: "none" }
```

##### Turn off filters
```javascript
filterRow: { visible: false }
```

##### Lookup in a column
```javascript
{
   dataField: "User.Oid", caption: "User", 
   lookup: { dataSource: users, displayExpr: "Name", valueExpr: "Oid" }
}
```

##### Export to excel
```javascript
export: { enabled: true, fileName: "report" }
```
