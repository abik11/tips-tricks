## Powershell with Linux
Although it is not effortless, it is possilbe to make Powershell working with Linux. And it is a quite nice combo. Here we are going to focus on how to do something with Linux machine from Powershell remotely rather than how to install Powershell on Linxu - but this is also possible nowadays, especially since Powershell 6 was introduced. Now, you need to open SSH on Linux, here is how to do it:
```bash
service ssh open #open/status/stop
```
And on the Powershell side you may need the passoword to remote Linux machine. It is nice to get the password using **Get-Credential** cmdlet, it is a bit safier than typing it directly in the code:
```powershell
$haslo = (Get-Credential -UserName user_name -Message "Password please!").GetNetworkCredential().Password
```

### Remote command exectution with plink
There is a tool called **plink** that allows to access the Linux shell from Powershell. Here is how to do it, *linux_pc* is the name of Linux machine:
```powershell
.\plink.exe linux_pc  
.\plink.exe -l user1 -pw $haslo -batch linux_pc ls -lsa 
```

### Copying files with pscp
Another tool, called **pscp** allows to exchange files between the Linux machine and Windows machine through Powershell. First to list the files and directories you may use the following command:
```powershell
.\pscp.exe -l user1 -pw $haslo -ls linux_pc:Desktop/files
```
**-ls** switch does the job. Now to copy files from the remote machine to the local one, or otherwise, use the followings commands:
```powershell
.\pscp.exe -l user1 -pw $haslo linux_pc:Desktop/file1 copy.txt	#copying FROM remote
.\pscp.exe -l user1 -pw $haslo file.txt linux_pc 		#copying TO remote
```

### Install Posh-SSH from PSGallery
```powershell
Get-Module -ListAvailable posh-ssh 
Find-Module -Name posh-ssh
Install-Module posh-ssh
Update-Module posh-ssh
ipmo posh-ssh
```

### Install Posh-SSH from GitHub
```powershell
Invoke-WebRequest ` #wget
    -uri https://github.com/darkoperator/Posh-SSH/archive/v1.7.2.zip `
    -outfile posh-ssh.zip
expand-archive -path .\posh-ssh.zip -destinationpath .
ipmo .\Posh-SSH-1.7.2\posh-ssh.psm1
```

### Execute remote commands in session
```powershelll
Get-Credential -username root -message "Password:"
$session = New-SSHSession -ComputerName linux_pc -Credential $crd -AcceptKey
Get-SSHSession
(Invoke-SSHCommand -Command "ls" $session).Output
```

### Copy files and directories
```powershell
Get-SCPFile -ComputerName pc -Credential $crd -RemoteFile file1 -LocalFile test1
Set-SCPFile -ComputerName pc -Credential $crd -LocalFile test1 -RemoteFile file1
```
Those commands have very simple scheme:
```
Get/Set-SCPFile 	-RemoteFile 	-LocalFile 
Get/Set-SCPFolder	-RemoteFolder	-LocalFolder 
```
And it is good to know that Posh-SSH uses the path from `[Environment]::CurrentDirectory` in its operations.
