#Who TF are you bro?
whoami

# Get the provider
Get-PackageProvider -Name nuget -Force

# Install the module
Install-Module PSWindowsUpdate -Confirm:$false -Force

# Install updates
# Get-WindowsUpdate | Out-File C:\result.txt

Install-WindowsUpdate -AcceptAll -IgnoreReboot

# Sleepy time...
Start-Sleep -Seconds 1200

# Run it again, as apparently it needs two attempts
Install-WindowsUpdate -AcceptAll -IgnoreReboot
