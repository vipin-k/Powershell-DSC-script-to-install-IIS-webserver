Configuration demodeployment
{
Import-DscResource -Module xPSDesiredStateConfiguration
Import-DscResource -Module xWebAdministration

Node localhost {

WindowsFeature IIS
{
    Ensure = 'Present'
    Name = 'Web-Server'
}
WindowsFeature IISConsole
{
    Ensure = 'Present'
    Name = 'Web-Mgmt-Console'
    DependsOn = '[WindowsFeature]IIS'
}
WindowsFeature IISScriptingTools
{
    Ensure = 'Present'
    Name = 'Web-Scripting-Tools'
    DependsOn = '[WindowsFeature]IIS'
}
WindowsFeature AspNet
{
    Ensure = 'Present'
    Name = 'Web-Asp-Net45'
    DependsOn = @('[WindowsFeature]IIS')
}

xWebsite DefaultSite
{
Ensure = 'Present'
Name = 'Default Web Site'
State = 'Stopped'
PhysicalPath = 'C:\inetpub\wwwroot'
DependsOn = @('[WindowsFeature]IIS','[WindowsFeature]AspNet')
}
File demofolder
{
Ensure = 'Present'
Type = 'Directory'
DestinationPath = "C:\inetpub\wwwroot\demo"
}
File Indexfile
{
Ensure = 'Present'
Type = 'file'
DestinationPath = "C:\inetpub\wwwroot\demo\index.html"
Contents = "<html>
<header><title>This is Demo Website</title></header>
<body>
Welcome to DevopsGuru Channel
</body>
</html>"
}
xWebAppPool DemoWebAppPool
{
Ensure = "Present"
State = "Started"
Name = "demo"
}
xWebsite DemoWebSite
{
Ensure = 'Present'
State = 'Started'
Name = "Demo"
PhysicalPath = "C:\inetpub\wwwroot\demo"
}

xWebApplication demoWebApplication
{
Name = "demo"
Website = "demo"
WebAppPool = "demo"
PhysicalPath = "C:\inetpub\wwwroot\demo"
Ensure = 'Present'
DependsOn = @('[xWebSite]DemoWebSite')
}
}
}
