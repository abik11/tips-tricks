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

### Sending requests to API with OAuth 2.0 authorization
```csharp
var client = new RestClient("https://yoururl.com/api/users");
client.Authenticator = new OAuth2AuthorizationRequestHeaderAuthenticator("yourtoken", "Bearer");
var request = new RestRequest(Method.POST);
request.AddHeader("Content-Type", "application/json");
request.AddJsonBody(new { UserId: "alberto" });
var response = client.Execute(request);
```

### DevExpress ASP.NET MVC Extensions
There are great extensions for ASP.NET MVC made by DevExpress, if you are interested to know more, go [here](https://github.com/abik11/tips-tricks/blob/master/DevExpress.md#asp.net-mvc-extensions).
