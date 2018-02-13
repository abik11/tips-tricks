# VBA - How to not become mad

Here I present some of my very little experiance with VBA, tips and tricks that helped me to achieve some tasks without becoming crazy.

* Tricks you can do without without VBA
* Visual Basic for Applications
* Excel
* Word
* Powershell
* C#

## Tricks you can do without VBA

### Select all despite the first row
1. Select the first cell of second row
2. Push CTRL + SHIFT + Arrow Down
3. Push CTRL + SHIFT + Arrow Right
This may be quite useful while testing and developing macros

### Get text length from given column and filter it
1. Add new column: ->Right click on column index ->Insert
2. Type new formula in the first cell of the new column: *=len(A2)* (*dł* in Polish Excel)
3. Double click in the right bottom corner of this cell with the formula. This will apply the formula for all the column.
4. Mark the column with text length and go to: ->Data ->Filter. Now you can select only those rows with the text length that you want!

## Visual Basic for Applications

### Enable macros
To start developing macros you have to follow the steps:
1. Unlock developer mode: ->File ->Options ->Adjust ribbons ->[In the right window] **Developer**
2. Go to: ->Developer ->Design Mode to add some buttons or other GUI elements, or go to: ->Developer ->Visual Basic to start writing code
3. Add new window: ->[Visual Basic/Project] Forms ->Right click on Insert ->User Form

### Debugging
Add some breakpoints and type in **Immediate Window** commands like: `?variableName` or `Debug.Print "Value: " & variableName`. It will print out the value of given variable.

### Syntax
Here is an example how to define procedures (called subroutines in Visual Basic):
```vba
Sub Subroutine_Some_Name()
   'procedure code
End Sub

Subroutine_Some_Name 'calling the procedure
```
Here is how to define functions:
```vba
Function Some_Func(Name As String, Optional X As Integer = 5) As String
    Some_Func = "Hello " & Name
End Function

Call Some_Func "Albert" 'calling the function
```
Be careful about returning values! To return something you must assing some value to the function name! This is very unique approach, so be careful! <br />
Here you can see how to define and initialize variables. Also you can see how to convert some number into a char with **CInt** function:
```vba
Dim variable1 As Integer
Dim variable2 As String
variable1 = "100"
variable2 = CInt(variable1)
```
Below you can see how to use other structures like **if**, **switch** and **loops**. Take a deeper look on the **for loop** because its syntax is quite different than in other languages.
```vba
If variable2 = 100 Then
    Console.WriteLine("good!");
ElseIf variable2 = 99 Then
    Console.WriteLine("not bad");
Else
    Console.WriteLine("bad!");
End If

Select Case variable1
    Case 1
        Console.WriteLine("...");
    Case Else
        Console.WriteLine("!!!");
End Select

For counter = 0 To 10 Step 2
    If counter = 8
        Exit For
    EndIf
Next counter
```
Here you can see how to define static methods:
```vba
Public Shared Function Abc() As User `VBA
```
```csharp
public static User Abc(); //C#
```

### Arrays 
Here is a basic example how to handle arrays with **for each** loop:
```vba
Dim fruits As Array
fruits = Array("apple", "banana")
Dim fruitsName As Variant
For Each Item In fruits
    fruitNames = fruitNames & Item & Chr(10)
Next
```
Here you can see how to define array length, how to define three dimensional array and how to access some specified array index:
```vba
Dim a1(5) '<0;5>
Dim a2
a2 = Array("a", "b", "c")
a2(2) = "x"
Dim a3(3,3) As Variant
```
If you want to change array lenght you can use the following code:
```vba
Dim a() As Variant
redim preserve a(5)
```
And finally you can use **Join** and **Split** functions:
```
Join(a2, "-")
Split("a-b-c-", "-")
```

### Close window
```vba
Unload Me
```

## Excel 

### Create your own functions
It is possible to define and use your own functions. To make it you must add new VBA module: ->[Visual Basic/Project] ->Right click on project ->Insert ->User Module. Now all functions that you will define here will be accessible from Insert Function window: ->Formula ->Insert Function ->User Defined Function. That's it!

### Working with sheet
You can access any sheet with **Worksheet** array. Every worksheet has two dimensional **Cells** array. Also for the currently active sheet you can directly use **Cells** array, omitting **Worksheet** array, you can see this in the following example: 
```vba
Worksheets("Sheet1").Cells(4,6) = 657
Cells(5, 3) = 23 'for active sheet
```
It is also possible to access Excel predefined functions (that users use while defining formulas in Excel). You can access them with **Application** object:
```vba
Application.WorksheetFunctions.Acos() 
```
Also you can access the whole range, for example here we access the range from *[1;1]* to *[10000;15]*:
```vba
Dim data As Variant
data = Range(Cells(1, 1), Cells(10000, 15)) '[1;1] -> [10000;15]
```

### Worksheet and workbook events
1. Go to: ->Developer ->Visual Basic ->Project Explorer ->**Microsoft Excel Objects**
2. Double click on *Sheet1* (or any other) or *ThisWorkbook*
3. In the Code View in top left listbox choose **Worksheet** (deault is **General**)
4. In top right listbox choose event that you want to handle

### ADODB.Connection - User-Defined Type Not Defined
If you such error, you probably forget to add reference to ADO: <br />
->Tools ->References ->Microsoft ActiveX Data Objects 6.1 Library

### SQL queries in Excel
Firstly you mist add reference to ADO: ->Tools ->References ->Microsoft ActiveX Data Objects 2.0 Library, and then you can use the following code:
```vba
Dim connection As New ADODB.Connection
Dim result As New ADODB.Recordset
Dim connection_string As String
Dim query_string As String

Dim start As Integer
Dim end As Integer
start = 18
end = 35

connection_string = "Provider=SQLOLEDB.1;Password=PASS;Persist Security Info=True;User ID=USER;Data Source=ADDRESS_IP;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;Tag with column collation when possible=False;Initial Catalog=DB_NAME"

query_string = "SELECT TOP 10 name, age, number FROM Finance.dbo.People WHERE age >= " & start & " AND age <= " & end

connection.Open connection_string
connection.CommandTimeout = 900

result.Open query_string, connection

Sheets(1).Range("B4").CopyFromRecordset result
```

### Export data from Excel to Access
Firstly you mist add reference to ADO: ->Tools ->References ->Microsoft ActiveX Data Objects 6.1 Library, and then you can use the following code:
```vba
Sub CopyDataToAccess()
    Dim accessFilePath As String
    Dim workbookName As String
    Dim sheetName As String
    
    accessFilePath = Application.ActiveWorkbook.Path & "\testDB1.accdb"
    workbookName = "[Excel 8.0;HDR=YES;DATABASE=" _
         & Application.ActiveWorkbook.FullName & "]"
    sheetName = "[" & Application.ActiveSheet.Name & "$]"
    
    Call ExecuteSQLCmd("INSERT INTO `" & accessFilePath & "`.`Tabela1` (Pole1, Pole2) " _
        & "SELECT Pole1, Pole2 FROM " & workbookName & "." & sheetName, accessFilePath)
End Sub

Sub ExecuteSQLCmd(cmd As String, accessFilePath As String)
    Dim cnn As ADODB.Connection
    Dim sql As String

    Set cnn = New ADODB.Connection
    cnn.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" _
        & accessFilePath & ";Persist Security Info=False;"

    If Not (cnn Is Nothing) Then
        'Execute Sql
        cnn.Execute (cmd)
        'Close
        cnn.Close
    End If
    Set cnn = Nothing
End Sub
```

## Word

### Access currently selected text
Currently selected text can be accessed by the **Selection** object, here you can see the message box that is printing the current selection:
```vba
MsgBox Selection, vbOKOnl, "Hello!"
```

### Change current text formatting
You can also use the **Selection** object to freely change text formatting
```vba
Selection.Font.Bold = True
Selection.Font.Underline = True
Selection.Font.ColorIndex = wdRed
Selection.Font.Name = "Arial"
```

### Number of the first char in selection
```vba
MsgBox Selection.Range.Start
```

### Add text after selection
```vba
Selection.Range.Collapse wdCollapseEnd
Selection.Range.Text = "Added text!" & " "
```

### Move cursor
```vba
Selection.Move Unit:=wdCharacter, Count:=1
```

### Char count in the whole document
```vba
ActiveDocument.Characters.Count
```

### Add key shortcuts for macro
```vba
Sub AddBinding()
    With Application
        .CustomizationContext = NormalTemplate
        'ALT + \
        .KeyBindings.Add KeyCode := BuildKeyCode(wdKeyAlt, wdKeyBackSlash), _ 
              KeyCategory := wdKeyCategoryCommand, _
              Command := "TestKeyBound" 'Name of the function that is going to be called
    End With
End Sub
```
If you want to know more key options to choose (for example instead of **wdKeyBackSlash**), put the mouse cursor over the enum and push SHIFT + F2

### Internet Explorer as COM Object - Google Translate
Add this reference: ->Tools ->Refrence ->Microsoft Internet Control
```vba
Dim IE As Object, i As Long
Dim inputString As String, outputString As String
Dim textToConvert As String, resultData As String
Dim cleanData
    
Set IE = CreateObject("InternetExplorer.application")
inputString = "auto"
outputString = "pl"
textToConvert = Selection

IE.Visible = False
IE.navigate "http://translate.google.com/#" & inputString & "/" _ 
			& outputString & "/" & textToConvert
Do Until IE.ReadyState = 4
     DoEvents
Loop
    
resultData = IE.Document.querySelector("#result_box span").innerHTML
    
IE.Quit
MsgBox resultData, vbOKOnl, "Hello!"
```
## Powershell
Although this document is intended to talk about VBA, it is possible, and sometimes desireable, to work with Excel or Word in other programming languages through COM objects. Few examples will be presented here to show to make it in Powershell, a great tool for scripting and automation. If you want to learn more about Powershell in particular, look [here](https://github.com/abik11/tips-tricks/blob/master/Powershell.md).<br />
Here you can see some very basic example of how to open the file, get the data of the given cell and how to close Excel after the data is retriven:
```powershell
$excel = New-Object -ComObject Excel.Application
$file = (get-item finance.xlsx).FullName
$wb1 = $excel.Workbooks.Open($file)
$ws1 = $wb1.Sheets | select -first 1
$cell = $ws1.Range("D4").Text
ps -ProcessName 'excel' | kill
```

### Save Excel file as CSV
If you would like to export excel file to CSV, for example if some piece of software that you use cannot read excel files but it can read CSVs, you can use the **SaveAs** function.
```powershell
$miss = [Type]::Missing
$wb1.SaveAs("D:\test.csv", 6, $miss,  $miss, $false, $false, 1, 2, $false, $miss, $miss, $true) 
```
Second parameter of the function specifies the file format (**XlFileFormat**), here is the list of some of the available values:
* 6 - CSV
* 22 - CSV Mac, 23 - CSV Windows, 24 - CSV Dos
* 19 - Mac text, 20 - Windows text, 21 - Dos text
* 42 - Unicode text
* 44 - HTML
* 39 - Excel 2007
* 50 - Excel 2012

The last parameter keeps the language settings the same as you use in Excel (**$true**) or in VBA (**$false**).

### Create new workbook and set cell value
To create new excel file you have to call the **Workbooks.Add** functions. And if you want to set cell value, you have to access and set cell's **Value2** property. Here you can see how to do both things:
```powershell
$excel.Workbooks.Add()
$wb1 = $excel.Workbooks | select -first 1
$ws1 = $wb1.Sheets | select -first 1
$cell1 = $ws1.Range('A1')
$cell1.Value2 = '1'
```

### Access cells in another way
Instead of accessing cells by the **Range** function, you can also access them through **Item** function, which works almost like an array.
```powershell
$sheet = $excel.Worksheets.Item(1)
$sheet.Cells.item(1,1) = 'Text data'
$sheet.Cells.item(1,1).Font.Bold = $True
$sheet.Cells.item(1,1).Font.ColorIndex = 34 	#white
$sheet.Cells.item(1,1).Interior.ColorIndex = 48	#gray
```

## C#
It is of course also possible to control Excel through COM object from C#. To be able to do that you hace to add a reference to **Microsoft Excel 14.0 Object Library** in your project and add the following using statement in your C# file:
```csharp
using Excel = Microsoft.Office.Interop.Excel;
```
Here you can see how to create Excel COM object and how to open an excel file with **Open** method of **Excel.Workbook** class:
```csharp
Excel.Application excelApp = new Excel.Application();
excelApp.Visible = false;
Excel.Workbooks workbooks = excelApp.Workbooks;
Excel.Workbook workbook = workbooks.Open(file_path);
Excel.Worksheet sheet = (Excel.Worksheet)workbook.Sheets[1];
```
Here you can see an example how to read the whole **A** column from excel file and how to write the data to the column. An important thing to note is that for writing you have to use **Value2** property: 
```csharp
int lastRow = sheet.Cells.SpecialCells(Excel.XlCellType.xlCellTypeLastCell).Row;

#read
System.Array lines = (System.Array)sheet.get_Range("A1", "A" + lastRow).Cells.Value;
#write
sheet.get_Range("A1", "A" + lastRow).Cells.Value2 = new_values_array;			
```
**UsedRange** is a nice property of **Excel.Worksheet** class. It contains the range of all used cells, it is of a type **Excel.Range**. Each range has a property **Cells** which you can use as a whole (as shown in the examples before), or you can access specified cells as if you were using an array, see here:
```csharp
Excel.Range range = worksheet.UsedRange;
string str = (string)(range.Cells[row_id, col_id] as Excel.Range).Value2;
```
To save a file use the following piece of code:
```csharp
workbook.SaveAs(file_path);
workbook.Close();
excelApp.Quit();
```

### Add picture
The simplest way to put an image in a given cell is something like this:
```csharp
Image picture = Image.FromFile(picturePath);
Clipboard.SetDataObject(picture, true);
Excel.Range cellImg = (Excel.Range)worksheet.Cells[row, col];
worksheet.Paste(cellImg, picture);
```
Better way, a bit more complicated is this:
```csharp
Excel.Range range = (Excel.Range)worksheet.Cells[row_id, col_id];
float top_img = (float)range.Top + 10;
float left_img = (float)range.Left + 10;

Image pic = Image.FromFile(picturePath);
float width_img = (float)pic.Width;
float height_img = (float)pic.Height;

worksheet.Shapes.AddPicture(picturePath, 
	Microsoft.Office.Core.MsoTriState.msoFalse,
	Microsoft.Office.Core.MsoTriState.msoCTrue, left, top, width, height);
```
And to save a file with pictures, use the following code:
```csharp
object misValue = System.Reflection.Missing.Value;
workbook.SaveAs(saveFileDialog1.FileName, Excel.XlFileFormat.xlWorkbookNormal, misValue, misValue, misValue, 
	misValue, Excel.XlSaveAsAccessMode.xlExclusive, misValue, misValue, misValue, misValue, misValue);
```

### How to get an image from given cell
This is quite a simple task because of the list of all shapes that are put in the worksheet. All you have to do is just iterate through this list and get the picture that its top left corner is put in a cell of given column and row.
```csharp
int row = 25; int column = 5;
Image img =  null;
foreach(Excel.Shape picture in worksheet.Shapes)
{
    if(picture.TopLeftCell.Row == row && picture.TopLeftCell.Column == column)
    {
        picture.CopyPicture //copy to clipboard
            (Excel.XlPictureAppearance.xlScreen, Excel.XlCopyPictureFormat.xlBitmap);

        if(Clipboard.ContainsImage())
        {
            img = Clipboard.GetImage();
            break;
        }
    }
}
```

### How to clean Excel COM objects
Disposing and closing Excel COM objects is not that easy. Never use 2 dots with COM objects! You always have to keep the reference to any COM object variable property or anything, otherwise Garbage Collector may not be able to dispose those objects. This is how you **should** work with COM objects:
```csharp
Excel.Workbooks workbooks = excelApp.Workbooks;
Excel.Workbook workbook = workbooks.Open(file_path);
```
And this is how you **should NOT**:
```csharp
Excel.Workbook workbook = excelApp.Workbooks.Open(file_path);
```
This approach NOT always resolves the problem, so it is useful to close and marshal evertyhing:
```csharp
GC.Collect();
GC.WaitForPendingFinalizers();
workbooks.Close();
Marshal.FinalReleaseComObject(workbooks);
app.Quit();
Marshal.FinalReleaseComObject(app);
```

### Merge cells
To merge cells use **Merge** method of **Excel.Range** class:
```csharp
worksheet.get_Range("b2", "d5").Merge(false);
```
Later, to get the whole range of merged cells, you can get the value of **MergeArea** property:
```csharp
if((bool)range.MergeCells)
    range = range.MergeArea;
```

### Change row height
```csharp
Excel.Range range = (Excel.Range)worksheet.Cells[10, 5];
range.RowHeight = new_int;
```

### Add new row
```csharp
((Excel.Range)worksheet.Rows[row]).Insert();
```

### Copy and past rows
```csharp
Excel.Range destinationRow = worksheet.get_Range("D3").EntireRow;
Excel.Range sourceRow = worksheet.get_Range("B2").EntireRow;
sourceRow.Copy(destinationRow);
```

### Get dropdown list elements
```csharp
string[] dropdownElements;
Excel.Validation dropdown = ((Excel.Range)_worksheet.Cells[row, column]).Validation;
if(dropdown.InCellDropdown)
    dropdownElements = dropdown.Formula1.Split(';');
```

### Changing colors
Font:
```csharp
((Excel.Range)worksheet.Cells[x,y]).Font.Color = ColorTranslator.ToOle(Color.Black);
```
Background:
```csharp
((Excel.Range)worksheet.Cells[x,y]).Interior.Color = ColorTranslator.ToOle(Color.Black);
```
Border:
```csharp
((Excel.Range)worksheet.Cells[x,y]).Borders[Excel.XlBordersIndex.xlEdgeTop].Color =  
    ColorTranslator.ToOle(Color.Red);
```

### Comparing colors
```csharp
if(range.Font.Color != ColorTranslator.ToOle(Color.Black){ /*...*/ }
```

### Change text formatting
This is a nice example where only first ten characters of given cell will have changed formatting (red text color). Of course the whole cell text could be changed without any problem.
```csharp
Excel.Range range = (Excel.Range)worksheet.Cells[x, y];
Excel.Characters chars = range.get_Characters(0, 10); //(from, to)
chars.Font.Color = Color.Red;
```

### Align text to left
```csharp
worksheet.get_Range("A2").Cells.HoriontalAlignment = XlHAlign.Left;
```

### Check if a string is correct cell address
```csharp
string cellAddress = "PW525";
Regex cellRegex = new Regex(@"^([A-Z]{1,3}[1-9]{1}[0-9]*)$");
Match cellMatch = cellRegex.Match(cellAddress.Trim());
if(cellMatch.Success){ /*...*/ }
```

### Convert column number to letter
```csharp
protected string GetExcelColumnName(int columnNumber)
{
   int dividend = columnNumber;
   string columnName = String.Empty;
   int modulo;
   int letters = 'Z' - 'A' + 1;
   
   while (dividend > 0)
   {
      modulo = (dividend - 1) % letters;
       columnName = Convert.ToChar('A' + modulo).ToString() + columnName;
       dividend = (int)((dividend - modulo) / letters);
    }

    return columnName;
}
```

### Put excel in SQL Server
```sql
insert into ExcelFiles (CreationDate, ExcelBinary)
select GETDATE(), * from openrowset(bulk N'D:\file.xlsx', SINGLE_BLOB) as rs
```

### DevExpress Spreadsheet control
There is a nice control in DevExpress which tries to look and work like Excel, here you can see how to load and save excel files:
```csharp
spreadsheetControl.LoadDocument(filePath);
spreadsheetControl.SaveDocument(filePath);
```
To access the currently selected cell value and its address, use the following pieces of code:
```csharp
spreadsheetControl.SelectedCell.Value; 
spreadsheetControl.SelectedCell.Worksheet.ToString(); 
//this gives results like: Range(F10), Worksheet(sheet1)
```
And to read and write cell value you can make it like this:
```csharp
IWorkbook workbook = spreadsheetControl.Document;
Range range = workbook.Range["F16"];
Cell cell = range[0,0];
cell.SetValue("some new cell value");
string value = cell.Value;
string address = cell.GetReferenceA1();
```

## Useful links
[VBA Reference](https://msdn.microsoft.com/en-us/VBA/Excel-VBA/articles/object-model-excel-vba-reference)<br />
[Polish VBA course](http://pszyperski.republika.pl/Excel%202007/index.htm)
