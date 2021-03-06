## Performance tips
Performance is often a very important factor. But to be able to optimize and speed up something it is crucial to know how C# runtime and the language itself work. Also keep in mind that you should optimize stuff only when it is really necessary. If something works pretty fast there is no point in waisting your time trying to gain few miliseconds speed up unless you develop some real time software or a game.

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
int measuredTime = (int)watch.Elapsed.TotalMilliseconds;
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

### Immutable strings
Strings cannot be modified. Every time when some kind of modification is tried to be done, a new new value is created instead. That's why it is recomended to use StringBuilder class. See an example:
```csharp
//in such little example it is ok, but for much more modifications it is not a good way
string tmp1 = "a" + "b" + "c";

StringBuilder tmp2 = new StringBuilder();
tmp2.append("a").append("b").append("c");
```

### Decimal vs. double
**Double** and **float** store numbers in the base of 2, while **Decimal** stores numbers in the base of 10. Double and float are much faster because the processor can work on them directly. On the other hand Decimal is much more accurate in calculations.

### Reference and value types
Reference type variables store a reference to the object stored on the heap. Value type variables (and structs among them) store the real value that is stored on the stack. It is important to remember that their value is not copied, but their reference is. In the following example both `tmp1` and `tmp2` are references to **the same object**:
```csharp
List<int> tmp1;
List<int> tmp2 = tmp1;
```
Read much more [here](https://adamsitnik.com/Value-Types-vs-Reference-Types/#summary) and also a little bit [here](https://devblogs.microsoft.com/premier-developer/box-or-not-to-box-that-is-the-question/).<br />
When a **value type** is defined as a field **inside of a reference type**, the complete data of the value type instance is stored inline within the instance of the reference type inside **GC Heap**.<br />
On the other hand, when a **reference type** is defined as a field **inside of a value type**, **only the object reference** to the reference type instance is stored on **stack** inline within the instance of the value type. In such case the **reference type instance** is still and **ALWAYS** stored in **GC Heap**.

#### Ref vs. out
The value of the reference of the object is passed to the function when object is passed as an argument. And in case of value types the value itself is passed (what might be an overkill if the value is big). But with **ref** and **out** it is possible to also pass value type variables by reference.
* ref - means that the given argument will be passed by reference and may be modified within the function (changes made to the argument will be preserved)
* out - means that the given argument will be passed by reference and it will be initialized or a value will be assigned to it (so it doesn't have to be initialized before passing it to the method - which is quite unusual for value types)

See here an example:
```csharp
namespace Test 
{
    struct Product 
    {
        public int Code { get; set; }
    }
    
    class Program
    {
        static void SetProduct(out Product p)
        {
            //out forces you to initialize or assign a value to the parameter that is marked as out
            p = new Product();
        }

        static void SetProduct(ref Product p)
        {
                //you cannot have overloaded methods that differ only with ref and out            
        }
        
        static void Main(string[] args)
        {
            Product p;
            SetProduct(out p);
        }
    }
}
```

#### Why to use ref or out with reference types?
It is said that reference types instances are passed by reference, but it is a mental shortcut. What is really passed to a function when you specify an instance (object) of a reference type (class) as a parameter is the **VALUE** of the reference. What does it mean in practice? That you cannot change the object you pass to the function - see an example:
```csharp
class Product
{
    public int Code { get; set; };
    public Product(int code) => Code = code;
}

static void CreateProduct(Product p, int code) => p = new Product(code);

static void Main()
{
    Product p = new Product(10);

    Console.WriteLine(p.Code); //prints 10
    CreateProduct(p, 20);
    Console.WriteLine(p.Code); //prints 10
}
```
In the `CreateProduct` function a new object was created and its reference was assigned to local variable (parameter) `p` which cannot be accessed out of the function. The reference value that was passed to the function did not changed, neither did the object.<br />To allow modification of the object **ref** should have been used.

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
