$ErrorActionPreference = "Stop"

$webserver = "intranet.mdb-lab.com"
$url = "http://" + $webserver
$installer = "VMware-Horizon-Agent-x86_64-7.12.0-15805436.exe"
$listConfig = "/s /v ""/qn REBOOT=ReallySuppress ADDLOCAL=Core,SVIAgent,RTAV,ClientDriveRedirection,V4V,VmwVaudio,PerfTracker"""

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
