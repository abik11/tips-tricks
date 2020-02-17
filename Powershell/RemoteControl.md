## Remote control
Powershell has really nice remote capabilities which allows you to do your job from one machine, remotely executing scripts and commands on other machines.

### Ping
Of course you can execute the plain old `ping` command, but Powershell brings us the new, object-oriented cmdlet Test-Connection, here is some little example, just returning **$true** if it could ping the given host:
```powershell
(Test-Connection 192.168.64.132 -quiet) -eq $True
```

### User credentials
There is a very useful cmdlet **Get-Credential** that prompts user for the credentials and ther returns them. It is useful because many different Powershell cmdlets will ask for credentials as one of the arguments. The following examples shows how to get the username and password as readable string from the **PSCredential** object:
```powershell
$crd = Get-Credential
$user = $crd.UserName
$pass = [Runtime.InteropServices.Marshal]::PtrToStringAuto `
		([Runtime.InteropServices.Marshal]::SecureStringToBSTR($crd.Password))
```

### Secure string
```powershell
ConvertTo-SecureString -String "runforrestrun"
ConvertFrom-SecureString -SecureString $secureStr
```

### Remote PowerShell session
```powershell
$cred = get-credential
Enter-PSSession -ComputerName '172.21.0.4' -Credential $cred 
Enter-PSSession -VMName "WinServer" #hyperV
Exit-PSSession
```

### Remote script and command execution
```powershell
Invoke-Command -ComputerName pc -FilePath C:\skrypty\skrypt.ps1
Invoke-Command -ComputerName pc -scriptblock { ... } 
Invoke-Command $session -scriptblock { ... } 
```

### Session with many machines
```powershell
$session = New-PSSession -ComputerName pc1, pc2, pc3
Invoke-command -session $session -scriptblock { ... }
Get-PSSession #session list
Enter-PSSession $session
Exit-PSSession
Remove-PSSession $session
```

### Use local variables in remote session
Very often it is useful to use some local variables inside of the command block you want to execute remotely. To do that you have to use **-argumentList** and put all the variables that you want to use. In remote code block you can specify with **param** expression the required variables just like in the functions. But it is not necessary, you can also access the variables by **$args** table.  
```powershell
$userName = "R2D2"
$password = "I<3C3PO
Invoke-command -session $s -argumentList $userName, $password
   -Command {
       param($userName, $password)
       $user = dsquery user -name $userName
       dsmod user $user -pwd $password -mustchpwd no -disabled no
   }
```

### Turn on remote command execution
As a security issue, remote control may be turned off. To turn it on, run this set of commands:
```powershell
Enable-PSRemoting –Force
Set-Item wsman:\localhost\client\trustedhosts * #add machine to trusted
Restart-Service WinRM
```
To turn it off again use those:
```powershell
Stop-Service WinRm
Disable-PSRemoting
```

### Access to shared drive in remote desktop
If you are connected to some machine through Remote Desktop and you want to access shared drive from Powershell, here is how to do that (you must add **\\\tsclient\\** to your path:
```powershell
ls \\tsclient\D\projects
```
