# CSharp
Oh C#... the language of love! :D The one to rule them all, the best of the bests :D This document will be constantly in progress, at least I hope so. It is not a from zero to hero guide to teach C# language. It is rather some gathering of things that was useful or interesting for me while working as a programmer, especially at the beginning.

* [Language tips](#language-tips)
* [Threading](#threading)
* [WinForms](#winforms)
* [WPF](#wpf)
* [ASP.NET MVC](#aspnet-mvc)
* [WCF](#wcf)
* [Performance tips](#performance-tips) 
* [Other](#other)
* [Useful links](#useful-links)

Read also:
* [Databases](https://github.com/abik11/tips-tricks/blob/master/DB.md)
* [Linq](https://github.com/abik11/tips-tricks/blob/master/DB.md#linq)
* [Excel COM](https://github.com/abik11/tips-tricks/blob/master/VBA.md#c)
* [Visual Studio](https://github.com/abik11/tips-tricks/blob/master/W10%2BVS17%2BTFS.md#visual-studio)
* [TFS](https://github.com/abik11/tips-tricks/blob/master/W10%2BVS17%2BTFS.md#tfs-and-other-version-control-systems)
* [DevExpress](https://github.com/abik11/tips-tricks/blob/master/DevExpress.md)

### CSC Compiler
If you want to test some little piece of code and creating a new solution in Visual Studio is defenietely waste of time for you for such a little piece, than you can use CSC compiler directly from command line, see how to do it:
```powershell
$cscPath = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319"
$cscFullPath = "$cscPath\csc.exe"
& "$cscFullPath" /out:program.exe /target:exe program.cs
```
If you need to add some DLL's you have to use `/r` switch:
```powershell
& "$cscFullPath" /r:System.DirectoryServices.dll, System.DirectoryServices.AccountManagement.dll /out:program.exe /target:exe program.cs
```
It is a very good idea to use CSC while learning and trying new things. You just have to create one .cs file, compile it and run! Also you can try things online with [C# Online Compiler](https://dotnetfiddle.net/), but not all the features are availabe there.

## Language tips

### IDisposable
Every class that has some unmanaged resources should implement **IDisposable** interface. It is because Garbage Collector knows nothing about such resources. Here is an example of implementation proposed by Microsoft:
```csharp
public class MyClass : IDisposable
{
   private bool isDisposed=false;

   public void Dispose()
   {
      Dispose(true);
      GC.SuppressFinalize(this);
   }

   protected void Dispose(bool disposing)
   {
      if(!isDisposed)
      {
         if(disposing)
         {
            // free MANAGED resources
         }
         // free UNMANAGED resources
      }
      isDisposed=true;
   }

   ~MyClass() 
   {
      Dispose(false);
   }
}
```

### Syntax
There are many nice syntax construction that may help you a lot while working with C#. With every new version of the language there is also some nice new syntactic sugar added. Here you will find few examples from basic to some less known language constructions.

##### Differences between casting and as operator
When you cast a type if it cannot be cast the **InvalidCastException** will be thrown. If you will use **as** operator it will return **null** if it won't be possible to cast. See here an example:
```csharp
Class1 obj1 = new Class1();

Class2 obj2;
obj2 = obj1 as Class2; //return null
obj2 = (Class2)obj1; //throws InvalidCastException
```
It is also good know by the way that if an object is **null** if you will check its type with **is** operator, it will always return **false** and calling **GetType** method will throw the **NullReferenceException**.
```csharp
Console.WriteLine(obj2 is Class2); //False
Console.WriteLine(obj2.GetType()); //throws NullReferenceException
```

##### Differences between abstract classes and interfaces
The difference between the both concepts may not be so clear. In some programming languages there is actually no difference between them two. But in C# there are differences and it is very good to know about them. Here is a little list with a bunch of differences:
* a class can implement many interfaces but it can inherit from only one abstract class
* interface cannot contain method implementation, only definition, while abstract class can contain both
* interface methods and members can only be public
* interface cannot contain fields
* interface can only contain methods definition, properies, events and delgates
* abstract class can contain constructor declaration while interface cannot
In general an abstract class should be use as a base for other more specific classes. For example *SqlDatabaseConnection* could be an abstract class while *SQLServerConnection* or *MySqlConnection* could be concrete classes thar extend *DatabaseConnection*. And interface is rather used to describe external abilities of a class which may be common between many different classes.

##### Extension methods
```csharp
static bool Contains(this string keyString, char c)
{
   return keyString.IndexOf(c) >= 0;
}

bool test = "Some string".Contains('s');
```

##### User-defined conversion
```csharp
public class Digit
{
   public Digit(double d) { val = d; }
   public double val;

   // User-defined conversion from Digit to double
   public static implicit operator double(Digit d)
   {
      return d.val;
   }

   //  User-defined conversion from double to Digit
   public static implicit operator Digit(double d)
   {    
      return new Digit(d);
   }
}
```
Keep in mind that implicit conversion should **never** throw any exception or lose data. If you cannot fullfil those conditions you should rather implement explicit conversion.

##### Check if integer is not overflowing the maximum value
```csharp
checked {
   int value = int.MaxValue;
   value += 1;
}
```
The code above will throw **OverflowException** if the variable `value` will exceed the maximum integer value, instead of for example giving a strange result.

##### Logical consequence
Logical consequence, also known as logical implication or entailment, is one of the basic boolean operation, but there is no logical operator in C# that implements it. You can use the following boolean operation to implement logical consequence:
```csharp
bool a = true;
bool b = false;

bool consequence = ( !a || b );
```
Here you can see what are the results of the consequence for different boolean values:
```
a   b   
0   0   (!0 || 0) = 1 || 0 = 1
1   0   (!1 || 0) = 0 || 0 = 0
0   1   (!0 || 1) = 1 || 1 = 1
1   1   (!1 || 1) = 0 || 1 = 1
```

### Enums

##### Enums with descriptions
Descriptions may be useful if you want to list enums to display them to user, it is very easy to add them:
```csharp
using System.ComponentModel;

public enum Result 
{
   [Description("No result")]
   None = 0,
   [Description("Correct result")]
   Correct = 1
}
```

##### Get description - extension method
Here is an example of an extension method that will allow you to get the description of given enum value:
```csharp
public static string GetDescription(this Enum value)
{
   Type type = value.GetType();
   string name = Enum.GetName(type, value);
   if (!string.IsNullOrEmpty(name))
   {
      FieldInfo field = type.GetField(name);
      if (field != null)
      {
         DescriptionAttribute descriptionAttribute = 
            (DescriptionAttribute)Attribute.GetCustomAttribute(field, typeof(DescriptionAttribute));
         if (descriptionAttribute != null)
            return descriptionAttribute.Description;
       }
   }
   return string.Empty;
}
```

##### Iterate through all enum values
```csharp
foreach(EnumType value in Enum.GetValues(typeof(EnumType)))
{
   Console.WriteLine(value.GetDescription());
}
```

### Image and byte arrays

##### Convert Image to byte[]
```csharp
MemoryStream mstream = new MemoryStream();
image.Save(mstream, System.Drawing.Imaging.ImageFormat.Png);
byte[] bytes  = mstream.ToArray();
```

##### Convert byte[] to Image
```csharp
MemoryStream mstream = new MemoryStream(imageBytes);
Image image = Image.FromStream(mstream);
```

##### Image file MIME type
```csharp
ImageCodecInfo codec = ImageCodecInfo.GetImageDecoders().FirstOrDefault(x => x.FormatID == image.RawFormat.Guid);
string fileMimeType = codec.MimeType;
```

##### Write byte array to file
```csharp
System.IO.File.WriteAllBytes("fileName", data); 
```

### Collections

##### Get value from dictionary
```csharp
string value = String.Empty;
dictionary.TryGetValue("Key", out value);
```

##### Add an element to IEnumerable 
```csharp
someIEnumerableOfString.Concat(new[]{ "new element" });
```

##### Tuple
There is a nice generic collection class called Tuple (**System.Collections.Generic** namespace), which can hold 8 objects of totally different types. If you want to hold there more objects you have to set the last item of Tuple to Tuple also. See here examples:
```csharp
var simpleTuple = Tuple.Create(1, "Albert", "M", new DateTime(1991, 7, 29));
var largeTuple = Tuple.Create(1, 2, 3, 4, 5, 6, 7, Tuple.Create(8, 9, 10));
var tuple = new Tuple<int, string, bool>(5, "Albert", true);
```
A nice feature of tuples is that they are converted to string in a very nice way!
```csharp
var t = Tuple.Create(1, "Albert", "M", new DateTime(1991, 7, 29));
string tupleAsString = t.ToString(); //(1, Albert, M, 1991-07-29 00:00:00)
```

##### Lazy
There is a class called **Lazy** in **System.Collections.Generic** namespace that allows you to easily add simple implementation of lazy loading for your collections. For example let's assume that we have the following class
```csharp
public class Obj 
{
    public string Name { get; set; }
    
    public Obj(string name)
    {
        this.Name = name;
    }
    
    static public List<Obj> GetObjs()
    {
        var result = new List<Obj>();
        result.Add(new Obj("Paulina"));
        result.Add(new Obj("Albert"));
        return result;
    }
}
```
Then we can create a lazy list like this:
```csharp
List<Obj> eagerList = Obj.GetObjs(); //data is loaded here for eagerList
Lazy<List<Obj>> lazyList = new Lazy<List<Obj>>(() => Obj.GetObjs());

forach(Obj obj in eagerList)
{
    Console.WriteLine(obj.Name);
}
forach(Obj obj in lazyList.Value) //data is loaded here for lazyList
{
    Console.WriteLine(obj.Name);
}
```

### Current week number
```csharp
DateTimeFormatInfo dtFormatInfo = DateTimeFormatInfo.CurrentInfo;
Calendar calendar = dtFormatInfo.Calendar;
int currentWeek = calendar.GetWeekOfYear(DateTime.Now, dtFormatInfo.CalendarWeekRule, DayOfWeek.Sunday);
```

### Sending mails
```csharp
public void SendMail(string subject, string body, List<string> recipients, string attachment = null)
{
   string recipientsString = string.Join(",", recipients);
   SendMail(subject, body, recipientsString, attachment);
}

public void SendMail(string subject, string body, string recipients, string attachment = null)
{
   MailMessage mail = new MailMessage();
   SmtpClient SmtpServer = new SmtpClient("203.204.205.206");
   mail.From = new MailAddress("j.smith@evilcorp.com");
   mail.Subject = subject;
   mail.SubjectEncoding = Encoding.UTF8;
   mail.Body = body;
   mail.To.Add(recipients);
   mail.BodyEncoding = Encoding.UTF8;
   mail.IsBodyHtml = true;

   if (attachment != null)
   {
      Attachment attachmentM = new Attachment(attachment);
      mail.Attachments.Add(attachment);
   }

   SmtpServer.Send(mail);
}
```

### Write to Windows Event Log
```csharp
using System.Diagnostics;

string eventSource = "MyApp";
string log = "Application";

if (!EventLog.SourceExists(eventSource))
   EventLog.CreateEventSource(eventSource, log);

EventLog eventLog = new EventLog();
eventLog.Source = eventSource;
eventLog.Log = log;
eventLog.WriteEntry("Test message", EventLogEntryType.Information);
```

### Get property value with reflection
```csharp
object GetAnyPropertyValue<T>(object obj, string propertyName)
{
   List<PropertyInfo> properties = typeof(T).GetProperties().ToList();
   PropertyInfo property = properties.First(x => x.Name == propertyName);

   if(property != null && obj != null)
   {
        return property.GetValue(obj);
   }
   
   return null;
}
```

## Threading
Modern processors usually are build with few cores that allows us to run many threads. There are also few ways in C# to work with threads. The most common ways are to work with plain old **Thread** class and **TPL** (Task Programming Library) which is based on **Task** class that is easy to use and allows to use asynchronous programming.

### Locking
With **lock** keyword you can create a **critical section**. This is a section of code that will be executed only by one thread at a time so it is thread safe. An important thing to use lock is a lock object - here it is stored in `syncObj` variable. By the way, critical sections can be nested one in another.
```csharp
int i = 0;

private static object syncObj = new object();

public static void Do()
{
    //critical section
    lock(syncObj)
    {
        i++;
    }
}

static void Main(string[] args)
{
    Thread t1 = new Thread(Do);
    Thread t2 = new Thread(Do);
    t1.Name = "Thread 1";
    t2.Name = "Thread 2";
    t1.Start();
    t2.Start();
}
```
There is also a nice class called Interlocked which allows you to do some operations which will be locked. It allows to do only simple operations but it is extremely neat and nice. Here is a simple example:
```csharp
int balance = 5;
int amount = 1;
Interlocked.Add(ref balance, amount); //now balance should equal 6
```

##### What a lock really is
The lock notation from the previous example is only a syntactic sugar for the following code:
```csharp
bool lockTaken = false;
try 
{
    //enter critical section
    Monitor.TryEnter(syncObj, TimeSpan.FromMiliseconds(50), ref lockTaken);
    i++;
}
finally
{
    if(lockTaken)
    {
        //exit critical section
        Monitor.Exit(syncObj);
    }
}
```

##### Spin lock
Typically locks are changing thread context if some resource cannot be accessed. If the locked operation is very fast, changing thread context may cause higher cost for processor than simply waiting for the resource to be available for the thread. **SpinLock**, when cannot access given resource, it occupies processor with useless job to wait for the resource and it doesn't allow other threads to be executed by the processor. It is just taking time and *actively* waiting.
```csharp
int i = 0;
SpinLock lock = new SpinLock();
var lockTaken = false;
try 
{
     lock.Enter(ref lockTaken);
     i++; // this operation is thread safe
}
finally 
{
     if(lockTaken) lock.Exit();
}
```

### Mutex 
Mutex is a very powerfull class. A very useful application of it can be allowing only one instance of an application to run. Here is one example:
```csharp
public void Main(string[] args)
{
    const string appName = "MyApp";
    Mutex mutex;
    try
    {
        mutex = Mutex.OpenExisting(appName);
        Console.WriteLine("App is already running!");
        return;
    }
    catch(WaitHandleCannotBeOpenedException)
    {
        Console.WriteLine("Program can be run...");
        mutex = new Mutex(false, appName);
    }

    bool hasLock = mutex.WaitOne();
    try
    {
        //...
    }
    finally
    {
        if(hasLock) mutex.ReleaseMutex();
    }
}
```
Or there is another way:
```csharp
public void Main(string[] args)
{
    Mutex mutex = new Mutex(true, "MyApp");
    if(!mutex.WaitOne(1, false))
    {
        Console.WriteLine("App is already running!");
        return;
    }
    
    //...
}
```
You can also implement data synchronization just like with **lock** or **SpinLock**, but what's great about **Mutex**, you can lock two Mutexes as one when more than one resource must be synchronized in thread-safe way. Look at the example:
```csharp
Mutex mutex = new Mutex();
Mutex mutex2 = new Mutex();

bool hasLock = WaitHandle.WaitAll(new[] { mutex, mutex2 });
try
{
    bankAccount.Transfer(bankAccount2, 100);
}
finally
{
    if(hasLock)
    {
        mutex.ReleaseMutex();
        mutex2.ReleaseMutex(); 
    }
}
```

### Task
```csharp
var task = Task<string>.Factory.StartNew(() => {
    Thread.Sleep(2000);
    return "This is a result from the task";
});

Console.WriteLine(task.Result);
```
Task are cool, they do all the communication between threads in the background for us. When you try to access the task's result, the main thread will wait for the task to finish. An important thing to note is that as default tasks are background thread so they will finish immediately toegether with main thread, so the main thread will not wait for the tasks to finish. It can be checked if a thread is background or foreground thread.<br />
If a task doesn't return any value you still have to wait for it in a main thread if you don't want it to be stopped when main thread finishes - you have to call the Wait() method of task object.

##### Waiting for tasks
```csharp
Task t1 = Task.Factory.StartNew(() => Thread.Sleep(3000));
Task t2 = Task.Factory.StartNew(() => Thread.Sleep(5000));

Task.WaitAll(t1, t2);
Task.WaitOne(t1, t2);
```
You can of course wait for the task to finish when you are trying to access its **Result** property, but if your tasks are void and you have to wait for them you can use **WaitAll** to wait for all your tasks or **WaitOne** to wait for any of your tasks to finish. There is also more advanced option to wait for task with specified timeout:
```csharp
Task.WaitAny(new[] {t1, t2}, 4000);
Console.WriteLine(t1.Status); //RanToCompletion - task finished before timeout
Console.WriteLine(t2.Status); //Running - task didn't finish before timeout
```
There is also another option - **Thread.SpinWait**, which is not allowing to change thread context.

##### Long tasks
```csharp
var task = Task.Factory.StartNew(() => {
    Console.WriteLine("Text from a task!");
    throw new InvalidOperationException();
}, TaskCreationOptions.LongRunning);
```
As default tasks are instantiated from **Default Thread Pool** and that's cool for small tasks, but for long running tasks it may cause performance loss, so we have to mark a task as long running to force it to be created out of **Default Thread Pool**. 

##### Error handling
In general you can wrap a task simply in **try ... catch** block:
```csharp
try
{
    task.Wait();
}
catch(){}
```
But if you wait for more than one task, you may get more than one exception. To handle this, you have to catch **AggregateException**:
```csharp
try 
{
    Task.WaitAll(t1, t2);
}
catch(AggregateException ae)
{
    foreach(var e in ae.InnerExceptions)
        Console.WriteLine(e.GetType());

    ae.Handle(e => 
    {
        if(e is InvalidOperationException) return true;
        else return false;         
    });
}
```
AggregateException is a nice thing that allows you to catch all the execptions of different tasks into one exception. You can use **Handle** method to manually handle some of aggregated exceptions and do not handle others, this gives a lot of control over the exceptions.

##### Task initialization and name
```csharp
string message = "A message from out of the task";
var task = Task.Factory.StartNew(state => {
    Console.WriteLine(message);
}, "TaskName1");
```
A lambda expression can access the variables declared before the task starts. A nice trick is to add state parameter for lambda and to put there a string value that will be a task name which is good for debugging.

##### Task cancellation
```csharp
var tokenSource = new CancellationTokenSource();
var token = tokenSource.Token;

var task = Task.Factory.StartNew(() => {
    Thread.Sleep(4000);
    Console.WriteLine(message);
}, token);

tokenSource.Cancel();
```

## WinForms
WinForms is a .Net wrapper for WinApi, it allows you to build GUI for Windows applications through a really big group of classes, methods and properties. It is easy to use, lately quite criticized for not being well suitable for bigger projects - it is hard to separate logic from the code that handles th GUI. WPF is another .Net way of doing desktop apps.

### How to access the form state from other thread
```csharp
delegate void ScannerDelegate(string receivedData);

void DataReceiveAction(string data)
{ 
   label.Text = data.ToString(); 
}

this.BeginInvoke(new ScannerDelegate(DataReceiveAction), new object[] { data });
```
This can be also done slighlty different way with the TPL library.

### Paint event
Sometimes default controls may not be enough or you will need to modify them somehow. You can use **Paint** event to add some images or generally affect the way a control is displayed, here is an example of adding an image to ribbon control:
```csharp
private void ribbon_Paint(object sender, PaintEventArgs e)
{
   //Using image from resources
   Image bgImage = Properties.Resources.logo_img;

   Rectangle rect = ribbon.ClientRectangle;
   rect.Width = 304;
   rect.Height = 96;
   
   //Setting the image's position depending on the ribbon's size
   rect.X = ribbon.ClientRectangle.Width - rect.Width - 10;
   rect.Y = ribbon.ClientRectangle.Height - rect.Height;
   e.Graphics.DrawImage(bgImage, rect);
}
```

### Playing WAV sounds
```csharp
using System.Media;

SoundPlayer player = new SoundPlayer(Properties.Resources.Sound_wav);
player.Play();
```

### App window maximized at start
Set your main form's property **WindowState** to **Maximized**.

### Filter for image files for OpenFileDialog
```csharp
string filtr = "Image files (*.bmp, *.jpg, *.png) | *.bmp; *.jpg; *.png| 
   BMP files (*.bmp)|*.bmp|JPG files (*.jpg)|*.jpg| PNG files (*.png)|*.png";
```

### Bind a property to a setting
->Go to control's properties ->(ApplicationSettings) ->(PropertyBinding)

### Error while starting an app - Checking application correctness failed
->Right click on Project ->Properties ->Application ->Manifest: Create application without a manifest

### Domain group authorization
```csharp
PrincipalContext ctx = new PrincipalContext(ContextType.Domain, Environment.UserDomainName);
UserPrincipal user = UserPrincipal.FindByIdentity(ctx, Environment.UserName);
GroupPrincipal group = GroupPrincipal.FindByIdentity(ctx, "_Group1");

if(!user.IsMemberOf(group))
    Close();
```

### DevExpress WinForms Controls
You can speed up your development with DevExpress controls. Read more [here](https://github.com/abik11/tips-tricks/blob/master/DevExpress.md#winforms-controls).

## WPF
Windows Presentation Framework is just as its name says a framework, designed to develop Windows application. It is different from WinForms because it doesn't use WinApi controls, it paints all the forms so the control that we have over the presentation layer of our application is much bigger. Another difference is that WPF forms usually (almost always) are wirtten with a language called XAML which is an extension of XML, a bit similar to HTML - you can build a form using tags. Also in WPF it is recommended to use MVVM (Model-View-ViewModel) design pattern to separate presentation layer (GUI) from logic.

### Building a layout
Here is a simple example of a layout built with Grid and StackPanel: 
```xaml
<Window x:Class="App.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WtfApp1"
        mc:Ignorable="d"
        Title="MainWindow" Height="350" Width="525">
   <Grid>
      <Grid.ColumnDefinitions>
         <ColumnDefinition />
      </Grid.ColumnDefinitions>
      <Grid.RowDefinitions>
         <RowDefinition />
         <RowDefinition />
      </Grid.RowDefinitions>
      
      <Button Grid.Column="0" Grid.Row="0" Width="100" Height="50" Name="btnTest">
         Button Text
      </Button>
      
      <StackPanel Grid.Column="0" Grid.Row="1" Orientation="Vertical">
         <Button Margin="10"  Width="200" Height="50" Name="btnStackPanel">
            Stack Panel 1
         </Button>
         <TextBox Margin="10" Width="200" Height="50" 
                          TextAlignment="Center" Name="tbStackPanel">
            Text Box 1
         </TextBox>
      </StackPanel>
   </Grid>
</Window>
```
It is good to note that you define grid columns and rows with separate tags (**ColumnDefinition**, **RowDefinition**) and then inside of the grid you can position elements using **Grid.Column** and **Grid.Row** properties. You can also use **Grid.RowSpan** and **Grid.ColumnSpan**.

### DataGrid
Just a very little example of a DataGrid with data binding
```xaml
<DataGrid Name="dgPeople" AutoGenerateColumns="False" ItemsSource="{Binding People}">
     <DataGrid.Columns>

          <DataGridTextColumn Header="Last Name" 
               Binding="{Binding LastName}"></DataGridTextColumn>

          <DataGridTextColumn Header="{x:Static str:Strings.DayOfBirth}" 
                Binding="{Binding Birthday, StringFormat=\{0:dd.MM.yyyy\}}">
                </DataGridTextColumn>

     </DataGrid.Columns>
</DataGrid>
```

### A button with an image
```xaml
<Button Name="btCancel" Width="100" Margin="10" IsEnabled="False"
  Command="{Binding CancelCommand}" Click="btCancel_Click">
        <StackPanel Orientation="Horizontal">
                <Image Source="/MyProject.Resources;Component/Images/cancel.png" 
                  Stretch="None"></Image>
                <TextBlock Text="{x:Static str:Strings.Cancel}"></TextBlock>
        </StackPanel>
</Button>
```
The image you want to use must have the **Build Action** property set to **Resource**.

### Turn off last child fill in DockPanel
The last element of a DockPanel always fills all the place that is not filled with other elements. Sometimes (or actually quite often) you may not want it to work like this. It can be easily turn off with **LastChildFill** property of DockPanel: 
```xaml
<DockPanel LastChildFill="False"></DockPanel>
```

### Adding a splitter to a grid
```xaml
<Grid>
    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="*" />
        <ColumnDefinition Width="5" />
        <ColumnDefinition Width="*" />
    <Grid.ColumnDefinitions>
    <StackPanel></StackPanel>
    <GridSplitter Grid.Column="1" HorizontalAlignment="Stretch" />
    <StackPanel Grid.Column="2"></StackPanel>
</Grid>
```

### Binding a command to a non-default event
Firstly you have to add the following namespace: `xmlns:i="http://schemas.microsoft.com/expression/2010/interactivity"`.
```xaml
<i:Interaction.Triggers>
    <i:EventTrigger EventName="MouseDown">
        <i:InvokeCommandAction 
            Command="{Binding  TopPanelMouseDownCommand}"
            CommandParameter="{Binding ElementName=this}" />
    </i:EventTrigger>
</i:Interaction.Triggers>
```

### Binding a command to a key
```xaml
<DataGrid.InputBindings>
     <KeyBinding Key="Delete" Command="{Binding EditCommand}" />
</DataGrid.InputBindings>
```

### Internationalization
To support many languages in WPF application you have to take few steps.
1. Prepare *MyProject.Resource* project that will contain string files for each language that you want to support.
2. Add this project to namespaces in your forms:
```
xmlns:str="clr-namespace:MyProject.Resources;assembly=MyProject.Resources"
```
3. Statically assign string values, like this:
```xaml
<Button Name="btSave" Content="{x:Static str:Strings.Save}"></Button>
```
4. Override **OnStart** method of your **App.xaml.cs** file:
```csharp
protected override void OnStartup(StartupEventArgs e)
{
   base.OnStartup(e);

   Thread.CurrentThread.CurrentCulture = new CultureInfo("en-GB");
   Thread.CurrentThread.CurrentUICulture = new CultureInfo("en-GB");

   FrameworkElement.LanguageProperty.OverrideMetadata
      (typeof(FrameworkElement), 
      new FrameworkPropertyMetadata(XmlLanguage.GetLanguage(CultureInfo.CurrentCulture.IetfLanguageTag)));
}
```
<br />
If you want to change the language, it would be a good idea to save the language string (*en-GB* or other) in app settings, manipulate that setting in the app and restart the app after it has been changed.

## ASP.NET MVC
ASP.NET MVC is a .Net web app framework based on the design pattern called Model-View-Controller. It is quite popular, easy to learn but hard to master.

### Browser detection
```csharp
@using System.Web
@{
    string browser = Request.Browser.Browser;
    if(browser == "InternetExplorer"){ // ... }
}
```

### Redirect to other action
```csharp
public ActionResult RedirectingView()
{
   return RedirectToAction("OtherView", "OtherController", new { Parameter1 = 101010 });
}
```

### Add URL redirection
As default you can find routes in **App_Start** directory in **RouteConfig.cs** file. There you can add additional routes, like this:
```csharp
routes.MapRoute(
    name: "QueenMobile",
    url: "Queen",
    defaults: new { controller = "SWSMobile", action = "Index", id = UrlParameter.Optional }
);
```
Name and URL should not have the same value.

### Access URL parameters
```csharp
if(Request.QueryString["status"] == "success")
{ 
   //... 
}
```

### Put C# array to Javascript
```csharp
@{ int[] numbers = new int[]{ 1, 2, 3, 4 }; }
<div onclick="iterate( @Html.Raw(Json.Encode(numbers)) );">Iterate array</div>
```
```javascript
function iterate(numbers) {
   numbers.forEach((item, index) => {
      console.log(`${index}. Current item: ${item}`);
   });
}
```

### Sending files from Javascript to controller
[Go here](https://github.com/abik11/tips-tricks/blob/master/Web.md#formdata)

### Add some namespace to Razor
In **Web.config** file in **Views** directory you can add following line:
```xml
<add namespace="Some.Namespace" />
```
This will allow you to use some namespace in your Razor views.

### Sections
Sections are an mechanism that allows you to define a layout with specified sections that will be later filled with some HTML depending on a specified MVC view. In a **Shared** directory there is a **\_Layout.cshtml** file where you can use a **RenderSection** function to specify the layout with sections:
```html
<html>
<body>
    <div class="menu">
        @RenderSection("menu", required: false)
    </div>
    <div class="container">  
        @RenderBody()
    </div>
</body>
</html>
```
Then you can create a new **cshtml** file and define the content for the section. You can do it with **section** directive:
```html
@section menu {
    <a href="#">Home</a>
}
<h1>Hello!</h1>
```
All the HTML content that you will define inside of a section will be put in the layout where you call the **RenderSection** with section's name. All the other stuff will be put in place of **RenderBody** function. Here you can see the generated HTML:
```html
<html>
<body>
    <div class="menu">
        <a href="#">Home</a>
    </div>
    <div class="container">  
        <h1>Hello!</h1>
    </div>
</body>
</html>
```

### Authorization with Active Directory group
To allow AD authorization you have to enable it in IIS: ->Sites ->Your application ->Authentication ->**Anonymous Authentication**: Enabled, **Windows Authentication**: Enabled.<br />
Here is an example of authorization atribute that uses AD groups:
```csharp
public class AuthorizeADAttribute : AuthorizeAttribute
{
   public string Groups { get; set; }

   public override void OnAuthorization(AuthorizationContext filterContext)
   {
      base.OnAuthorization(filterContext);
      string[] groups = Groups.Split(',');
      string userName = UserHelper.GetUserName(filterContext.HttpContext.User);

      try
      {
         bool isAuthorized = UserHelper.IsMemberOfAny(groups, userName);
            
         if(!isAuthorized)
            filterContext.Result = new ViewResult { ViewName = "~/Views/Error/401.cshtml" };
      }
      catch (Exception)
      {
         filterContext.Result = new ViewResult { ViewName = "~/Views/Error/NotAuthorise.cshtml" };
      }
   }
}

public static class UserHelper
{
   public static string GetUserName(IPrincipal user)
   {
      WindowsIdentity windowsIdentity = user.Identity as WindowsIdentity;
      WindowsPrincipal winPrincipal = new WindowsPrincipal(windowsIdentity);

      if (winPrincipal.Identity.Name.StartsWith("Corp\\"))
         return winPrincipal.Identity.Name.Replace("Corp\\", "");
      else
         return winPrincipal.Identity.Name;
   }

   public static bool IsMemberOfAny(string[] groupNames, string userName, string domainName = "Corp")
   {
      PrincipalContext context = new PrincipalContext(ContextType.Domain, domainName);
      UserPrincipal userPrincipal = UserPrincipal.FindByIdentity(context, IdentityType.SamAccountName, userName);

      for (int i = 0; i < groupNames.Length; i++)
      {
         if (userPrincipal.IsMemberOf(context, IdentityType.Name, groupNames[i].Trim()))
            return true;
      }

      return false;
   }
}
```
If the attribute is ready, it is possible to apply it to every controller as default - but of course don't do that if you only want to use this kind of autorization only for some of your controllers. In **Global.asax.cs** in **Application_Start** method, as default, there is a call to **RegisterGlobalFilters**, it looks like this:
```csharp
protected void Application_Start()
{
   AreaRegistration.RegisterAllAreas();
   FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
   RouteConfig.RegisterRoutes(RouteTable.Routes);
   BundleConfig.RegisterBundles(BundleTable.Bundles);
}
```
And then in **FilterConfig.cs** you can define a default authorization atribute for all controllers:
```csharp
public static void RegisterGlobalFilters(GlobalFilterCollection filters)
{
    filters.Add(new HandleErrorAttribute());
    filters.Add(new AuthorizeAttribute());
}
```
Now automatically every controller will be authorized with AD. You can allow unauthorized user to access some controllers or methods with **AllowAnonymous** attribute. See here an example:
```csharp
public class EmployeeController : Controller
{
   [AllowAnonymous]
   public ActionResult Index()
   {
      return View();
   }

   public ActionResult Registration()
   {
      return View();
   }

   [AuthorizeAD(Groups = "IT_Group,HR_Group")]
   public ActionResult Status()
   {
      return View();
   }

   public ActionResult History()
   {
      return View();
   }
}
```
*Registration* and *History* methods of *EmployeeController* are available for users registered in AD. *Index* method is available also for users that are not registered in AD and *Status* is available for registered users that belong to specified AD groups.<br />
If you have to call a method that requires AD authorization through AJAX, it is required to attach Windows credentials:
* Fetch API:
```javascript
fetch(url, { credentials: 'include' })
   .then(() => {});
```
* JQuery:
```javascript
$.ajax({ 
   xhrFields: { withCredentials: true } 
});
```

### Get user name
* inside of a view: `HttpContext.Current.User.Identity.Name`
* inside of a controller: `HttpContext.User.Identity.Name`

### Display image from Image object in HTML 
```csharp
var base64 = Convert.ToBase64String(image);
var imgSrc = String.Format("data:{1};base64,{0}", base64, fileMimeType);
```
```html
<img src='@imgSrc' />
```

### Model Binder
**Model Binder** is a component of MVC .NET that is responsible for filling your objects with the data taken from HTTP request parameters. It is very useful and saves a lot of time, but it can also cause you some problems. For example here we've got some (more or less :)) complex class:
```csharp
public class Item 
{
   public int Id { get; set; }
   public string Name { get; set; }
   public InnerItem Item { get; set; }
}

public class InnerItem 
{
   public int Id { get; set; }
   public string Name { get; set; }
}
```
and an action method in some controller like this:
```csharp
[HttpPost]
public ActionResult UpdateItem(Item item)
{
   var itemName = item.Name;
   return View(itemName);
}
```
and a POST request with a JSON like this:
```json
{
   'Id': 42,
   'Name': 'NewItem #42'
   'Item': {
      'Id': 67,
      'Name': 'Item No 67'
   }
}
```
then be careful! Because Model Binder will not bind the whole JSON structure to the Item class. It will take the inner *Item* property (of type *InnerItem* in C# code) and bind this to the controller's method parameter! That means that `item.Id` will equal 67 and not 42 as expected! This happens because the name of the inner property is called *Item*, just like the name of the parameter of action method. Altough such scenario is possible, it is rather extremely rare so in general don't fear to use Model Binder, it is a really great feature of MVC .NET.

### Errors

##### HTTP Error 404.0 - Not found - Two classes with the same name
Sometimes you may encounter an exception with the following content:
```
Multiple types were found that match the controller named 'Dashboard'. (...) The request for 'Dashboard' has found the following matching controllers:
DevExpress.DashboardWeb.Mvc.DashboardController
Corp.ProjectMVC.Controllers.DashboardController
```
It may not be easy to found the true cause of the exception, so if you struggle to find it, try to add a breakpoint in **Global.asax** file in **Application_Error** function on the following line:
```csharp
Exception exception = Server.GetLastError();
```
and see the error message there. <br />
The easiest solution for this problem is to change the name of your controller class, but that is probably not what you want. Another thing what you can do is to select controllers' namespace in your routes like this:
```csharp
routes.MapRoute(
   name: "Default",
   url: "{controller}/{action}/{id}",
   defaults: new { controller = "Project", action = "Home", id = UrlParameter.Optional },
   namespaces: new[] { "Corp.ProjectMVC.Controllers" }
);
```

##### MaxJsonLength exception
If you will encounter an exception with the following message:
```
Error during serialization or deserialization using the JSON JavaScriptSerializer. The length of the string exceeds the value set on the maxJsonLength property.
```
Find `<jsonSerialization>` tag in **Web.config** file and what is the **maxJsonLength**. The value may be too low for the data you want to send, for example:
```xml
<jsonSerialization maxJsonLength="5000000" />
```
Add the following method in controller:
```csharp
protected override JsonResult Json 
   (object data, string contentType, System.Text.Encoding contentEncoding, JsonRequestBehavior behavior)
{
   return new JsonResult()
   {
      Data = data,
      ContentType = contentType,
      ContentEncoding = contentEncoding,
      JsonRequestBehavior = behavior,
      MaxJsonLength = Int32.MaxValue
   };
}
```

##### Could not load file or assembly 'WebGrease' or one of its dependencies
-> Tools -> NuGet Package Manager -> Package Manager Console -> Install-Package WebGrease -Version 1.5.2

##### Invalid regular expression flags - in onclick
If you will do something like this:
```html
<a onclick='@Url.Action("Method", "Controller", new { jsonRegistryArray = Json.Encode(data.List) })'>@data.Name</a>
```
it won't work, but something like this will do:
```html
<a onclick='window.location.href="@Url.Action("Method", "Controller", new { jsonRegistryArray = Json.Encode(data.List) })"'>@data.Name</a>
```

##### Database connection error
Problems with database connection can have many different symptoms, but one of the very common is the following error message:
```
Server Error in '/' Application.
Runtime Error
Description: An exception occurred while processing your request. Additionally, another exception occurred while executing the custom error page for the first exception. The request has been terminated.
```
It is very generic error message that actually says nothing about the database, but it is often the reason. Some connection problems may occur when you will restore a database (login's passwords are cleared then).

##### Assembly not referenced in razor view
If you will encounter the the following error:
```
error CS0012: The type 'ClassName' is defined in an assembly that is not referenced. You must add a reference to assembly 'ProjectMVC, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null'
```
In your project in `\Views\Web.config`, inside of `<compilation><assemblies></assemblies></compilation>`, add the following markup:
```csharp
<add assembly="ProjectMVC, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null"/>
```

##### No assembly found containing an OwinStartupAttribute
If you see such an error then delete **Bin** and **Obj** directories because probably they contain **owin** libraries and your project has **owin** start class defined.

### DevExpress ASP.NET MVC Extensions
There are great extensions for ASP.NET MVC made by DevExpress, if you are interested to know more, go [here](https://github.com/abik11/tips-tricks/blob/master/DevExpress.md#asp.net-mvc-extensions).

## WCF
Windows Communication Foundation is a framework for developing services. It allows you to build services over different procotols and host them in many ways. It is very powerful, flexible and complex. It enforces you a bit to structure your project, you need to separate contracts (method and data contracts - DTO), logic (used by service), service, service hosting and client with a reference to the service.

### WCF Test Client
If you develop WCF services, there is a simple but nice tool distributed toegether with Visual Studio 2017 to test WCF services. You can find it in the following path: `C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE`.

### Service config editor
->Right click on: Web.config (in WCF project) ->Edit WCF Configuration

### Service method returning JSON
If you want to create a service method that will return JSON, so the data can be easily accessed and consumed through AJAX you have to add **WebInvoke** attribute to method defintion in the contract like this:
```csharp
[OperationContract]
[WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Wrapped")]
[return: MessageParameter(Name = "result")]
DataDto GetData();
```
Then in **Web.config** you have to add endopoint with **webHttpBinging**.
```xml
<system.serviceModel>
    <services>
        <service name="App.Service.MainService">
           <endpoint address="../MainService.svc"
             binding="webHttpBinding"
             contract="App.Contracts.IMainService"
             behaviorConfiguration="webBehaviour" />
        </service>
    </services>
</system.serviceModel>
<behaviors>
    <endpointBehaviors>
          <behavior name="webBehaviour">
             <webHttp/>
          </behavior>
    </endpointBehaviors> 
</behaviors>
```
It is also a good idea to enable CORS requests, also in **Web.config**:
```xml
<system.webServer>
    <httpProtocol>
        <customHeaders>
           <add name="Access-Control-Allow-Origin" value="*" />
           <add name="Access-Control-Allow-Headers" value="Content-Type, Accept" />
        </customHeaders>
    </httpProtocol>
</system.webServer>
```

### Service method taking JSON
If you want a method to get JSON object, you can take a **Stream** argument and deserialize it with **JavaScriptSerializer**, here you can see an example of method's contract:
```csharp
[OperationContract]
[WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Wrapped)]
[return: MessageParameter(Name = "result")]
DataDto AddNewData(Stream JSONDataStream);
```
And here is an example of the implementation:
```csharp
public DataDto AddNewData(Stream JSONDataStream)
{
   DataItem data = DeserializeJSONStream<DataItem>(JSONDataStream);
   Logic logic = new Logic();
   var newData = logic.AddNewData(data);
   return Mapper.Map<DataItemDto>(newData);
}

public static T DeserializeJSONStream<T>(Stream JSONDataStream)
{
   StreamReader reader = new StreamReader(JSONDataStream);
   string JSONdata = reader.ReadToEnd();
   JavaScriptSerializer JS = new JavaScriptSerializer();
   T data = JS.Deserialize<T>(JSONdata);
   return data;
}
```
You have to create a class to which your JSON will be deserialized.

### Returning big amounts of data
Sometimes you may want to return a lot of data through service method, but the default maximum size may not allow you. To change it, in Web.config add this:
```xml
<system.serviceModel>
<bindings>
    <basicHttpBinding>
        <binding name="LargeBuffer" 
                 maxBufferSize="2147483647" 
                 maxReceivedMessageSize="2147483647">
            <readerQuotas maxDepth="2147483647"
                          maxStringContentLength="2147483647"
                          maxArrayLength="2147483647"
                          maxBytesPerRead="2147483647"
                          maxNameTableCharCount="2147483647" />
        </binding>
    </basicHttpBinding>
</bindings>
</system.serviceModel>
```
and then while defining endpoints assign this configuration with **bindingConfiguration** attribute. Be careful, if you want to use configuration for other type of endpoint binding than basic HTTP binding, you have to define them separately with correct markups (for example **webHttpBinding**).

### Many endpoints for one service
Sometimes it is required to allow to communicate with service through different protocols. To achieve this you can define several endpoints for the service. Here you can see a basic HTTP endpoint and web HTTP endpoint:
```xml
<system.serviceModel>
<services>
    <service name="App.Service.MainService">
        <!--- BASIC ENDPOINT -->
        <endpoint address="base"
                  binding="basicHttpBinding"
                  name="MainServiceBasicHttpEndpoint"        
                  contract="App.Contracts.IMainService" 
                  bindingConfiguration="LargeBuffer" />
   
        <!-- WEB ENDPOINT --> 
        <!-- http://localhost:55555/MainService.svc/web -->
        <endpoint address="web"
                  binding="webHttpBinding"
                  name="MainServiceWebHttpEndpoint"        
                  contract="App.Contracts.IMainService"
                  behaviorConfiguration="webBehaviour"
                  bindingConfiguration="WebLargeBuffer" />
    </service>
</services>
</system.serviceModel>
```

### Error details
While developing WCF services you may want to know the details of errors that happen. As default WCF doesn't show any details which is quite smart in the context of security. To allow to send error details add the following in **Web.config**:
```xml
<behaviors>
<serviceBehaviors>
    <behavior name="">
        <serviceMetadata httpGetEnabled="true" />
        <serviceDebug includeExceptionDetailInFaults="true">
    </behavior>
</serviceBehaviors>
</behaviors>
```

### WCF errors
WCF is quite advanced technology and you may encounter many different errors while working with it. Here are listed some of them with solution that may help.

##### Cannot find type "App.Service.Service1" provided as the Service attribute value in the ServiceHost directive could not be found
->Right click on the service file (svc) ->Open With ->Web Service Editor ->Make sure that Service and Code Behind attributes have correct values.

##### Access to the path 'xyz' is denied
If you see such error, probably WCF service is trying to save or modify a file in a path where it is not allowed. You have to grant write permission on the given directory for application pool to which the service is assigned:<br />
->Right click on directory ->Properties ->Security ->Edit ->Add ->Advanced ->Locations... ->Choose current machine ->Object name: IIS APPPOOL\MyServiceAppPool<br /><br />
In case if you couldn't find the correct application pool (actually you always should), you can add the permission for **IIS_IUSRS** group:<br />
->Right click on directory ->Properties ->Security ->Edit ->Add ->Advanced ->Locations... ->Choose current machine ->Find now: IIS_IUSRS<br /><br />
You can also use the command:
```
cacls '\\100.110.60.111\c$\inetpub\MyApp_Service\Files' /E /G BUILTIN\IIS_IUSRS:F
```
* /E - do not delete current permissions
* /G - grant (/R - revoke) 
* :F - full access (:N - none)

Read more: https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc726004(v=ws.11)

##### The target assembly contains no service types. 
->Right click on the project that contains WCF contracts ->Properties ->WCF Options ->Start WCF Service Host when debugging another project in the same solution.

### Problems with using statement
Here is a common way in which you could call some method of WCF service - with using statement:
```csharp
using(DataServiceClient client = new DataServiceClient())
{
     client.ExecuteMethod();
}
```
This is actually translated to this one under the hood:
```csharp
DataServiceClient client = new DataServiceClient();
try
{
    client.ExecuteMethod();
}
finally
{
    client.Close(); // here an exception can be thrown and it will NOT be catched
}
```
If an exception will be thrown in the **finally** block then your connection to WCF service will not be closed properly. The safe way of executing WCF methods looks like this:
```csharp
DataServiceClient client = new DataServiceClient()
try
{
    client.ExecuteMethod();
}
catch(CommunicationException)
{
    client.Abort();
}
catch(TimeoutException)
{
    client.Abort();
}
catch(Exception)
{
    client.Abort();
    throw;
}
```
You can read more about this [here](https://docs.microsoft.com/en-us/dotnet/framework/wcf/samples/avoiding-problems-with-the-using-statement).

### AutoMapper
AutoMapper is an extremely useful library that allows you to map objects in C# from one class to another. It is very useful in the context of WCF, for example when you get some objects through your ORM and you have to convert them to DTO (Data Contracts) objects to be able to return them from a service method. With AutoMapper such operations are quite easy to do.

##### Add AutoMapper to project
->Tools ->NuGet Package Manager ->Package Manager Console ->`install-package AutoMapper`
* AutomapperConfiguration.cs
```csharp
public class AutomapperConfiguration
{
    public static void Configure()
    {
        Mapper.Initialize(ctg =>
        {
            ctg.CreateMap<Customer, CustomerDTO>();
        });
    }
}
```
* AutomapServiceBehavior.cs
```csharp
public sealed class AutomapServiceBehavior : Attribute, IServiceBehavior
{
    public AutomapServiceBehavior(){ }

    public void AddBindingParameters
        (ServiceDescription serviceDescription, ServiceHostBase serviceHostBase,
         Collection<ServiceEndpoint> endpoints, BindingParameterCollection bindingParameters)
    {
        AutomapperConfiguration.Configure();
    }

    public void ApplyDispatchBehavior
        (ServiceDescription serviceDescription, ServiceHostBase serviceHostBase){ }

    public void Validate
        (ServiceDescription serviceDescription, ServiceHostBase serviceHostBase){ }
}
```
* Service.svc
```csharp
[AutomapServiceBehavior]
[ServiceBehavior(InstanceContextMode = InstanceContextMode.PerCall)]
public class Service : IService { }
```

##### Modify properties while mapping
It is possible to define quite advanced mapping rules in AutoMapper configuration (inside of **Initialize** method). It is very common to set or modify values of some properties, see an example: 
```csharp
ctg.CreateMap<Employee, EmployeeDTO>()
    .ForMember(
        dest => dest.DateText, 
        opt => opt.MapFrom(src => src.Date.ToShortDateString())
    );
```

##### Collections
If you have the following mapping configuration:
```csharp
Mapper.Initialize(cfg => 
{ 
    cfg.CreateMap<Source, Dest>();
});
```
then you can also use mapped types with collections and arrays, so all the following expressions are correct:
```csharp
IEnumerable<Dest> dest = Mapper.Map<Source[], IEnumerable<Dest>>(sources);
ICollection<Dest> dest = Mapper.Map<Source[], ICollection<Dest>>(sources);
IList<Dest> dest = Mapper.Map<Source[], IList<Dest>>(sources);
List<Dest> dest = Mapper.Map<Source[], List<Dest>>(sources);
Dest[] dest = Mapper.Map<Source[], Dest[]>(sources);
```

##### Nested mappings
Nested mappings is a very important feature of AutoMapper. If a class internally stores an instance of another class, for example as a property or field, then if you will define mappings for the internally used class, AutoMapper will be able to map it toegether with the class that uses it.
```csharp
public class OuterSource{
     public InnerSource field1;
}

Mapper.Initialize(c=> {
     cfg.CreateMap<OuterSource, OuterDest>();
     cfg.CreateMap<InnerSource, InnerDest>();
});
```

### Fault contracts
Fault contracts are an elegant way of error handling in WCF. You can create a specified data contract that will be used for exceptions.
* DTO - Firstly you have to create a data contranct, the same way as a typical DTO
```csharp
[DataContract]
public class CustomFault 
{
    [DataMember]
    public string Message { get; set; }
    [DataMember]
    public string Code { get; set; }
}
```
* Service contract - Mark a method with **FaultContract** attribute
```csharp
[OperationContract]
[FaultContract(typeof(CustomFault))]
void RunMethod();
```
* Service - Catch an exception and throw **FaultException** of your DTO 
```csharp
public void RunMethod()
{
    try 
    {
        DoSomething();
    }
    catch(Exception)
    {
        CustomFault fault = new CustomFault();
        fault.Code = "XB10";
        fault.Message = "Unknown error";
        throw new FaultException<CustomFault>(fault);
    }
}
```

### Concurrent mode
To turn on concurrency for your WCF service you have to add the following attribute for your service:
```csharp
[ServiceBehaviour(ConcurrencyMode = ConcurrencyMode.Multiple)]
```

### Duplex method
To be able to implement duplex method you have to switch your service to **wsDualHttpBinding** binding mode. Duplex method allows you to call a callback after a service method is finished. See here how to set it up:
* Service
```csharp
[ServiceContract(CallbackContract = typeof(IServiceCallback))]
interface IService
{
    [OperationContract(IsOneWay = true)]
    void Method(string message);
}

interface IServiceCallback 
{
    [OperationContract(IsOneWay = true)]
    void Callback(string message);
}

public class Service : IService, IServiceCallback 
{
    public void Method(string message)
    {
        IServiceCallback callback = 
            OperationContext.Current.GetCallbackChannel<IServiceCallback>();
        callback.Callback(message);
    }
}
```
* Client
```csharp
public class Callback : ServiceReference.IServiceCallback
{
    public void Callback(string message)
    {
        MessageBox.Show(message);
    }
}

public class Client 
{
    public CallMethod()
    {
        var context = new InstanceContext(new Callback());
        ServiceClient client = new ServiceClient(context);
    }
}
```

### Transaction
Implementing transactions in WCF is not very easy, but sometimes it is absolutely necessary. Firstly you have to mark methods that use transactions with **TransactionFlow** attribute:
```csharp
[ServiceContract]
public interface IExampleService 
{
    [OperationContract]
    [TransactionFlow(TransactionFlowOption.Mandatory)]
    void UpdateData(string text);

    [OperationContract]
    [TransactionFlow(TransactionFlowOption.Mandatory)]
    void ExecuteOperation();
}
```
Then you also have to add a bunch of attributes in your service implementation:
```csharp
[ServiceBehavior(TransactionIsolationLevel = IsolationLevel.Serializable, TransactionTimeout = "00:00:30")]
public class ExampleService: IExampleService
{
    [OperationBehavior(TransactionScopeRequired = true, TransactionAutoComplete = true)]
    void UpdateData(string text){}

    [OperationBehavior(TransactionScopeRequired = true, TransactionAutoComplete = true)]
    void ExecuteOperation(){}
}
```
To be able to call transactional methods in the client side, you should use **TransactionScope**:
```csharp
using(TransactionScope scope = new TransactionScope())
{
    ExampleServiceClient client = new ExampleServiceClient();
    client.UpdateData(text);
    client.ExecuteOperation();
    scope.Complete();
    client.Close();
}
```

##### Transactions with sessions
If you want to create transactions with sessions you have to change the configuration of the attributes:
```csharp
[ServiceContract(SessionMode = SessionMode.Required)]
public interface IExampleService 
{
    [OperationContract]
    [TransactionFlow(TransactionFlowOption.Mandatory)]
    void UpdateData(string text);

    [OperationContract]
    [TransactionFlow(TransactionFlowOption.Mandatory)]
    void ExecuteOperation();
}

[ServiceBehavior(TransactionIsolationLevel = IsolationLevel.Serializable, TransactionTimeout = "00:00:30", 
InstanceContextMode = InstanceContextMode.PerSession, TransactionAutoCompleteOnSessionClose = true)]
public class ExampleService: IExampleService
{
    [OperationBehavior(TransactionScopeRequired = true, TransactionAutoComplete = false)]
    void UpdateData(string text){}

    [OperationBehavior(TransactionScopeRequired = true, TransactionAutoComplete = false)]
    void ExecuteOperation(){}
}
```

## Performance tips
Performance is often a very important factor. But to be able to optimize and speed up something it is crucial to know how C# runtime and the language itself work. Also keep in mind that you should optimize stuff only when it is really necessary. If something works pretty fast there is no point in waisting your time trying to gain few miliseconds speed up unless you develop some real time software of a game.

### Measuring performance
The most basic thing if you want to optimize a code is to measure its performance. You cannot do some real optimization if you cannot measure how long a code executes. There quite many ways how to measure performance, here you will see few basic easy to implement methods.

##### Method 1
```csharp
DateTime start = DateTime.UtcNow;

// some code to measure

DateTime stop = DateTime.UtcNow;
int measuredTime = (stop - start).TotalMilliseconds;
```
It is a quite fast method, but with low accuracy - requires many loops over measured code. May give unrealiable results if system time changes while measurements are taken.

##### Method 2
```csharp
TimeSpan start = Process.GetCurrentProcess().TotalProcessorTime;

// some code to test

TimeSpan stop = Process.GetCurrentProcess().TotalProcessorTime;
int measuredTime = (stop - start).TotalMilliseconds;
```
Slow method, but with good accuracy, it uses different mechanism - measures how long CPU was busy, not how much time passed. Important things to note are that time inside sleep is not counted, but excution on two CPUs is counted as 200%!

##### Method 3
```csharp
Stopwatch watch = new Stopwatch();
watch.Start();

// some code to test

watch.Stop();
int measuredTime = watch.Elapsed.TotalMilliseconds;
```
This method has a very good accuracy and is quite common. Two methods can be very useful while working with **Stopwatch** class: 
* **Reset** - stops and sets the result to 0
* **Restart** - stops, sets the result to 0 and starts again

### GC object's generations
Garbage Collector puts every object in one of 3 levels called generations. Generation 0 holds small short living objects. It is the fastest generation, but it is also the smallest one. Generation 2 is the slowest, but also the biggest one. It holds big objects that are supposed to be used many times in the application lifetime. Generation 1 is something in between of generatons 0 and 2. If you want to know in which generation is given object hold, use the following code:
```csharp
byte[] data = new byte[90000]; 
GC.GetGeneration(data); //returns 0, 1 or 2 [here 2]
```
Large objects, over 85000 bytes are stored in Large Object Heap (LOH), which is not divided by generations.

### Fast binary string comparison
```csharp
String.Equals("test", "TEST", StringComparison.OrdinalIgnoreCase);
```

### Decimal vs. double
**Double** and **float** store numbers in the base of 2, while **Decimal** stores numbers in the base of 10. Double and float are much faster because the processor can work on them directly. On the other hand Decimal is much more accurate in calculations.

### Reference and value types
Objects are given as reference by default. Value types and structs are given by value, **ref** and **out** keywords have any meaning only when they are used with them.<br />
Value types cannot be modified. Every time when some kind of modification is tried to be done, a new new value is created instead. That's why for example if you want to modify some string many times, it is recomended to use **StringBuilder** class. See an example:
```csharp
//in such little example it is ok, but for much more modifications it is not a good way   
string tmp1 = "a" + "b" + "c"; 

StringBuilder tmp2 = new StringBuilder();
tmp2.append("a").append("b").append("c");
```
In case of reference types it is important to remember that their values are not copied, but they reference are. In the following example both `tmp1` and `tmp2` are references to **the same object**:
```csharp
List<int> tmp1;
List<int> tmp2 = tmp1; 
```

### Performance tips
* Avoid boixng and uboxing (casting variables to **object**) - use `int[]` and `List<int>` instead of **List** and **ArrayList**
* Use **StringBuilder** - it uses the pointer to the string internally and does not create new string every time you try to modify it.
* Array of int (`int[]`) is faster than list of int (`List<int>`) and faster than anything else actually.
* For loop is faster than foreach loop while iterating lists (but both are very fast for `int[]`).
* Do NOT use two-dimensional arrays. Instead flatten the array. Instead of indexing the array like this `[x, y]`, you will have to this like this `[x * columns + y]`. If you cannot flatten the array (probably always you can) better use jagged arrays than two-dimensional.
* If it is possible avoid throwing exceptions and never catch general exceptions of **Exception** class.
* Use `int.TryParse` instead of `int.Parse` - **TryParse** doesn't throw exceptions.
* Use many small and short living objects, don't let them to be put into 1 and 2 generation of GC and use few large and long living objects that will be put on large objects heap. This way you will go along with Garbage Collector strategy and take advantage of it.

### Intermediate language

Programs written in C# are translated to [**Common Intermediate Language** (CIL)](https://en.wikipedia.org/wiki/Common_Intermediate_Language). This is a language which looks like Assembler a bit with and it is then executed by the .NET Runtime. That's why C# applications can be portable because if you have .NET Runtime installed on your operating system you will be able to run C# program. It is not mandatory to know CIL and its instructions but it is quite advisable to at least understand some most basic concepts of how C# programs look after compilation to CIL.<br />
Here you can see some most basic instructions (this is not an example of a program):
```
ldc.i4.1       //load constant 1 as integer 32bit and put it on stack
ldloc.0        //load value from variable location 0 and put it on stack
stloc.1        //take a value from the top of stack and store it in variable location 1
add            //add two top values on stack
bne #000000a   //branch not equal - go to given instruction if two top values on stack are not equal
br #000000a    //branch to given instruction
```
And here you can see an example.<br/>
C# code:
```csharp
array[5] = 10;
```
CIL code:
```
ldloc.0     /// array
ldc.i4.5    /// [5]
ldc.i4.s 10 /// 10
stelem.i4   /// =
```
[Here](https://en.wikipedia.org/wiki/List_of_CIL_instructions) you can see the whole list of instructions. You can decompile .NET programs with **ildasm.exe**. You can find it usually in the following path: `C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools` and [here](https://docs.microsoft.com/en-us/previous-versions/dotnet/netframework-2.0/f7dy01k1(v=vs.80)) you can find the docs.

## Other

### NLog
NLog (or other logging utility) allows you to write logs of your application to be able to analyze the way it behaves, find bugs or quickly troubleshoot issues. It is easy to use and install - you can download it from NuGet. [Here](https://github.com/abik11/Dev-Suite/blob/master/Dev/Merge-NLogs.psm1) is a little Powershell script that helps analyzing logs generated by NLog.

##### Example of NLog configuration
NLog.config:
```xml
<?xml version="1.0" encoding="utf-8" ?>
<nlog xmlns="http://www.nlog-project.org/schemas/NLog.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.nlog-project.org/schemas/NLog.xsd NLog.xsd"
      autoReload="true"
      throwExceptions="false"
      internalLogLevel="Off" internalLogFile="c:\temp\nlog-internal.log">

   <targets>
      <target name="traceLog"
         xsi:type="File"
         fileName="${basedir}/logs/trace.txt"
         layout="APP_LOGIC|${longdate}|${level}|${callsite}|${machinename} ${message}"
         archiveFileName="${basedir}/logs/trace.{#}.txt"
         archiveEvery="Day"
         archiveNumbering="Rolling"
         maxArchiveFiles="10" />

      <target name="errorLog"
         xsi:type="File"
         fileName="${basedir}/logs/error.txt"
         layout="APP_LOGIC|${longdate}|${level}|${callsite}|${machinename} ${message}"
         archiveFileName="${basedir}/logs/error.{#}.txt"
         archiveEvery="Month"
         archiveNumbering="Rolling"
         maxArchiveFiles="50" />
   </targets>

   <rules>
      <logger name="*" minlevel="Trace" writeTo="traceLog" />
      <logger name="*" minlevel="Error" writeTo="errorLog" />
   </rules>
</nlog>
```
The simplest way to add NLog to a class:
```csharp
protected static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();
//logger.Trace(); logger.Error(); etc...
```
it is a good idea to use dependency injection and inject **NLog.Logger** class - see [here](https://ludwigstuyck.wordpress.com/2013/03/04/avoiding-the-use-of-static-variables-when-using-log4net/).

##### NLog is not logging
If you have configured NLog and it is not logging nothing at all the first step you should do is to change the value of **internalLogLevel** from **Off** (`internalLogLevel="Off"`) to **Debug** (`internalLogLevel="Debug"`) and set **internalLogFile** where NLog will write its own logs (`internalLogFile="c:\temp\nlog-internal.log"`).<br />
Quite often the problem is about the permissions to a given path to which NLog is supposed to write, but if it is something else you will be able to find answer from NLog internal logs.

### Colors in .Net
In general colors in .Net are represented by **Color** class form **System.Drawing** namespace. They consist of four 8 bit numbers representing transparency (alpha), red, green and blue and the whole color can be represented simply by a 32 bit integer value. For example *-5658199* is some kind of grey. To convert it to hex notation or ARGB you can use Powershell. **FromArgb** static method of **Color** class returns an object of type **Color** with all the color details.
```powershell
Add-Type -AssemblyName System.Drawing
$color = [System.Drawing.Color]::FromArgb(-5658199)
$color.Name
```
This integer is nothing more than just color written as ARGB in decimal notation instead of hexadecimal, the one that we are all used to when it comes to dealing with colors. You can see the hex notation accessing **Name** property of color object. Building a new color is quite easy also if you know red, green and blue elements. You just have to use **ToArgb** method to get the color representation as decimal integer:
```powershell
$color = [System.Drawing.Color]::FromArgb(216, 216, 216)
$color.ToArgb()
```

## Useful links

##### General stuff
[Ventajas de yield return - ESP](https://bmegias.wordpress.com/2010/11/10/que-es-yield-y-por-que-hay-que-usarlo/)<br/>
[C# blog - Polish](https://www.plukasiewicz.net/)<br />

##### Online tools
[C# Online Compiler](https://dotnetfiddle.net/)<br />
[.Net error translator 1](http://finderr.net/)<br />
[.Net error translator 2](http://www.errortoenglish.com/)<br />
[Regex editor](http://regexr.com/)<br />
[Barcode generator](http://barcode.tec-it.com/en)<br />

##### WPF
[WPF Snoop](https://github.com/cplotts/snoopwpf)<br />

##### ASP.NET MVC
[ASP.NET MVC 5 Internationalization](http://afana.me/archive/2011/01/14/aspnet-mvc-internationalization.aspx/)<br />
[HTTP File Upload](https://www.hanselman.com/blog/ABackToBasicsCaseStudyImplementingHTTPFileUploadWithASPNETMVCIncludingTestsAndMocks.aspx)<br />
[Dynamic image generation](https://www.hanselman.com/blog/BackToBasicsDynamicImageGenerationASPNETControllersRoutingIHttpHandlersAndRunAllManagedModulesForAllRequests.aspx)<br />
[Global authentication and Allow Anonymous](https://weblogs.asp.net/jongalloway/asp-net-mvc-authentication-global-authentication-and-allow-anonymous)<br />

##### WCF
[WCF Web Services Tutorial](http://mikesknowledgebase.azurewebsites.net/pages/Services/WebServices.htm)<br />
[Hosting WCF Services](https://docs.microsoft.com/en-us/dotnet/framework/wcf/hosting-services)<br />
[Hosting and consuming WCF Services](https://msdn.microsoft.com/en-us/library/bb332338.aspx)<br />
[WCF project's structure](https://www.codemag.com/article/0809101)<br />
[AutoMapper](https://github.com/AutoMapper/AutoMapper/wiki)<br />
[Referencja Cykliczna - PL](https://cezarywalenciuk.pl/blog/programing/post/wcf-i-circular-reference-referencja-cykliczna)<br />
