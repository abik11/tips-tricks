## Threading
Modern processors usually are build with few cores that allows us to run many threads. There are also few ways in C# to work with threads. The most common ways are to work with plain old **Thread** class and **TPL** (Task Programming Library) which is based on **Task** class that is easy to use and allows to use asynchronous programming.

## Table of contents
* [Locking](#locking)
* [Mutex](#mutex)
* [Task](#task)

## Locking
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

#### What a lock really is
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

#### Spin lock
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

## Mutex 
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

## Task
```csharp
var task = Task<string>.Factory.StartNew(() => {
    Thread.Sleep(2000);
    return "This is a result from the task";
});

Console.WriteLine(task.Result);
```
Task are cool, they do all the communication between threads in the background for us. When you try to access the task's result, the main thread will wait for the task to finish. An important thing to note is that as default tasks are background thread so they will finish immediately toegether with main thread, so the main thread will not wait for the tasks to finish. It can be checked if a thread is background or foreground thread.<br />
If a task doesn't return any value you still have to wait for it in a main thread if you don't want it to be stopped when main thread finishes - you have to call the Wait() method of task object.

### Waiting for tasks
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

### Long tasks
```csharp
var task = Task.Factory.StartNew(() => {
    Console.WriteLine("Text from a task!");
    throw new InvalidOperationException();
}, TaskCreationOptions.LongRunning);
```
As default tasks are instantiated from **Default Thread Pool** and that's cool for small tasks, but for long running tasks it may cause performance loss, so we have to mark a task as long running to force it to be created out of **Default Thread Pool**. 

### Error handling
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

### Task initialization and name
```csharp
string message = "A message from out of the task";
var task = Task.Factory.StartNew(state => {
    Console.WriteLine(message);
}, "TaskName1");
```
A lambda expression can access the variables declared before the task starts. A nice trick is to add state parameter for lambda and to put there a string value that will be a task name which is good for debugging.

### Task cancellation
```csharp
var tokenSource = new CancellationTokenSource();
var token = tokenSource.Token;

var task = Task.Factory.StartNew(() => {
    Thread.Sleep(4000);
    Console.WriteLine(message);
}, token);

tokenSource.Cancel();
```