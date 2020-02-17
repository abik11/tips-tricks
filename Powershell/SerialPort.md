## Serial port
It may not be the most common solution to handle serial port through Powershell, but that doesn't mean it cannot be done. And here are some tips how to make it. First, let's look get currently available port names: 
```powershell
[System.IO.Ports.SerialPort]::GetPortNames() 
```
It will for example return `COM4`. That means, that we can use this serial port further. Here is an example configuration of how to open a given port. The configuration may be different, depending on what is connected to the port: 
```powershell
$port = new-object System.IO.Ports.SerialPort
$port.PortName = 'COM1'
$port.BaudRate = 9600
$port.DataBits = 8
$port.Parity = 0
$port.StopBits = 1
$port.Handshake = 0
$port.ReadTimeout = 2000
$port.DiscardNull = $True
$port.Open()
```
Let's assume that a barcode scanner is connected to the `COM1` and we scanned a text `MAP0`. We can read each byte separately (we could also use **ReadByte** instead of **ReadChar** here):
```powershell
$port.ReadChar() #2 STX (start of text)
$port.ReadChar() #77 M
$port.ReadChar() #65 A
$port.ReadChar() #80 P
$port.ReadChar() #48 0
$port.ReadChar() #3 ETX (end of text)
```
Or we can read the whole buffer at once:
```powershell
$port.ReadExisting() # ☻MAP0♥
```
When the job is done it is good to clear the read buffer, close the stream and dispose the **SerialPort** object. If serial port will become blocked we can make the same operation - close it and open again:
```powershell
$port.DiscardInBuffer()		# Clear read buffer

$port.BaseStream.Close()	# When serial port gets blocked
$port.Dispose()			# When serial port gets blocked
```
If you are familiar with C# and you are interested in serious operations with serial ports you may need to handle an event - **DataRecieved**.
```csharp
serialPort.DataReceived += methodDelegate;	//methodDelegate - SerialDataReceivedEventHandler
```
For more detailed information go [here](https://msdn.microsoft.com/pl-pl/library/system.io.ports.serialport(v=vs.110).aspx) or [here](http://www.sparxeng.com/blog/software/must-use-net-system-io-ports-serialport)
