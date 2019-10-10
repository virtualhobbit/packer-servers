$ErrorActionPreference = "Stop"

$webserver = "intranet.mdb-lab.com"
$url = "http://" + $webserver
$osot = "VMwareOSOptimizationTool.exe"
$osotConfig = "VMwareOSOptimizationTool.exe.comfig"
$template = "VMware Templates\Windows 10"

# Verify connectivity
Test-Connection $webserver -Count 1

# Get Files
ForEach ($file in $osot,$osotConfig) {
   Invoke-WebRequest -Uri ($url + "/" + $file) -OutFile C:\$file
}

# Run OSOT
$osot -o -t $template

# Delete files
#ForEach ($file in $osot,$osotConfig) {
#   Remove-Item C:\$cert -Confirm:$false
#}