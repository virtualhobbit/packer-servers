$ErrorActionPreference = "Stop"

$webserver = "intranet.mdb-lab.com"
$url = "http://" + $webserver
$installer = "VMware Dynamic Environment Manager 9.9 x64.msi"
$licence = "dem.lic"
$listConfig = "/i ""C:\$installer"" /qn /norestart ADDLOCAL=FlexEngine LICENSEFILE=dem.lic"

# Verify connectivity
Test-Connection $webserver -Count 1

# Get DEM Agent
Invoke-WebRequest -Uri ($url + "/" + $installer) -OutFile C:\$installer

# Get DEM licence
Invoke-WebRequest -Uri ($url + "/" + $licence) -OutFile C:\$licence

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
Remove-Item C:\$installer -Confirm:$false
