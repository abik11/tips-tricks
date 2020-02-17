# Tips for beginners

* [Visual Studio](#visual-studio)
* [TFS](#tfs)
* [Git](#git)
* [VS Code](#vs-code)
* [Other](#other)
* [Useful links](#useful-links)

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

### AnkhSVN
**AnkhSVN** is an amazing extension for Visual Studio that integrates SVN support into Visual Studio GUI, it is very intuitive and easy to use. After you install the plugin, you have to set it as the source control for Visual Studio. Go to: ->Tools ->Options ->Source Control ->Plugin Selection ->Current source control plug-in: **AnkhSVN**.<br />
Now if you right click on some file, project or solution you will be able to choose among few options: Update to Latest Version, Revert, Commit, Show Changes and other.<br />
If you will encounter an error about lock, right click the file or folder ->Subversion ->Cleanup ->Commit.

## TFS
**Team Foundation Server** is a version control system developed by Microsoft and integrated with Visual Studio. There are many other version control systems like Git or SVN which can be also easily integrated with Visual Studio through extensions.

### Add new TFS project
->Go to VSTS (web panel) of your collection ->Gear icon (in the top menu) ->Collection Settings ->New team project<br />
->Go to Visual Studio ->Team Explorer ->Source Control Explorer ->Select your new TFS project<br />
->File ->Project ->Choose project type ->Set solution name - the same as TFS project name ->Set location to your TFS folder (for example `D:\tfs\`) ->Right click on solution ->Add to Source Control

### Change project mappings to disk
->Run Visual Studio ->Team Explorer ->Source Control Explorer ->Workspace (on the top bar) ->Workspaces (from expendable list) ->Edit 

### Delete TFS project
->Go to VSTS (web panel) of your collection ->Gear icon (in the top menu) ->Collection Settings ->Three dots icon (next to the project you want to delete) ->Delete ->Type project's name

### Branching
If you need to keep more than one version of code of some project it is good to use branching. This techinque allows you to create an alternative version of your project. For example you can have one branch with stable version of your application, ready for production and another branch being currently developed and not ready for production. This is very common approach and it is easy to implement in TFS.<br />
Before creating branches for your project it is good to put all the solution files and folders into one folder that will be easy to branch. If all your files are at the root level of TFS project it won't be so easy.<br />

##### Create a branch
Before creating a branch you must check-in all pending changes.<br />
->Source Control Explorer ->Right click on folder that you want to branch ->**Branching and Merging** ->Branch ->Target - set your branch name ->Set: **Immediately convert source folder to branch**<br />
A nice thing to know is that you can create a branch from any version of code that you want. You can specify it in **Branch from version** group.

##### Merge
If you will change something in a child branch and want to apply those changes in a parent branch, for example to publish a new funcionality in production, you have to merge those branches:<br />
->Source Control Explorer ->Right click on source branch ->**Branching and Merging** ->Merge ->Select target branch (where the changes will be applied) ->Next ->Finish<br />
If some conflicts will occur, TFS will allow you to resolve them with the Resolve Conflicts tool.

##### Reparent
Sometimes it maybe a good choice to change the relationship between branches, to convert a child into parent and reverse. To do that, first you have to change child's branch parent to **No parent** and then assign this branch as a parent for the second branch (which was a parent before). You will the reparent option here: ->Source Control Explorer ->Right click on a branch ->Branching and Merging ->Reparent. It can be very useful to see branches hierarchy, go to ->Source Control Explorer ->Right click on a branch ->Branching and Merging ->View Hierarchy.

##### TF14098: Access Denied: User ... needs ManageBranch permission(s)
If you see the above error you have to add specific permission to given user or a group. In Visual Studio go to ->Team Explorer ->Source Control Explorer ->Right click at the TFS projects or the whole collection ->Advanced ->Security. In the Permissions window you can click Add button to add a TFS group or Windows user identity and then set **Manage branch** permission to **Allow**. 

### Ignore a file or directory
->Source Control Explorer ->Pending Changes ->**Excluded Changes** ->**Detected** ->Right click on a selected item ->Ignore by folder (or other ignore option).<br />
This will generate a `.tfignore` file where you can put things that you want to be ignored by TFS, it can look like this for example:
```
\packages
\UpdateLog*
\WebApp\logs
\MobileApp\platforms\android\assets\www
\MobileApp\www
\MobileApp\package-lock.json
```
Be careful because it won't have any effect on files that are already added to source control. So if there is a file that you want to ignore but it is added to source control, you have to delete it firstly and check-in/commit changes.

### Authorization error after changing account password
If you will encounter the following error code: `TF30063` that probably means that you cannot be authorized to connect TFS server. It can happen if you changed your current Windows account password. Go to:<br />
*(English)* ->Control Panel ->User accounts ->Credential Manager ->Windows Credentials ->Choose TFS ->Edit ->Put new password<br/>
*(Polish)* ->Panel Sterowania ->Konta użytkowników ->Zarządzaj poświadczeniami ->Poświadczenia systemu Windows ->Wybierz TFS ->Edytuj ->Podaj nowe hasło

### No workspace matching error after changing computer name
TFS stores the information about your workspace which is strictly connected to your computer name. If your computer name will change, you may see an error message after trying to connect to TFS, saying that **workspace XYZ does not reside on this computer**. It will also suggest to use `tf workspaces /updateComputerName:oldComputerName`, but it may not be enough to resolve the issue.<br />
1. The first thing you have to do is to add a new workspace: ->Team Explorer ->Solutions (at the bottom) ->Workspace ->Manage Workspaces ->Add ->Set name of the workspace to be the same as your new computer name (as default).<br />
2. Next you can run the **tf** command:
```powershell
cd C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE
#This directory may be different depending on your installation and VS and TFS version

TF.exe workspaces /updateComputerName:old-comp-name /s:http://corpdev:8080/tfs
#Remember to put the OLD name of your computer, not new one
```
3. Then go to `%userprofile%\AppData\Local\Microsoft\Team Foundation`. You will find there few directories called `7.0`, `6.0` and so on and each one of them has `Cache` directory inside. Delete the content of each `Cache` directory. You can make it with one Powershell command. The `~` sign stands for the user profile directory.
```powershell
ls "~\AppData\Local\Microsoft\Team Foundation" -recurse -filter Cache | ls | rm -recurse -force
```
4. The last step is to go to Visual Studio and **Source Control Explorer** and map your new workspace to your disk. Actually, if you don't want to map your workspace to the old directory, but create a new one, you can omit the third step.<br />

By the way, the **tf** command is capable of a lot more! Go to [useful links](#useful-links) to learn more. 

## Git

### Every day work with git
```
git status
git add full/file/path
git commit -m "MFD-xxx desc"
git pull -r
git push
```

### Branching
Branches are the core of Git. Branching in Git is very cheap, so you can (and even should use) it a lot.

##### Switching to other branch
You can easily list all local branches and create new ones with the following command:
```
git branch
git branch release10
```
To switch to an existing branch (to check out) use the command:
```
git checkout release10
```
You can also check out to given commit (put commit hash instead of branch name), but take care cause it will cause **HEAD detached**.<br />
You can also switch to non-existing branch and automatically create it:
```
git checkout -b release11
```

##### Adding new branch to remote
Push the new branch to remote (if you want to check your remote connection name use: `git remote`)
```
git push -u origin release11
```

##### Deleting branches
To delete a local branch you can just use the following command:
```
git branch -D branch-name
```
And to delete remote branch you can use:
```
git push origin --delete branch-name
```

### HEAD detached from < hash >
If you see such information when you run `git status` command, it means that you are not on a branch, but on some previous old commit - you have checked out a commit (the hash is the hash of commit to which your local repo is checked out). If you have commited your changes and in this state you want to push them, run the following commands:
```
git log -n 1 #copy commit hash
git checkout master
git branch tmp-branch commit-hash
git pull -r
git cherry-pick commit-hash
git push
```
If you don't care about your changes, just checkout the branch:
```
git checkout master
```

### How to revert single file to given commit
With `git checkout` if you will specify commit hash (from which you want to get the file) and the file path, in your working area you will have the file modified to the version from specified commit:
```
git chekout commit-hash path/to/file
```

### Aliases
With aliases you can create some short commands so you can work faster with git. You can add them in global `.gitconfig` file which you can find in `%userprofile%`. Here are little examples, but of course they can be more complex:
```
[alias]
    f =fetch
    s =status
    fs =! git fetch && git status
    p =pull -r
    
    b =branch
    cho =checkout
    
    a =add .
    c =commit
    cm =commit -m
    
    unstage =restore --staged .
    undo =checkout -- .
    untrack =clean -fd
    undoall =! git restore --staged . && git checkout -- . && git clean -fd
    
    chp =cherry-pick
    st =stash
    stp =stash pop
    stl =stash list  
```
Such aliases can be used in the following manner:
```
git s
git p
```
With `!` operator you can run commands from the context of command line (shell), in case of Windows it would be **cmd.exe**, so it allows to combine many git commands into one alias - really useful technic!

### Ignore files
To ignore files which are already added to git repository, you can use `git update-index --skip-worktree file/path`. A nice trick is to add an alias with all the files that you want to ignore so you can easily ignore them anytime needed. You should add the following code in git config file:
```
[alias]
    ignore-cfg =update-index --skip-worktree MyProject/App.Debug.config MyProject/Config.Debug.config 
    unignore-cfg =!git update-index --no-skip-worktree MyProject/App.Debug.config MyProject/Config.Debug.config && git stash save ConfigIgnoredByDefatult
```
You can find local git config (used only for given project) in `.git\config` file or global git config file in `%userprofile%\.gitconfig`.

### Save your changes temporarily - stash
It may happen that you've got some work in progress, changes that are not ready to commit but for some reason you need to get the latest version of the code. But you cannot pull changes from a remote branch if you've got some uncommited changes locally and you don't want your changes to be lost. What to do in such situation? Stash your changes. It is very simple, you just run the following command:
```
git stash
```
It will save your local changes on a stash list as a *temporary* commit and clean your working area so you can pull from a remote branch. You can then list all the stashes (with `git stash list` command) or get the last one, apply it and remove from stash list:
```
git stash pop
```
You can use `git stash apply` to apply the stash without removing from the list.

## VS Code
Visual Studio Code is a lightweight text editor that can be used for free and even replace Visual Studio in smaller projects. It has many extensions so it can be used for many different types of projects and programming languages.

### Keyboard shortcuts from Visual Studio
For those familiar with Visual Studio the thing that can be annoying while using VS Code are shortcuts. They are quite different than those in Visual Studio. Especially `CTRL + W` which in Visual Studio selects the word pointed by the cursor and in VS Code it closes the current document.<br />The only thing that has to be done to use Visual Studio shortcuts inside VS Code is to install an extenstion called **Visual Studio Keymap**.

### Extensions
There are many extensions available for VS Code that can convert in a complex IDE with specialized tools for different programming languages or frameworks.
* **Path Intellisense** - adds autocompletion for file names (extremely useful)
* **Live Server** - it allows you to right click on a HTML file and select **Open with Live Server** to start a little HTTP server that will serve you your HTML file - be careful to be able to use it you must open some folder (CTRL + K, CTRL + O), it doesn't work with single file
* **Vetur** - syntax highlighting for Vue components
* **AutoHotkey** - syntax highlighting for AHK files
* **Better Line Select** - adds a new shortcut `CTRL + L` that selects the current line and puts the cursor under the selected line and `CTRL + SHIFT + L` that also selects the current line and puts the cursor above the selected line (it may not work if you will install Visual Studio Keymap)

### Manually installing extenstions
If you cannot install extensions from VS Code, you can install them manually. Go to [Visual Studio Marketplace](https://marketplace.visualstudio.com/vscode). Find your extensions and in **Resources** menu (on the right) click **Download Extension**.<br />
Now go to VS Code, go to **Extension** menu (the last icon on the left), click options (the icon with tree dots - top right corner) and select **Install from VSIX**.

### HTML snippets
In HTML files you can use some built-in snippets. You have to type the snippet name and then press `TAB` to expand the snippet. See here for a little list:
* `lorem10` - expands 10 first words of the lorem ipsum text
* `lorem100` - expands 100 first words of the lorem ipsum text, you can actually put some other numbers, not only 10 and 100
* `!` - expands a simple blank HTML template

Of course you can also define your own snippets, not only for HTML. There is even an online tool to make it easier, [here](https://snippet-generator.app/).

### Open git repository in VS Code
Push `CTRL + SHIFT + P` to open **Command Palette**, type `Git: Clone` and paste the repository URL and push `Enter`. Quite simple, isn't it?

### unins000.exe error
While working with **VS Code** you may encounter annoying errors like this:
```
C:\Program Files\VS Code\Microsoft VS Code\unins000.exe
An error occured while trying to create a file in the destination directory:
Access is denied.
(...)
```
It may happen if you have installed *User Setup* of VS Code in `C:\Program Files` instead of `%appdata%`. On the **Programs and Features** list in **Control Panel**, if you will notice `(User Setup)` toegether with VC Code, then you should rather install *System Setup* - [System Installer](https://code.visualstudio.com/#alt-downloads) - or install *User Setup* in `%appdata%` (as it suggests by default). 

## Other

### Test code in Postman
Go to *Tests* tab of a request and there you can write a test code that will be executed every time for this request:
```javascript
pm.test("Response time is less than 100ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(100);
});
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});
```
You can also use variables defined in *environment*:
```javascript
let time = parseInt(pm.environment.get("time"))
pm.environment.set("time", time + pm.response.responseTime);
```

## Useful links

#### Visual Studio and TFS
[Visual Studio Marketplace](https://marketplace.visualstudio.com/)<br />
[Programming languages in Visual Studio](https://docs.microsoft.com/pl-pl/visualstudio/#pivot=languages)<br />
[TFS from command line](https://docs.microsoft.com/pl-pl/vsts/repos/tfvc/use-team-foundation-version-control-commands?view=vsts)<br />

#### Git
[Git Book](https://git-scm.com/book/en/v2)<br />
[Visualizing Git](https://git-school.github.io/visualizing-git/)<br />
[Poznaj Gita - Polish](https://poznajgita.pl/)<br />
[Configuración de un repositorio Git en Visual Studio - Español](https://www.kabel.es/configuracion-git-visual-studio/)<br />
[Version Control in VS Code](https://code.visualstudio.com/docs/editor/versioncontrol)<br />
[Git Version Control in VS Code (Video)](https://code.visualstudio.com/docs/introvideos/versioncontrol)<br />
[Why are my commits linked to the wrong user?](https://help.github.com/articles/why-are-my-commits-linked-to-the-wrong-user/)<br />
[How to change your commit messages in Git?](https://gist.github.com/nepsilon/156387acf9e1e72d48fa35c4fabef0b4)<br />

#### Online dev tools
[Regex editor](http://regexr.com/)<br />
[Barcode generator](http://barcode.tec-it.com/en)<br />
[SHA256 calculator](http://www.xorbin.com/tools/sha256-hash-calculator)<br />
[MD5 checksum](http://onlinemd5.com/)<br />
[VS Code Snippet Generator](https://snippet-generator.app/)<br />
[UML editor](https://www.draw.io/)<br />
