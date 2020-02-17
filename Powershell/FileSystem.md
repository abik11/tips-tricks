## Files and directories
Powershell is perfect tool to work with files and directories. It can be used to easily optimize some repetitve tasks working with files and directories. Give it a try!

### Current script and module directory
It is often very useful to get the current script directory, here is how to do it: 
```powershell
$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
Set-Location $scriptPath
```
Also when you will define your own modules, you can get its path like this:
```powershell
$ModuleDir = Split-Path $PSCmdlet.MyInvocation.MyCommand.Module.Path -Parent
```

### Check if the path exists
```powershell
Test-Path "C:\Temp"
pwd | Test-Path #always returns true :)
```

### Read and filter text from file
Here we read file content with **Get-Content** (gc) cmdlet, split it by new line and then, if it doesn't start from *#* and is not null or empty it is split by comma. Finally, every piece of text recieved is then trimmed, all spaces are removed. It is just a simple nice example, how easy it is in Powershell to get the text, filter it and do some simple transformations, this the real power!
```powershell
((gc .\sample.txt) -split "`n" `
   | ? { !$_.StartsWith("#") -and ![String]::IsNullOrEmpty($_) }) -split "," `
   | % { $_.Trim(" ") }
```

### Save to file
You can use **Out-File** to save some stuff to the file. It has a nice switch **-append**, it allows you to not to replace existing file, but add your new content to the file. Nice feature!
```powershell
$dir = pwd
"test content" | out-file "$dir\new1.txt" -append
```

### Delete files and directories
```powershell
rm "C:\new1.txt" 
remove-item C:\Temp -recurse
```

### Creating directories and files
There is an alias **mkdir** that you can use to create directoties, but there is also the **New-Item** cmdlet, much more generic solution. It has **-type** switch so you can define what kind of resource you want to create. 
```powershell
mkdir "folder"
new-item "new1.txt" -type file
```

### Copying and moving files
```powershell
dir file.txt | copy -dest "C:\Temp\"
dir file.txt | move -dest "C:\Temp\"
```

### Change name of multiple files
```powershell
$int = 1
(ls) | % { rename-item $_.FullName -NewName `
  (([string]$_.name).Substring(6).Replace(".mp3", "") + "_$int.mp3"); $int += 1 }
```

### File name, extension and directory 
One of the nicest thing about Powershell that is a huge part of its power is that you can without any limits use all the .Net Framework classes. Here is a nice example how to get the name of a file, its extension and its directory with .Net methods:
```powershell
[System.IO.Path]::GetFileNameWithoutExtension("D:\Files\note.txt") #note
[System.IO.Path]::GetExtension("D:\Files\note.txt") #.txt
[System.IO.Path]::GetDirectoryName("D:\Files\note.txt") #D:\Files
```

### Hide a file
With **attrib** command it is possible to add or remove file attributes like read-only (**R**), archive (**A**), system (**S**) or hidden (**H**) file attributes. You have to use plus or minus signs to respectively add or remove some attribute. Here you can see an example of how to add hidden file attribute:
```powershell
attrib +H names.txt
```
To be able to list this file you have to use **-Hidden** switch. 
```powershell
ls -hidden
```

### Join-Path
```powershell
join-path -path "D:\Test" -childpath "file.txt" 
```

### Head and tail
```powershell
gc file.txt -totalCount 3	#first 3 rows of the file
gc file.txt -tail 2		#last 2 rows of the file
```

### Advanced file searching
The following command will find in *D:\project* all the .cshtml files that do not contain the word *Partial* in their names:
```powershell
get-childitem d:\project -recurse -include *.cshtml -exclude *Partial*  
```
**Get-ChildItem** has many aliases worth remembering: ls, dir, gci. This **-recurse** switch toegether with **-include** and **-exclude** parameters are mind blowing!!! Searching files with this tool is unbelievable! UN-BE-LIE-VA-BLE! :D

### Clear recycle bin
Everything can be done with Powershell, literally everything... :]
```powershell
Clear-RecycleBin -Force
```

### Export results to Excel/CSV
```powershell
get-service | select name, status `
	| export-csv c:\temp\uslugi.csv -delimeter ";" -noTypeInformation
```

### Import CSV
Here is an example CSV file to be imported:
```csv
Rui;24;Portugal
Albert;26;Poland
```
And here is how to do it:
```powershell
$csv = import-csv 'file.csv' -delimeter ; -header 'name','age','nationality'
```

### Zip and unzip
```powershell
Add-Type -Path `
"C:\Windows\Microsoft.NET\assembly\GAC_MSIL\System.IO.Compression.FileSystem\v4.0_4.0.0.0__b77a5c561934e089\System.IO.Compression.FileSystem.dll"
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipFile.FullName, "D:\data")
[System.IO.Compression.ZipFile]::CreateFromDirectory("D:\data", "D:\data.zip")
```

### Run a link to exe file
```powershell
& '.\UltraVNC Viewer.lnk'
```

### Create a symbolic link to a file
Before Powershell 5.0 the easiest way to create a symbolic link was to run **mklink** command through **cmd**. Here is an example of how to create a symbolic link to a file:
```powershell
cmd /c mklink symbolicLink.exe d:\programs\firefox.exe
```
and here how to create a symbolic link to a directory:
```powershell
cmd /c mklink symbolicLinkToPrograms d:\programs /d
```
Since Powershell 5.0 you can create a symbolic link using **New-Item** command for both a file or a directory:
```powershell
New-Item -Path symbolicLinkToPrograms -ItemType SymbolicLink -Calue d:\programs
```

### Count file checksum
It is a nice example of how something can be done in Powershell way using cmdlet and .Net or C# way using .Net Framework classes. Firstly, lets see how easy it is with **Get-FileHash** cmdlet:
```powershell
Get-FileHash .\myapplication.exe
```
C# way is a bit more complex (but not complicated), still it is nice to see an example to keep in mind that Powershell can use .Net classes with *extreme* ease:
```powershell
[System.IO.FileStream] $fileStream = [System.IO.File]::OpenRead("myapplication.exe")
$sha = New-Object -TypeName System.Security.Cryptography.SHA256Managed
$checksum = $sha.ComputeHash($fileStream)
[System.BitConverter]::ToString($checksum) -creplace "-", ""
```
The result of running both codes should be the same if you will run it against the same file of course. Also be careful because the current path in Powershell is not the same as the current path in .Net. To see the current path in .Net you can use one of the two following lines:
```powershell
[Environment]::CurrentDirectory
[System.IO.Directory]::GetCurrentDirectory()
```
And to change the current directory in .Net use this:
```powershell
[System.IO.Directory]::SetCurrentDirectory("D:\data\scripts")
```

### Watch for new files
With a mix of **FileSystemWatcher** object and **Register-ObjectEvent** cmdlet it is really easy to watch a directory for newly created files (also modifed or deleted or actually anything else that can emit an event).<br />
A nice thing to remember is how to pass data to event action. You can make it through **-MessageData** argument and access it inside of the action through **$event** variable.
```powershell
$watcher = New-Object System.IO.FileSystemWatcher 'D:\files', '*.txt' -Property `
	@{ IncludeSubdirectories = $false; NotifyFilter = [System.IO.NotifyFilters]'FileName, LastWrite' }
	
$data = New-Object PSObject -Property @{ LogFilePath = 'D:\logs\watcher_log.txt' }

Register-ObjectEvent $watcher Created -SourceIdentifier FileCreated `
-MessageData $data `
-Action {
	$fileName = $event.SourceEventArgs.Name
	$eventTime = $event.TimeGenerated
	$msg = "[$eventTime]: Importing new file: $fileName"
	Write-Host $msg -ForegroundColor Green
      	Out-File -FilePath $event.MessageData.LogFilePath -Append -InputObject $msg
}
```
