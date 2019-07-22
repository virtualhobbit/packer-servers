Get-PackageProvider -Name nuget -Force

Install-Module PSWindowsUpdate -Confirm:$false -Force

Import-Module PSWindowsUpdate

Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot
