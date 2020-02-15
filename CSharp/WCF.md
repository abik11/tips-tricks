## WCF
Windows Communication Foundation is a framework for developing services. It allows you to build services over different procotols and host them in many ways. It is very powerful, flexible and complex. It enforces you a bit to structure your project, you need to separate contracts (method and data contracts - DTO), logic (used by service), service, service hosting and client with a reference to the service.

## Table of contents
* [Basics](#basics)
* [WCF Errors](#errors)
* [AutoMapper](#automapper)
* [Advanced topics](#advanced-topics)
* [Transactions](#transactions)

## Basics

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

## WCF errors
WCF is quite advanced technology and you may encounter many different errors while working with it. Here are listed some of them with solution that may help.

### Cannot find type "App.Service.Service1" provided as the Service attribute value in the ServiceHost directive could not be found
->Right click on the service file (svc) ->Open With ->Web Service Editor ->Make sure that Service and Code Behind attributes have correct values.

### Access to the path 'xyz' is denied
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

### The target assembly contains no service types. 
->Right click on the project that contains WCF contracts ->Properties ->WCF Options ->Start WCF Service Host when debugging another project in the same solution.

### The connection was closed unexpectedly
If you see an exception of the following content: `The underlying connection was closed: The connection was closed unexpectedly` it is probably not very descriptive and may mean quite many things. In my experiance 90% (more or less) of cases with this exception were caused by incorrect data that was going to be send by a service method. For example, returned DTO type had a property of enum type and in the returned object the value was "out of range" of this enum. See example:
```csharp
public enum MyEnum 
{
    A = 0;
    B = 1;
}

[DataContract]
public class DataDto 
{
    [DataMember]
    public MyEnum EnumProp;
}
```
And in case like this if somehow you try to serialize in WCF service to send it to the client the **DataDto** object with **EnumProp** being equal to *2*, you may see the exception.

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

## AutoMapper
AutoMapper is an extremely useful library that allows you to map objects in C# from one class to another. It is very useful in the context of WCF, for example when you get some objects through your ORM and you have to convert them to DTO (Data Contracts) objects to be able to return them from a service method. With AutoMapper such operations are quite easy to do.

### Add AutoMapper to project
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

### Modify properties while mapping
It is possible to define quite advanced mapping rules in AutoMapper configuration (inside of **Initialize** method). It is very common to set or modify values of some properties, see an example: 
```csharp
ctg.CreateMap<Employee, EmployeeDTO>()
    .ForMember(
        dest => dest.DateText, 
        opt => opt.MapFrom(src => src.Date.ToShortDateString())
    );
```

### Collections
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

### Nested mappings
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

## Advanced topics

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

## Transactions
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