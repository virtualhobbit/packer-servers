<#

.SYNOPSIS
Build a desktop image

.DESCRIPTION
Takes input from the user then uses HashiCorp Packer to deploy the image and necessary agents

.EXAMPLE
Build-Image.ps1

.NOTES
Author: Mark Brookfield (@virtualhobbit)

#>

# Get the Horizon version
$horizonVersion = Read-Host -Prompt "What is the Horizon version"

# Get the Dynamic/User Environment Manager version
$demVersion = Read-Host -Prompt "What is the Dynamic/User Environment Manager version"

# Get the NVidia GRID version
$gridVersion = Read-Host -Prompt "What is the NVidia GRID version"

# Get the NVidia GRID server name
$gridServer = Read-Host -Prompt "Enter the FQDN of the NVidia GRID server"

# Get the AppVolumes server name
$appVolumesServer = Read-Host -Prompt "Enter the FQDN of the AppVolumes server"

# Calculate the Horizon Agent binary name
switch ($horizonVersion){
    7.6 {
        $horizonInstaller = "VMware-Horizon-Agent-x86_64-7.6.0-9539447.exe"
        $directConnectInstaller = "VMware-Horizon-Agent-Direct-Connection-x86_64-7.6.0-9539447.exe"
    }
    7.7 {
        $horizonInstaller = "VMware-Horizon-Agent-x86_64-7.7.0-11054235.exe"
        $directConnectInstaller = "VMware-Horizon-Agent-Direct-Connection-x86_64-7.7.0-11054235.exe "
    }
    7.8 {
        $horizonInstaller = "VMware-Horizon-Agent-x86_64-7.8.0-12599301.exe"
        $directConnectInstaller = "VMware-Horizon-Agent-Direct-Connection-x86_64-7.8.0-12599301.exe"
    }
    7.9 {
        $horizonInstaller = "VMware-Horizon-Agent-x86_64-7.9.0-13938590.exe"
        $directConnectInstaller = "VMware-Horizon-Agent-Direct-Connection-x86_64-7.9.0-13938590.exe"
    }
    7.10 {
        $horizonInstaller = "VMware-Horizon-Agent-x86_64-7.10.0-14590940.exe"
        $directConnectInstaller = "VMware-Horizon-Agent-Direct-Connection-x86_64-7.10.0-14590940.exe"
    }
    7.11 {
        $horizonInstaller = "VMware-Horizon-Agent-x86_64-7.11.0-15238678.exe"
        $directConnectInstaller = "VMware-Horizon-Agent-Direct-Connection-x86_64-7.11.0-15238678.exe"
    }
    7.12 {
        $horizonInstaller = "VMware-Horizon-Agent-x86_64-7.12.0-15805436.exe"
        $directConnectInstaller = "VMware-Horizon-Agent-Direct-Connection-x86_64-7.12.0-15805436.exe"
    }
}

# Process the Horizon Agent and Direct Connect scripts and swap out the installer command
$horizonScript = "setup/agent.ps1"
(Get-Content -Path $horizonScript) -replace '(^\$installer = )(.+)',"$('$1')""$horizonInstaller"""
$directConnectScript = "setup/directConnect.ps1"
(Get-Content -Path $directConnectScript) -replace '(^\$installer = )(.+)',"$('$1')""$directConnectInstaller"""

# Calculate the DEM/UEM binary name
switch ($demVersion){
    9.5 {
        $demInstaller = "VMware User Environment Manager 9.5 x64.msi"
    }
    9.6 {
        $demInstaller = "VMware User Environment Manager 9.6 x64.msi"
    }
    9.7 {
        $demInstaller = "VMware User Environment Manager 9.7 x64.msi"
    }
    9.8 {
        $demInstaller = "VMware User Environment Manager 9.8 x64.msi"
    }
    9.9 {
        $demInstaller = "VMware Dynamic Environment Manager 9.9 x64.msi"
    }
    9.10 {
        $demInstaller = "VMware Dynamic Environment Manager 9.10 x64.msi"
    }
    9.11 {
        $demInstaller = "VMware Dynamic Environment Manager 9.11 x64.msi"
    }

}

# Process the DEM/UEM Agent script and swap out the installer command
$demScript = "setup/dem.ps1"
(Get-Content -Path $demScript) -replace '(^\$installer = )(.+)',"$('$1')""$demInstaller"""

# Calculate the Grid binary name
switch ($gridVersion){
    10.1 {
        $gridInstaller = "442.06_grid_win10_server2016_server2019_64bit_international.exe"
    }
}

# Process the Grid Agent script and swap out the installer command and server name
$gridScript = "setup/grid.ps1"
(Get-Content -Path $gridScript) -replace '(^\$installer = )(.+)',"$('$1')""$gridInstaller"""
(Get-Content -Path $gridScript) -replace '(^\$installer = )(.+)',"$('$1')""$gridServer"""

# Calculate the App Volumes binary name
switch ($appVolumesVersion){
    10.1 {
        $appVolumesInstaller = "app volumes.msi"
    }
}

# Process the AppVolumes Agent script and swap out the installer command and server name
$appVolumesScript = "appvolumes.ps1"
(Get-Content -Path $appVolumesScript) -replace '(^\$appVolumesServer = )(.+)',"$('$1')""$appVolumesInstaller"""
(Get-Content -Path $appVolumesScript) -replace '(^\$appVolumesServer = )(.+)',"$('$1')""$appVolumesServer"""

<#
# Begin build
Try {
    packer build -force -var-file variables.json windows-10.json
}
Catch {
    Write-Host "There has been an error"
    $_
}
#>