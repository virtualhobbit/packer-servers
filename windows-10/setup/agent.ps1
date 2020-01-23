$ErrorActionPreference = "Stop"

$webserver = "intranet.mdb-lab.com"
$url = "http://" + $webserver
$installer = "VMware-Horizon-Agent-x86_64-7.11.0-15238678.exe"
$listConfig = "/s /v ""/qn REBOOT=ReallySuppress ADDLOCAL=Core,RTAV,ClientDriveRedirection,VmwVaudio"""

# Verify connectivity
Test-Connection $webserver -Count 1

# Get Horizon Agent
Invoke-WebRequest -Uri ($url + "/" + $installer) -OutFile C:\$installer

# Unblock installer
Unblock-File C:\$installer -Confirm:$false -ErrorAction Stop

# Install Horizon Agent
Try 
{
   Start-Process C:\$installer -ArgumentList $listConfig -PassThru -Wait -ErrorAction Stop
}
Catch
{
   Write-Error "Failed to install the Horizon Agent"
   Write-Error $_.Exception
   Exit -1 
}

# Cleanup on aisle 4...
Remove-Item C:\$installer -Confirm:$false
