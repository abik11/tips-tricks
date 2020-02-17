## DataTables
DataTables is a fantastic plugin for JQuery that allow you to create super powerful tables! The only problem with this plugin is that it has so many feautures that sometimes it may be difficult to configure it exactly the way you want it. The basic usage of the plugin is very easy:
```html
<table class="my-table">
	<thead>
		<tr>
			<th>Col 1</th>
			<th>Col 2</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Data 1</td>
			<td>Data 2</td>
		</tr>
		<tr>
			<td>Data 3</td>
			<td>Data 4</td>
		</tr>		
	</tbody>
</table>
```
```javascript
$(document).ready(function(){ $('.my-table').DataTable(); });
```

## Table of contents
* [Filtering and searching](#filtering-and-searching)
* [Sorting](#sorting)
* [Paging](#paging)

### Set default table options
```javascript
$.extend( $.fn.dataTable.defaults, {
    searching: false,
    ordering:  false,
    paging: false
} );
```

### Change text for empty table
```javascript
$('.my-table').DataTable({ language: { emptyTable: "Brak danych w tabeli" } });
```

### Modify change menu
```javascript
$('.my-table').DataTable({ "lengthMenu": [ [10, 25, -1], [10, 25, "All"] ] });
```

### Cannot reinitialize datatable
The warning shown when you try to initialize the table which has already been initialized. Parameters of initialization can be only changed through the API.

## Filtering and searching

### Set default filtering
```javascript
$('.my-table').dataTable( {
  "searchCols": [
    null, 			//Col 1 - No filter
    { "search": "phrase1" },	//Col 2
    null,                       //Col 3 - No filter
    { "search": "^[0-9]", "escapeRegex": false } //Col 4
  ]
} );
```

### Disable filtering for given columns
```javascript
$('.my-table').DataTable({
      "columns": [ null, null, null, null, null, { "orderable": false }, { "orderable": false } ]
}); 
```
Here it will be impossible to filter the table by the 6th and 7th column.

### Change text for search
```javascript
$('.my-table').DataTable({ language: { search: "Szukaj:" } });
```

### Change style for search field
```css
div.my-table_filter input{
     /* Your CSS */
}
```
DataTables uses the name of your table to create some class names used for styling the components of the table (it uses [BEM](http://getbem.com/)).

### Change text for no results
```javascript
$('.my-table').DataTable({ language: { zeroRecords: "Nie znaleziono wyników" } });
```

### Adjust search field to Bootstrap
```javascript
$('.my-table').dataTables({
     initComplete: function () {
          $(".my-table_filter").addClass("form-group");
          $(".my-table_filter label").addClass("col-xs-12")
               .css("padding-left", "0px").css("padding-right", "0px");
          $(".my-table_filter input[type=search]").addClass("form-control")
               .attr("placeholder", "Search");
     }
});
```

## Sorting

### Set default sorting
```javascript
$('.my-table').DataTable({ order: [[0, 'desc'], [3, 'asc'], [1, 'asc']] });
```

### Turn off higlight for sorted column
```javascript
$('.my-table').DataTable({ orderClasses: false });
```
Instead of `false` you can also put a name of any CSS class that will be applied for the sorted column if you want to higlight it somehow.

### Set icons for sorted columns
```css
.partialList th.sorting_desc:after{
   content: url("Images/sort_desc.png");
}
.partialList th.sorting_asc:after{
   content: url("Images/sort_asc.png");
}
.partialList th.sorting:after{
   content: url("Images/sortable.png");
}
.partialList th.sorting_desc:after,
.partialList th.sorting_asc:after,
.partialList th.sorting:after{
   display: inline;
   margin-left: 4px;
}
```

## Paging

### Disable changing page length
```javascript
$('.my-table').DataTable({ "lengthChange" : false });
```

### Set page length
```javascript
$('.my-table').DataTable({ pageLength: 20 });
$('.my-table').DataTable().page.len();		#get page length
$('.my-table').DataTable().page.len(15);	#set page length
```

### Hide the information about the current page
```javascript
$('.my-table').DataTable({ "info": false });
```

### Get the current page information
```javascript
$('.my-table').DataTable().page.info();
```
Here you can see an example of the object returned by this function:
```javascript
{
    "page": 1,
    "pages": 6,
    "start": 10,
    "end": 20,
    "length": 10,
    "recordsTotal": 57,
    "recordsDisplay": 57,
    "serverSide": false
}
```

### Choose buttons for paging
The possible options for paging buttons are:
* numbers
* simple (Prev and Next)
* simple_numbers (Prev, Next and numbers)
* full (First, Prev, Next and Last)
* full_numbers (First, Prev, Next, Last and numbers)
```javascript
$('.my-table').DataTable({ "pagingType": "full_numbers" });
```

### Change previous and next buttons
```javascript
$('.my-table').dataTable({
     initComplete: function () {
          configureNextPrevButtons();
     }
})
.on('draw.dt', function () {
     configureNextPrevButtons();
});

function configureNextPrevButtons() {
     $(".paginate_button.next")
          .html("<span class='glyphicon glyphicon-chevron-right'></span>");
     $(".paginate_button.previous")
          .html("<span class='glyphicon glyphicon-chevron-left'></span>");
}
```
