## C# Language

## Table of contents
* [Syntax](#syntax)
* [Enums](#enums)
* [IDisposable](#idisposable)
* [Image and byte arrays](#image-and-byte-arrays)
* [Collections](#collections)
* [Other tips](#other-tips)

## Syntax
There are many nice syntax construction that may help you a lot while working with C#. With every new version of the language there is also some nice new syntactic sugar added. Here you will find few examples from basic to some less known language constructions.

### Differences between casting and **as** operator
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

### Differences between abstract classes and interfaces
The difference between the both concepts may not be so clear. In some programming languages there is actually no difference between them two. But in C# there are differences and it is very good to know about them. Here is a little list with a bunch of differences:
* a class can implement many interfaces but it can inherit from only one abstract class
* interface cannot contain method implementation, only definition, while abstract class can contain both
* interface methods and members can only be public
* interface cannot contain fields
* interface can only contain methods definition, properies, events and delgates
* abstract class can contain constructor declaration while interface cannot
In general an abstract class should be use as a base for other more specific classes. For example *SqlDatabaseConnection* could be an abstract class while *SQLServerConnection* or *MySqlConnection* could be concrete classes thar extend *DatabaseConnection*. And interface is rather used to describe external abilities of a class which may be common between many different classes.

### Create an instance of a generic type
```csharp
var instanceOfGeneric = Activator.CreateInstance(
    typeof(TType), arg1, arg2, arg3) as TType;
```

### Extension methods
```csharp
static bool Contains(this string keyString, char c)
{
   return keyString.IndexOf(c) >= 0;
}

bool test = "Some string".Contains('s');
```

### User-defined conversion
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

### Check if integer is not overflowing the maximum value
```csharp
checked {
   int value = int.MaxValue;
   value += 1;
}
```
The code above will throw **OverflowException** if the variable `value` will exceed the maximum integer value, instead of for example giving a strange result.

### Logical consequence
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

## Enums

### Enums with descriptions
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

### Get description - extension method
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

### Iterate through all enum values
```csharp
foreach(EnumType value in Enum.GetValues(typeof(EnumType)))
{
   Console.WriteLine(value.GetDescription());
}
```

## IDisposable
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

## Image and byte arrays

### Convert Image to byte[]
```csharp
MemoryStream mstream = new MemoryStream();
image.Save(mstream, System.Drawing.Imaging.ImageFormat.Png);
byte[] bytes  = mstream.ToArray();
```

### Convert byte[] to Image
```csharp
MemoryStream mstream = new MemoryStream(imageBytes);
Image image = Image.FromStream(mstream);
```

### Image file MIME type
```csharp
ImageCodecInfo codec = ImageCodecInfo.GetImageDecoders().FirstOrDefault(x => x.FormatID == image.RawFormat.Guid);
string fileMimeType = codec.MimeType;
```

### Write byte array to file
```csharp
System.IO.File.WriteAllBytes("fileName", data); 
```

## Collections

### Get value from dictionary
```csharp
string value = String.Empty;
dictionary.TryGetValue("Key", out value);
```

### Add an element to IEnumerable 
```csharp
someIEnumerableOfString.Concat(new[]{ "new element" });
```

### Tuple
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

### Lazy
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

## Other tips

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

### Launch debugger from code
```csharp
Debugger.Launch();
```
[See more](https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.debugger.launch)
