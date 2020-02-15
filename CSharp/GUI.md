## WinForms and WPF

## Table of contents
* [WinForms](#winforms)
* [WPF](#wpf)

## WinForms
WinForms is a .Net wrapper for WinApi, it allows you to build GUI for Windows applications through a really big group of classes, methods and properties. It is easy to use, lately quite criticized for not being well suitable for bigger projects - it is hard to separate logic from the code that handles th GUI. WPF is another .Net way of doing desktop apps.

### How to access the form state from other thread
```csharp
delegate void ScannerDelegate(string receivedData);

void DataReceiveAction(string data)
{ 
   label.Text = data.ToString(); 
}

this.BeginInvoke(new ScannerDelegate(DataReceiveAction), new object[] { data });
```
This can be also done slighlty different way with the TPL library.

### Paint event
Sometimes default controls may not be enough or you will need to modify them somehow. You can use **Paint** event to add some images or generally affect the way a control is displayed, here is an example of adding an image to ribbon control:
```csharp
private void ribbon_Paint(object sender, PaintEventArgs e)
{
   //Using image from resources
   Image bgImage = Properties.Resources.logo_img;

   Rectangle rect = ribbon.ClientRectangle;
   rect.Width = 304;
   rect.Height = 96;
   
   //Setting the image's position depending on the ribbon's size
   rect.X = ribbon.ClientRectangle.Width - rect.Width - 10;
   rect.Y = ribbon.ClientRectangle.Height - rect.Height;
   e.Graphics.DrawImage(bgImage, rect);
}
```

### Playing WAV sounds
```csharp
using System.Media;

SoundPlayer player = new SoundPlayer(Properties.Resources.Sound_wav);
player.Play();
```

### App window maximized at start
Set your main form's property **WindowState** to **Maximized**.

### Filter for image files for OpenFileDialog
```csharp
string filtr = "Image files (*.bmp, *.jpg, *.png) | *.bmp; *.jpg; *.png| 
   BMP files (*.bmp)|*.bmp|JPG files (*.jpg)|*.jpg| PNG files (*.png)|*.png";
```

### Bind a property to a setting
->Go to control's properties ->(ApplicationSettings) ->(PropertyBinding)

### Error while starting an app - Checking application correctness failed
->Right click on Project ->Properties ->Application ->Manifest: Create application without a manifest

### Domain group authorization
```csharp
PrincipalContext ctx = new PrincipalContext(ContextType.Domain, Environment.UserDomainName);
UserPrincipal user = UserPrincipal.FindByIdentity(ctx, Environment.UserName);
GroupPrincipal group = GroupPrincipal.FindByIdentity(ctx, "_Group1");

if(!user.IsMemberOf(group))
    Close();
```

### DevExpress WinForms Controls
You can speed up your development with DevExpress controls. Read more [here](https://github.com/abik11/tips-tricks/blob/master/DevExpress).

## WPF
Windows Presentation Framework is just as its name says a framework, designed to develop Windows application. It is different from WinForms because it doesn't use WinApi controls, it paints all the forms so the control that we have over the presentation layer of our application is much bigger. Another difference is that WPF forms usually (almost always) are wirtten with a language called XAML which is an extension of XML, a bit similar to HTML - you can build a form using tags. Also in WPF it is recommended to use MVVM (Model-View-ViewModel) design pattern to separate presentation layer (GUI) from logic.

### Building a layout
Here is a simple example of a layout built with Grid and StackPanel: 
```xaml
<Window x:Class="App.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WtfApp1"
        mc:Ignorable="d"
        Title="MainWindow" Height="350" Width="525">
   <Grid>
      <Grid.ColumnDefinitions>
         <ColumnDefinition />
      </Grid.ColumnDefinitions>
      <Grid.RowDefinitions>
         <RowDefinition />
         <RowDefinition />
      </Grid.RowDefinitions>
      
      <Button Grid.Column="0" Grid.Row="0" Width="100" Height="50" Name="btnTest">
         Button Text
      </Button>
      
      <StackPanel Grid.Column="0" Grid.Row="1" Orientation="Vertical">
         <Button Margin="10"  Width="200" Height="50" Name="btnStackPanel">
            Stack Panel 1
         </Button>
         <TextBox Margin="10" Width="200" Height="50" 
                          TextAlignment="Center" Name="tbStackPanel">
            Text Box 1
         </TextBox>
      </StackPanel>
   </Grid>
</Window>
```
It is good to note that you define grid columns and rows with separate tags (**ColumnDefinition**, **RowDefinition**) and then inside of the grid you can position elements using **Grid.Column** and **Grid.Row** properties. You can also use **Grid.RowSpan** and **Grid.ColumnSpan**.

### DataGrid
Just a very little example of a DataGrid with data binding
```xaml
<DataGrid Name="dgPeople" AutoGenerateColumns="False" ItemsSource="{Binding People}">
     <DataGrid.Columns>

          <DataGridTextColumn Header="Last Name" 
               Binding="{Binding LastName}"></DataGridTextColumn>

          <DataGridTextColumn Header="{x:Static str:Strings.DayOfBirth}" 
                Binding="{Binding Birthday, StringFormat=\{0:dd.MM.yyyy\}}">
                </DataGridTextColumn>

     </DataGrid.Columns>
</DataGrid>
```

### A button with an image
```xaml
<Button Name="btCancel" Width="100" Margin="10" IsEnabled="False"
  Command="{Binding CancelCommand}" Click="btCancel_Click">
        <StackPanel Orientation="Horizontal">
                <Image Source="/MyProject.Resources;Component/Images/cancel.png" 
                  Stretch="None"></Image>
                <TextBlock Text="{x:Static str:Strings.Cancel}"></TextBlock>
        </StackPanel>
</Button>
```
The image you want to use must have the **Build Action** property set to **Resource**.

### Turn off last child fill in DockPanel
The last element of a DockPanel always fills all the place that is not filled with other elements. Sometimes (or actually quite often) you may not want it to work like this. It can be easily turn off with **LastChildFill** property of DockPanel: 
```xaml
<DockPanel LastChildFill="False"></DockPanel>
```

### Adding a splitter to a grid
```xaml
<Grid>
    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="*" />
        <ColumnDefinition Width="5" />
        <ColumnDefinition Width="*" />
    <Grid.ColumnDefinitions>
    <StackPanel></StackPanel>
    <GridSplitter Grid.Column="1" HorizontalAlignment="Stretch" />
    <StackPanel Grid.Column="2"></StackPanel>
</Grid>
```

### Binding a command to a non-default event
Firstly you have to add the following namespace: `xmlns:i="http://schemas.microsoft.com/expression/2010/interactivity"`.
```xaml
<i:Interaction.Triggers>
    <i:EventTrigger EventName="MouseDown">
        <i:InvokeCommandAction 
            Command="{Binding  TopPanelMouseDownCommand}"
            CommandParameter="{Binding ElementName=this}" />
    </i:EventTrigger>
</i:Interaction.Triggers>
```

### Binding a command to a key
```xaml
<DataGrid.InputBindings>
     <KeyBinding Key="Delete" Command="{Binding EditCommand}" />
</DataGrid.InputBindings>
```

### Internationalization
To support many languages in WPF application you have to take few steps.
1. Prepare *MyProject.Resource* project that will contain string files for each language that you want to support.
2. Add this project to namespaces in your forms:
```
xmlns:str="clr-namespace:MyProject.Resources;assembly=MyProject.Resources"
```
3. Statically assign string values, like this:
```xaml
<Button Name="btSave" Content="{x:Static str:Strings.Save}"></Button>
```
4. Override **OnStart** method of your **App.xaml.cs** file:
```csharp
protected override void OnStartup(StartupEventArgs e)
{
   base.OnStartup(e);

   Thread.CurrentThread.CurrentCulture = new CultureInfo("en-GB");
   Thread.CurrentThread.CurrentUICulture = new CultureInfo("en-GB");

   FrameworkElement.LanguageProperty.OverrideMetadata
      (typeof(FrameworkElement), 
      new FrameworkPropertyMetadata(XmlLanguage.GetLanguage(CultureInfo.CurrentCulture.IetfLanguageTag)));
}
```
<br />
If you want to change the language, it would be a good idea to save the language string (*en-GB* or other) in app settings, manipulate that setting in the app and restart the app after it has been changed.
