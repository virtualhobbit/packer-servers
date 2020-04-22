$ErrorActionPreference = "Stop"

# Variables
$uri = "http://intranet.mdb-lab.com"
$files = @("Bginfo.exe","mdb.bgi")

# Create folder
$targetFolder = "C:\Program Files\Bginfo"
New-Item $targetFolder -Itemtype Directory

# Get files
foreach ($myFile in $files){
    Invoke-WebRequest -Uri $uri/$myFile -OutFile $targetFolder\$myFile
}

# Create shortcut
$targetFile          = "$targetFolder\BGinfo.exe"
$shortcutFile        = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Bginfo.lnk"
$scriptShell         = New-Object -ComObject WScript.Shell -Verbose
$shortcut            = $scriptShell.CreateShortcut($shortcutFile)
$shortcut.TargetPath = $targetFile
$arg1                = """$targetFolder\mdb.bgi"""
$arg2                = "/timer:0 /accepteula"
$shortcut.Arguments  = $arg1 + " " + $arg2
$shortcut.Save()
