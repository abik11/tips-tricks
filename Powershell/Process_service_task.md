## Processes, services and tasks
This is a very important feature of any scripting language to be able to spawn, kill and generally manage processes or services. Powershell does it perfectly well.

### Search process
You can list all processes with **ps** cmdlet and than filter them with **where-object** (?):
```powershell
ps | ? { $_.name -eq "vncviewer" -and $_.MainWindowTitle -match `
"corp11x431" } | select MainWindowTitle, StartTime, ProcessName, Id | ft -auto
```
`ft -auto` will format the result table to make it fit the console screen.

### Stop process
Killing processes is very easy!
```powershell
kill 1531
ps | where { $_.name -eq "MicrosoftEdge"  } | kill
```

### Get process path
It may be useful to retrive path of some process:
```powershell
ps | select Name, Path
```

### Start process
To start a new process you can use .Net framework:
```powershell
[System.Diagnostics.Process]::Start("osk")		#screen keyboard
[System.Diagnostics.Process]::Start("TabTip")	#writing tool :)
```

### List of running services
To get the list of running services, or stopped, or all, we can use Powershell cmdlet or WMI, here you can see both methods:
```powershell
Get-Service | ? { $_.Status -eq 'Running' }
Get-WmiObject win32_service | ? { $_.State -eq 'Running' } | ft -a
```

### Create service
You can also manage services with Powershell, here is an example of how to create one:
```powershell
new-service -name TestService -displayName "Test Service" `
   -description "Usługa testowa" -dependson NetLogon -startupType Manual `
   -binaryPathName "C:\WINDOWS\System32\svchost.exe -k netsvcs" `
sc.exe delete TestService #usuwanie usługi
```

### Create a job
Although creating processes and services is very useful, sometimes you would like to start some little task simply in the background without creating new process or service. This can be achieved in Powershell with **jobs**. See here how to start a new job:
```powershell
Start-Job -ScriptBlock {
    Add-Type -AssemblyName System.Windows.Forms
    while($true){
        $dt = [System.DateTime]::Now
	if($dt.Minute -eq 10 -and $dt.Second -eq 0){
	    [Windows.Forms.MessageBox]::Show('Move your ass!')
	}
    }
}
```
The above job will display message box 10 minutes after every hour.<br />
To see the list of jobs you can use the `Get-Job` cmdlet. Jobs can be stopped with `Stop-Job`, suspended and resumed with `Suspend-Job` and `Resume-Job`. If a job returns some value, you can get this value with `Receive-Job` and you can also wait for some job to finish with `Wait-Job`.<br />
You can also create scheduled jobs with `Register-ScheduledJob` and `New-JobTrigger`.
