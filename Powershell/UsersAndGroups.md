## Users and groups
One of the most common tasks that can be scripted are connected with users and groups managment. Powershell is a great tool for this, here you will see some commands and cmdlets that might be useful.

### Manage user groups
To list all the groups in domain you can use the following command:
```powershell
net group /domain
```
And if you are interested in some particular group and want to list all the users you can just put its name as an argument:
```powershell
net group "_Comapny Department" /domain 
```
**net** command is quite powerfull and also allows you to display all users, add or delete groups, check server time and so on.
```powershell
net user /domain
net user john.smith /domain
net time /domain
```
Here you can see how to add some user to **administrators** local group:
```powershell
net localgroup administrators john.smith /add
```
And how to add and delete a user from domain group:
```powershell
net group "_Company Department" john.smith /domain /add
net group "_Company Department" john.smith /domain /delete
```

### What groups user *driectly* belogns to?
To get the answer for the above question we can just simply execute the following command:
```powershell
net user user.name /domain
```
It is really cool but it has some disadvantage (or advantage depending on your sense of taste :D) because the result is pure text. It is possible to get the same information but as objects which is more *powershell way* of doing things. It is a bit more complicated since it requires us to use .Net classes, but is worth it! 
```powershell
# adding required assemblies
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
Add-Type -AssemblyName System.DirectoryServices

# preparing enum values that we will use later
$vdomain = [System.DirectoryServices.AccountManagement.ContextType]::Domain
$vsam = [System.DirectoryServices.AccountManagement.IdentityType]::SamAccountName

# getting the job done ;)
$context = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext $vdomain, "DomainName"
$userPrincipal = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($context, $vsam, "j.smith")
$userPrincipal.GetGroups() | select SamAccountName, name
```
This way we get all the current user groups in an object way. Moreover we have an access to a lot of other information about the current user from Active Directory, this is a really nice bunch of classes to play with!

### Get user extended properties
There is a very easy way to get extended properties with **Get-ADUser** cmdlet, here is an example:
```powershell
Get-ADUser j.smith -Properties EmployeeNumber
```
Here *EmployeeNumber* is an extended property and to get it, you just have to put in the **Properties** list. But there is also a bit more difficult (less powershellish :)) way that you can see here:
```powershell
# adding required assemblies
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
Add-Type -AssemblyName System.DirectoryServices

# preparing enum values that we will use later
$vdomain = [System.DirectoryServices.AccountManagement.ContextType]::Domain
$vsam = [System.DirectoryServices.AccountManagement.IdentityType]::SamAccountName

# getting the job done
$context = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext $vdomain, "DomainName"
$userPrincipal = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($context, $vsam, "j.smith")
$entry = [System.DirectoryServices.DirectoryEntry]$userPrincipal.GetUnderlyingObject()
$entry.employeeNumber #here you can access the extended property

# getting the job even more difficult way - but this may be useful while translating to C#
$searcher = New-Object -type System.DirectoryServices.DirectorySearcher $entry
$searcher.PropertiesToLoad.Add("employeeNumber")
$results = $searcher.FindAll()
[string]$employeeNumber = $results.Properties["employeeNumber"] #here you can access the extended property
```
With **Get-ADUser** you can get extended properties for all users at once:
```powershell
Get-ADUser -Filter * -Properties EmployeeNumber
```

### Set user properties
With a **Set-ADUser** cmdlet you can set user's properties as easily as getting them, see here:
```powershell
Set-ADUser -Identity j.smith 
	-Remove @{SecondaryMail="smith.j@evilcorp.com"} -Add @{EmployeeNo="4214"} -Replace @{Title="manager"} -Clear description
```
Those ActiveDirectory commands are really cool, aren't they?

### Get current user name and domain name
There are several ways to get current user name and domain, see here: 
```powershell
#1 - domain and name in two separate strings
[System.Environment]::UserName
[System.Environment]::UserDomainName

#2 - domain and name in one string
$winPrincipal = [Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())
$winPrincipal.Identity.Name
```

### Check if current user is Administrator
```powershell
function Test-Admin {
   $winPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
   $isAdmin = $winPrincipal.IsInRole("Administrator")
   return $isAdmin
}
```
It is possible to start a process as Administrator from Powershell, for example running `iisreset.exe` requires admin rights:
```powershell
if(Test-Admin){
   iisreset.exe
}
else {
   $script = { iisreset.exe; exit }
   Start-Process powershell -Verb runas -ArgumentList "-NoProfile -Command $script"
}
```
The most important thing here is the parameter **-Verb** with **RunAs** value.

### Currently logged in users
```powershell
query user /server:$computer_ip
```

### Network name and address
```powershell
$env:USERDOMAIN
[System.Net.Dns]::GetHostName()
[System.Net.Dns]::GetHostEntry([System.Net.Dns]::GetHostName())
```

### Full name of currentlu logged user - one liner
```powershell
([ADSI]"WinNT://$env:userdomain/$env:username,user").FullName
```
