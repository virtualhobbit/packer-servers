$ErrorActionPreference = "Stop"

$webserver = "intranet.mdb-lab.com"
$url = "http://" + $webserver
$osot = "VMwareOSOptimizationTool.exe"
$osotConfig = "VMwareOSOptimizationTool.exe.config"
$template = "Windows10.xml"

# Verify connectivity
Test-Connection $webserver -Count 1

# Get Files
ForEach ($file in $osot,$osotConfig,$template) {
   Invoke-WebRequest -Uri ($url + "/" + $file) -OutFile C:\$file
}

# Run OSOT
C:\VMwareOSOptimizationTool.exe -o -t C:\$template

# Cleanup on aisle 4...
ForEach ($file in $osot,$osotConfig,$template) {
   Remove-Item C:\$file -Confirm:$false
}