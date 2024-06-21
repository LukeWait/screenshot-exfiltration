command = "Powershell.exe -nologo -command C:\<PATH-TO>\screenshot.ps1"
set shell = CreateObject("WScript.Shell")
shell.Run command,0
