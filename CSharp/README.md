# CSharp
Oh C#... the language of love! :D The one to rule them all, the best of the bests :D This document will be constantly in progress, at least I hope so. It is not a from zero to hero guide to teach C# language. It is rather some gathering of things that was useful or interesting for me while working as a programmer, especially at the beginning.

* [Language tips](https://github.com/abik11/tips-tricks/blob/master/CSharp/Language.md)
* [Linq](https://github.com/abik11/tips-tricks/blob/master/CSharp/Linq.md)
* [Threading](https://github.com/abik11/tips-tricks/blob/master/CSharp/Threading.md)
* [WinForms](https://github.com/abik11/tips-tricks/blob/master/CSharp/GUI.md#winforms)
* [WPF](https://github.com/abik11/tips-tricks/blob/master/CSharp/GUI.md#wpf)
* [ASP.NET MVC](https://github.com/abik11/tips-tricks/blob/master/CSharp/ASPNET_MVC.md)
* [WCF](https://github.com/abik11/tips-tricks/blob/master/CSharp/WCF.md)
* [IIS](https://github.com/abik11/tips-tricks/blob/master/CSharp/IIS.md)
* [XML](https://github.com/abik11/tips-tricks/blob/master/CSharp/XML.md)
* [Performance tips](https://github.com/abik11/tips-tricks/blob/master/CSharp/Performance.md)
* [NUnit](https://github.com/abik11/tips-tricks/blob/master/CSharp/NUnit.md)
* [NLog](https://github.com/abik11/tips-tricks/blob/master/CSharp/NLog.md)
* [Useful links](#useful-links)

Read also:
* [Databases](https://github.com/abik11/tips-tricks/blob/master/DB)
* [Excel COM](https://github.com/abik11/tips-tricks/blob/master/VBA.md#c)
* [Visual Studio](https://https://github.com/abik11/tips-tricks/blob/master/DevTools.md#visual-studio)
* [TFS](https://https://github.com/abik11/tips-tricks/blob/master/DevTools.md#tfs)
* [DevExpress](https://github.com/abik11/tips-tricks/blob/master/DevExpress)

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

## Useful links

##### General stuff
[C# blog - Polish](https://www.plukasiewicz.net/)<br />
[C# blogs - Polish](https://dotnetomaniak.pl/)<br />
[C# blog - English](https://medium.com/@mdfarragher)<br />
[Ventajas de yield return - ESP](https://bmegias.wordpress.com/2010/11/10/que-es-yield-y-por-que-hay-que-usarlo/)<br/>
[Unit testing made easy Part 1: Repository Testing](https://www.codeproject.com/Articles/488264/Unit-testing-made-easy-Part-Repository-Testing)<br />
[Office Development in Visual Studio](https://www.red-gate.com/simple-talk/dotnet/c-programming/office-development-in-visual-studio/)<br />
[Distributed .NET Core](https://devmentors.io/distributed-net-core/)<br />
[Selenium testing page - good for learning](http://testing.todvachev.com/)<br />

##### .Net libraries and frameworks
[Nancy - Lightweight Web Framework for .Net](http://nancyfx.org/)<br />
[MailKit - .NET library for IMAP, POP3, and SMTP](https://github.com/jstedfast/MailKit)<br />
[RestSharp - Simple REST and HTTP API Client for .NET](https://github.com/restsharp/RestSharp)<br />
[AutoMapper](https://github.com/AutoMapper/AutoMapper/wiki)<br />
[Akka.NET](https://hryniewski.net/2017/03/22/akka-net-1-creating-actor-system-and-making-first-contact/)<br />

##### Online tools
[C# Online Compiler](https://dotnetfiddle.net/)<br />
[.Net error translator 1](http://finderr.net/)<br />
[.Net error translator 2](http://www.errortoenglish.com/)<br />
[Regex editor](http://regexr.com/)<br />
[Barcode generator](http://barcode.tec-it.com/en)<br />

##### WPF
[WPF Snoop](https://github.com/cplotts/snoopwpf)<br />

##### WCF
[WCF Web Services Tutorial](http://mikesknowledgebase.azurewebsites.net/pages/Services/WebServices.htm)<br />
[Hosting WCF Services](https://docs.microsoft.com/en-us/dotnet/framework/wcf/hosting-services)<br />
[Hosting and consuming WCF Services](https://msdn.microsoft.com/en-us/library/bb332338.aspx)<br />
[WCF project's structure](https://www.codemag.com/article/0809101)<br />
[Referencja Cykliczna - PL](https://cezarywalenciuk.pl/blog/programing/post/wcf-i-circular-reference-referencja-cykliczna)<br />

##### ASP.NET MVC
[ASP.NET MVC 5 Internationalization](http://afana.me/archive/2011/01/14/aspnet-mvc-internationalization.aspx/)<br />
[HTTP File Upload](https://www.hanselman.com/blog/ABackToBasicsCaseStudyImplementingHTTPFileUploadWithASPNETMVCIncludingTestsAndMocks.aspx)<br />
[Dynamic image generation](https://www.hanselman.com/blog/BackToBasicsDynamicImageGenerationASPNETControllersRoutingIHttpHandlersAndRunAllManagedModulesForAllRequests.aspx)<br />
[Global authentication and Allow Anonymous](https://weblogs.asp.net/jongalloway/asp-net-mvc-authentication-global-authentication-and-allow-anonymous)<br />

#### ASP.NET Core
[REST APIs with ASP.NET Core](https://www.freecodecamp.org/news/an-awesome-guide-on-how-to-build-restful-apis-with-asp-net-core-87b818123e28/)<br />
[ASP.NET Core Web API Best Practices](https://code-maze.com/aspnetcore-webapi-best-practices/)<br />

#### ASP.NET Core Authorization
[How to set up two factor authentication in ASP.NET Core using Google Authenticator](https://medium.freecodecamp.org/how-to-set-up-two-factor-authentication-on-asp-net-core-using-google-authenticator-4b15d0698ec9)<br />
[Authentication Using Google](https://ankitsharmablogs.com/authentication-using-google-asp-net-core-2-0/)<br />
[Authentication Using Facebook](https://ankitsharmablogs.com/authentication-using-facebook-in-asp-net-core-2-0/)<br />
