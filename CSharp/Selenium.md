## Selenium

### This version of ChromeDriver only supports Chrome version XX
When you encounter the following error: `System.InvalidOperationException : session not created: This version of ChromeDriver only supports Chrome version XX` while trying to run Selenium tests you have to update ChromeDriver used by Selenium.<br />
To check Chrome version you can go to: `chrome://version` and to get latest ChromeDriver go [here](https://chromedriver.chromium.org/downloads). You will have to clean and rebuild the project with Selenium tests after upgrading ChromeDriver<br />
Also this command might be useful:
```powershell
ps *chromedriver* | Stop-Process
```
