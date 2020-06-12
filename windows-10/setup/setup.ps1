$ErrorActionPreference = "Stop"

# Switch network connection to private mode
# Required for WinRM firewall rules
While ($profile.Name -ne "Network"){
    Start-Sleep -Seconds 10
    $profile = Get-NetConnectionProfile
}
Set-NetConnectionProfile -Name $profile.Name -NetworkCategory Private

# Enable Network Discovery
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
# netsh advfirewall firewall set privateprofile rule group="Network Discovery" new enable=Yes

# Enable WinRM service
winrm quickconfig -quiet
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

# Reset auto logon count
# https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-logoncount#logoncount-known-issue
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0
