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
* **Polyglot Notebooks** - allows to create jupyter-like notebooks for C#, F#, Javascript and Powershell, use `#!share -from csharp someVariable` to export variables to cells in other languages

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

### Run powershell in Terminal Window with -NoProfile argument
Push `CTRL + SHIFT + P`  to open **Command Palette**, type `settings.json` and add the following line in settings file:
```
"terminal.integrated.shellArgs.windows": ["-noprofile"]
```

### Wrap open tabsl
Go to ->File ->Preferences ->Settings ->Search for: `wrapTabs` 

### unins000.exe error
While working with **VS Code** you may encounter annoying errors like this:
```
C:\Program Files\VS Code\Microsoft VS Code\unins000.exe
An error occured while trying to create a file in the destination directory:
Access is denied.
(...)
```
It may happen if you have installed *User Setup* of VS Code in `C:\Program Files` instead of `%appdata%`. On the **Programs and Features** list in **Control Panel**, if you will notice `(User Setup)` toegether with VC Code, then you should rather install *System Setup* - [System Installer](https://code.visualstudio.com/#alt-downloads) - or install *User Setup* in `%appdata%` (as it suggests by default). 
