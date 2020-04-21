$ErrorActionPreference = "Stop"

$webserver = "intranet.mdb-lab.com"
$url = "http://" + $webserver
$installer = "VMware Dynamic Environment Manager 9.11 x64.msi"
$licence = "dem.lic"
$listConfig = "/i ""C:\$installer"" /qn /norestart ADDLOCAL=FlexEngine LICENSEFILE=dem.lic"

# Verify connectivity
Test-Connection $webserver -Count 1

# Get Files
ForEach ($file in $installer,$licence) {
   Invoke-WebRequest -Uri ($url + "/" + $file) -OutFile C:\$file
}

# Unblock installer
Unblock-File C:\$installer -Confirm:$false

# Install DEM Agent
Try 
{
   Start-Process msiexec.exe -ArgumentList $listConfig -PassThru -Wait
}
Catch
{
   Write-Error "Failed to install the DEM Agent"
   Write-Error $_.Exception
   Exit -1 
}

# Cleanup on aisle 4...
ForEach ($file in $installer,$licence) {
   Remove-Item C:\$file -Confirm:$false
}
