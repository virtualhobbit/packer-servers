# Get the provider
Get-PackageProvider -Name nuget -Force

# Install the module
Install-Module PSWindowsUpdate -Confirm:$false -Force

# Install updates
Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot

# Run it again, as apparently it needs two attempts
Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot
