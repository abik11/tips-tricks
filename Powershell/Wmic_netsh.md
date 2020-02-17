## Wmic and netsh
There are two extremely powerfull commands in Windows. Actually there are much more, but here I would like to say a word or two about **wmic** and **netsh**. The first one is WMI (Windows Management Instrumentation) command line tool that allows you to get almost any kind of information about software and hardware and manage the system. The second command is intended to configure and manage networks through command line. Both tools are designed for someting different but you can sometimes achieve the same goal using them. It is also good to know that they both can work in interactive (shell) mode but for scripting it is much better to use them simply as commands putting all the required parameters.

### Netsh
With this command you can easily get a lot of information about networks and interfaces in your system. It allows you to manage and configure network interfaces and much more! For example with the following few commands you can see all the enabled network interfaces, their addresses and configuration. In the last command only the configuration of the selected interface will be shown.
```
netsh interface ipv4 show interface
netsh interface ipv4 show addresses
netsh interface ipv4 show config
netsh interface ipv4 show config 12
```
It is good to know how to get interface index number because it may be used to configure the specified interface. It is easier to use index than name (`name='Local connection'`) because depending on your language, tha name can contain some diacritical marks which may not be interpreted by the command line.<br />
Here you can see how to set static IP address, net mask (`/22`), default gateway and primary and secondary DNS server:
```
netsh interface ipv4 set address 12 static 100.110.80.125 255.255.252.0 100.110.84.1
netsh interface ipv4 set dnsservers 12 static 100.110.86.62
netsh interface ipv4 add dnsserver 12 100.110.86.61 index=2
```
All the settings are applied to the interface of index 12. If you want to get the address and other settings automatically from DHCP you should use the following commands:
```
netsh interface ipv4 set address 12 source=dhcp
netsh interface ipv4 set dnsservers 12 source=dhcp
```
It is also possible to enable and disable (turn on and off) network interface cards (NIC) with **netsh**, this is how you do it:
```
netsh interface show interface
netsh interface set interface name="Local connection" admin=disabled
netsh interface set interface name="Local connection" admin=enabled 
```
A disadvantage of this command is that you have to specify the name of the NIC, you cannot use its index. To overcome it you have to use **wmic**.

### Wlan
**Netsh** can be used for WLAN management. For example you can see all the WLAN interfaces, configured WLAN profiles and connect your PC with the given profile:
```
netsh wlan show interfaces
netsh wlan show profiles
netsh wlan connect name="myWifi"
```
Also a very useful functionality is that you can even get the password of a given WiFi network (among other details):
```
netsh wlan show profiles name='CORP_wifi' key=clear
```

### Much more
There are many other things you can do with **netsh**. If you will type `netsh /?` in cmd, you will see all the possible contexts in which you can use this command. Here is just one more example which shows all the firewall rules. Of course with **netsh** you can add and modify such rules:
```
netsh advfirewall firewall show rule name=all
```

### WMIC
Powershell has it own **Get-WmiObject** cmdlet to handle WMI but **wmic** can do the same thing and can be also run from cmd, not only from Powershell. This command uses heavily aliases for WMI classes, so for example we can use the alias `DESKTOPMONITOR` instead of the class name `Win32_DesktopMonitor`, for example the two following lines do the same thing:
```powershell
wmic desktopmonitor
wmic path win32_desktopMonitor
```
To get the list of available aliases with their descriptions you can execute the following command:
```powershell
wmic /?
```
If you are interested about the details of a specific alias you can use this:
```powershell
wmic alias desktopmonitor
```
You can use **wmic** to query for a specific information with **get** and **where** keywords, see an example:
```powershell
wmic desktopmonitor where availability=3 get name,screenHeight,screenWidth
```
Be careful, there should not be any space between the fields names in **get** clause.

### Enable and disable NICs
Many things that can be done with **netsh** can be also done with **wmic**, for example enabling and disabling network interface cards. Use the following command to list all NICs:
```
wmic nic get name,index,interfaceIndex,netConnectionID
```
Remember, index field is the *physical* numer of network card and interface index is the *logical* number of the network interface (you use this number in `netsh interface ipv4` context). It maybe useful to display the NIC information along with the interface.<br/> 
With **wmic** you can query WMI to find the NIC you want to enable or disable in many ways:
```
wmic path win32_networkadapter where "NetconnectionID like '%wireless%' and not ProductName like '%Virtual%'" get name,index call disable
wmic path win32_networkadapter where index=7 call enable
```

### NIC configuration
It is also easy to get configuration details (the same information as `netsh interface ipv4 show config` shows) with `Win32_NetworkAdapterConfiguration` class. See an example:
```
wmic nicconfig where "interfaceIndex=12" get DHCPEnabled,IPAddress,IPSubnet,DefaultIPGateway,DNSServerSearchOrder
```
Of course it is possible to change the configuration with **wmic**:
```
wmic nicconfig where index=7 call SetDNSServerSearchOrder ('8.8.8.8','8.8.4.4')
wmic nicconfig where index=7 call EnableStatic ('100.110.16.20'),('255.255.255.0')
wmic nicconfig where index=7 call EnableDHCP
```
To know more about the functions you can call for `nicconfig` type this command (it works for other classes too):
```
wmic nicconfig call /?
```
