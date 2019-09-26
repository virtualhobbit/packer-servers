$ErrorActionPreference = "Stop"

$webserver = "intranet.mdb-lab.com"
$url = "http://" + $webserver
$installer = "VMware Dynamic Environment Manager 9.9 x64.msi"
$listConfig = "/i ""C:\$installer"" /qn REBOOT=ReallySuppress ADDLOCAL=FlexEngine"

# Verify connectivity
Test-Connection $webserver -Count 1

# Get UEM Agent
Invoke-WebRequest -Uri ($url + "/" + $installer) -OutFile C:\$installer

# Unblock installer
Unblock-File C:\$installer -Confirm:$false

# Install UEM Agent
Try 
{
   Start-Process msiexec.exe -ArgumentList $listConfig -PassThru -Wait
}
Catch
{
   Write-Error "Failed to install the UEM Agent"
   Write-Error $_.Exception
   Exit -1 
}

# Cleanup on aisle 4...
Remove-Item C:\$installer -Confirm:$false
