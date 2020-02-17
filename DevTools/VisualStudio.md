## Visual Studio
Visual Studio is an amazing IDE with a plenty of tools, options and configurations that may confuse many users. Moreover it is good to learn some tricks that will make your life as a developer much easier. Here you will find some tips and advices that may be useful. Most of the thing you will see here is valid for Visual Studio 2017, but many tips should also work in Visua Studio 2015.

### Keyboard shortcuts
Visual Studio has a lot of nice keyboard shortcuts that can speed up your work, instead of clickling all the time you can do many things with just two or three keys. Here are only some of the most useful shortcuts.

##### Comments
* Comment selected lines of code<br />`CTRL + K, CTRL + C`
* Uncomment selected lines of code<br />`CTRL + K, CTRL + U`

##### Debbugging
* Start debugging<br />`F5`
* **Run without debugging**<br />`CTRL + F5`
* **Attach debugger to process**<br />`CTRL + ALT + P`
* Add breakpoint<br />`F9`
* Jump to next break point<br />`F5`
* Go to next line<br />`F10`
* Go deeply to next line<br />`F11`
* Exception Settings<br />`CTRL + ALT + E`
* Breakpoint Window<br />`CTRL + ALT + B`
* Stop debugging<br />`SHIFT + F5`

##### Bookmarks
* Add bookmark<br />`CTRL + K, CTRL + K`
* Go to next bookmark<br />`CTRL + K, CTRL + N`
* Go to previous bookmark<br />`CTRL + K, CTRL + P`
* Delete all bookmarks<br />`CTRL + K, CTRL + L`

##### Text editor
* Select the word pointed by the cursor (very useful!)<br />`CTRL + W`
* Move the line up<br />`ALT + ArrowUp`
* Move the line down<br />`ALT + ArrowDown`
* Duplicate the current line<br />`CTRL + C, CTRL + V`
* Go to line<br />`CTRL + G`

##### Show definition
* Go to definition<br />`F12`
* Show definition - **peek view** (this is really cool!)<br />`ALT + F12`
* **Find all references**<br />`SHIFT + F12`
* Navigate backward<br />`CTRL + -`
* Navigate forward<br />`CTRL + SHIFT + -`

##### Quick actions and search
* Quick Search<br />`CTRL + Q`
* **Full text search**<br />`CTRL + SHIFT + F`
* Quick Action (suggests solutions for problems in code)<br />`CTRL + .`
* Search in Solution Explorer<br />`CTRL + ;`
* Quick Info<br />`CTRL + K, CTRL + I`

##### Other
* Repair code indention (this is amazing!)<br />`CTRL + K, CTRL + D`
* Create a method<br />`CTRL + K, CTRL + M`
* Roll and expand regions<br />`CTRL + M + M`
* Go to opening/closing bracket<br />`CTRL + }`
* Solution Explorer<br />`CTRL + ALT + L`
* Command Window (`redo`, `undo`, `Debug.Print variableName`)<br />`CTRL + AlT + A`
* Threads, a window showing current threads<br />`ALT + CTRL + H`

### TAB options
It is important to set the same tab options in the developer team because source control system can see different code indention as changes in the code. To set tab options go to: ->Tools ->Options ->Text Editor ->All Languages ->Tabs, and set:
* Tab size: 3
* Indent size: 3
* Insert spaces: True

### Turn off Word Wrap
Word Wrap is a setting that will break all the lines of code that are too long to fit the screen. Some people may like it, some not. If you want to change this setting go to: ->Tools ->Options ->Text Editor ->All Languages ->General ->Word Wrap

### Scrollbar with code previev
There is a nice feature in Sublime text editor, that it shows a little code previev on the scrollbar. In Visual Studio it is called **map mode**, to turn it on right clik on the scrollbar and go to: ->ScrollBar Options ->Behavior ->**Use map mode for vertical scroll bar**. You can also check the **Show Previev Tooltip** option, which will show some additional preview when you will move mouse over the scrollbar.

### Turn off exceptions
Sometimes while debugging the application may throw a lot of exceptions that we don't care at the moment. We can turn off some exceptions or even all of them. Go to **Exceptions Settings**: ->Debug ->Windows ->Exceptions Settings or push `CTRL + ALT + E` and simply choose which exceptions you want to turn off.

### ReSharper
**R#** is a paid VS extension which adds bunch of new functionality, new key shortcuts and more.
* Find a file, class or method<br />`CTRL + T`
* Find a method<br />`ALT + \`
* Move block of code<br />`CTRL + ALT + SHIFT`
* Open current file in Solution Explorer<br />`SHIFT + ALT + L`
* Unit Test Explorer<br />`CTRL + ALT + U`

##### dotTrace
In case of serious problems with performance it is a good idea to use profiler and one of the best .NET profilers on the market is **dotTrace** which can be downloaded [here](https://www.jetbrains.com/profiler/?gclid=EAIaIQobChMImubjwu2y5gIVCqqaCh3tEA7tEAAYASAAEgKOavD_BwE). It is only free for 10 days but it is worth trying.

### Nice Visual Studio extensions
* **VSColorOutput** - it colors the output in Output Window, making it much more readable
* **Indent Guides** - it shows line for each code indention level, since VS2017 such feature is already implemented in Visual Studio
* **ResXManager** - described in the next tip

### ResXManager
This is a very popular extension that allows to easily manage string resources in the application. It is especially useful when you want to support many different languages in your application.<br />

##### Install
->Tools ->Extensions and Updates ->Online ->Search: ResXManager ->Download

##### Open
->Tools ->ResX Manager, or:<br />
->Right click on .resx file ->Open in ResX Manager

##### Add new string to String.resx from code
There is a really nice feature of **ResXManager** that allows to add a string used in C# code to .resx file. To make it just right click on the string and choose **Move to Resource**. A new window will appear where you will be able to choose to which .resx file add the string, what key name it will have and what code will be used in C# in place of the string.

### Create your own snippets
Snippets are quite nice feature of Visual Stduio. They allow you to type little command and push `TAB` twice to expand this command into code. Here is an example of XML snippet definition. You can use it to create your own snippets. You have to change the content of **Title** and **Shortcut** markup and of course the most important part the **Code** markup. Such XML file has to be saved with .snippet extension.
```xml
<?xml version="1.0" encoding="utf-8"?>
<CodeSnippets
    xmlns="http://schemas.microsoft.com/VisualStudio/2005/CodeSnippet">
   <CodeSnippet Format="1.0.0">
      <Header>
         <Title>Close WCF client</Title>
         <Shortcut>closewcf</Shortcut>  
      </Header>
      <Snippet>
         <Code Language="CSharp">
            <![CDATA[
               try
               {
                  client.Close();
               }
               catch (CommunicationException e)
               {
                  Client.Abort();
               }
               catch (TimeoutException e)
               {
                  Client.Abort();
               }
               catch (Exception e)
               {
                  Client.Abort();
                  throw;
               }
            ]]>
         </Code>
      </Snippet>
   </CodeSnippet>
</CodeSnippets>
```
To import snippet into Visual Studio go to: ->Tools ->Code Snippets Manager ->Language: CSharp ->Import

### Application settings
To create settings for your application right click on the project in Solution Explorer and go to: ->Properties ->Settings ->Create settings ->Add any setting you need. Settings are stored in **Properties\Settings.settings** file.<br />
To read a setting from C# code use the follwing line of code:
```csharp
Properties.Setting.Default["settingName"];
```
To change setting value use the following code:
```csharp
Properties.Settings.Default["settingName"] = newValue;
Properties.Settings.Default.Save();
```

### ClickOnce Publish
Here is a little description of very basic configuration of ClickOnce publish.<br />
->Right click on Project ->Properties<br />

##### Application 
->Assembly Information ->Assembly version = File version<br />
->Manifest ->Create application without a manifest

##### Signing
->Sign the ClickOnce manifest = false<br />
->Sign the assembly = false<br />

##### Security
->Enable ClickOnce security settings = false

##### Publish
->Publish version (changes automatically!)<br />
->Updates ->Before the application starts<br />
->Updates ->Specify a minimum required version for this application = Publish version<br />
->Prequisites ->Download prequisites from same location as my application<br />
->Options ->Deployment ->Deployment web page = **publish.htm**<br />
->Options ->Deployment ->Auotmatically generate deployment web page after every publish = true

### Problem with dotNetFix while publishing
Donwload dotNetFix from [here](https://www.microsoft.com/en-us/download/details.aspx?id=42642) and put it here `C:\Program Files (x86)\Microsoft Visual Studio 14.0\SDK\Bootstrapper\Packages\DotNetFX452`.

### Web.config for test and production
**Web.config** is a file where a lof of configuration is stored, some database connection string or service connection data. Different setting are required in test environment and different in production. Visual Studio allows to create XML transforms for Web.config and automatically switch between them while publishing the web application.<br />
First go to: ->Build ->Configuration Manager ->Configuration (column) ->Expand the list and select <New...>.<br />
For each build configuration that you will create you can also have a specific Web.config transform. To do this right click on Web.config and choose **Add Config Transform**.<br />
Now you can also create a publish configuration that will use your build configuration and Web.config:<br /> ->Right click on Project ->Publish ->Custom<br />
->Connection ->Publish method: File System (example path `\\106.116.82.90\c$\inetpub\MyAppName`)<br /> 
->Settings ->Configuration ->Choose your configuration

### Bad image exception
Such error can be caused by few things but at first, try to change platform target:<br />
->Right click on the project ->Properties ->Build ->Plarform Target

### Edit HTML and CSS while debbugging is off
->Tools ->Options ->Debugging ->Enable Edit and Continue
