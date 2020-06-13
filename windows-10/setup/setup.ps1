$ErrorActionPreference = "Stop"

# Switch network connection to private mode
# Required for WinRM firewall rules
$profile = Get-NetConnectionProfile
While ($profile.Name -eq "Identifying..."){
    Start-Sleep -Seconds 10
    $profile = Get-NetConnectionProfile
}
Set-NetConnectionProfile -Name $profile.Name -NetworkCategory Private

# Disable Network Discovery
# netsh advfirewall firewall set rule group="Network Discovery" new enable=No

# Disanle Network Location Awareness
# Set-Service -Name NlaSvc -StartupType Disabled

# Enable PS Remoting
# Enable-PSRemoting -SkipNetworkProfileCheck -Force

# Enable WinRM service
winrm quickconfig -quiet
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

# Enable WinRM on Public profile
Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP' -RemoteAddress Any -Enabled True

# Reset auto logon count
# https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-logoncount#logoncount-known-issue
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0
