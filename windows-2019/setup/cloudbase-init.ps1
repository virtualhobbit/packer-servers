# Variables
$msiLocation = 'https://cloudbase.it/downloads'
$msiFileName = 'CloudbaseInitSetup_Stable_x64.msi'

# Install te software
Invoke-WebRequest -Uri ($msiLocation + '/' + $msiFileName) -OutFile C:\$msiFileName
Unblock-File -Path C:\$msiFileName
Start-Process msiexec.exe -ArgumentList "/i C:\$msiFileName /qn /norestart RUN_SERVICE_AS_LOCAL_SYSTEM=1" -Wait

# Write-out configuration file
$confFile = 'cloudbase-init.conf'
$confPath = "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\"
$confContent = @"
[DEFAULT]
bsdtar_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\bsdtar.exe
mtools_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\
verbose=true
debug=true
logdir=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\
logfile=cloudbase-init.log
default_log_levels=comtypes=INFO,suds=INFO,iso8601=WARN,requests=WARN
local_scripts_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts\
metadata_services=cloudbaseinit.metadata.services.vmwareguestinfoservice.VMwareGuestInfoService
plugins=cloudbaseinit.plugins.common.userdata.UserDataPlugin
"@
New-Item -Path $confPath -Name $confFile -ItemType File -Force -Value $confContent | Out-Null

# Configure service to sart auto-delayed
Start-Process sc.exe -ArgumentList "config cloudbase-init start= delayed-auto" -wait | Out-Null

# Remove uneecessary files
Remove-Item -Path ($confPath + "cloudbase-init-unattend.conf") -Confirm:$false 
Remove-Item -Path ($confPath + "Unattend.xml") -Confirm:$false 
Remove-Item C:\$msiFileName -Confirm:$false