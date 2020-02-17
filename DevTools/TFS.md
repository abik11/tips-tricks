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
