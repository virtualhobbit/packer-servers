# Variables
$length = 10 ## characters
$nonAlphaChars = 5
Add-Type -AssemblyName 'System.Web'

# Create the user
$user = "sa_ansible"
$pass = ([System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars))
$secureString = ConvertTo-SecureString $pass -AsPlainText -Force
New-LocalUser -Name $user -Password $secureString
$credential = New-Object System.Management.Automation.PsCredential($user,$secureString)

# Create the home folder
$process = Start-Process cmd /c -Credential $credential -ErrorAction SilentlyContinue -LoadUserProfile

# Configure SSH public key
New-Item -Path "C:\Users\$user" -Name ".ssh" -ItemType Directory
$content = @"
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfr9pOP8v6YDCaSEV90fzASzM4tbKE1TJ9oVen+euDZcbz5MihPuI5/EVfS98CQHVhn/dw3Bc/VK9lOWNymzpXWMkaNIvCcdGAB7EnLO0PjwOiueePZmVgGvFB4L8VeE+LNqQeiGJHa9qNhxQrc/hO2q+ziLQ7kA9h9e6g7HBBYvJ3WNodxQpmdcRcPHKZKHLJ8gtUIqaHFAABSueWfKlOl5FNFwEYuCu0I4aie1z6rIKyuej9zcoiEG3EDU7I0ozWlPcXiQCWfMAjzS/TCLM1zTP6UczlPcipW76YjMg7A9Zdge9KrT8ajSl01Wc4Q5HOUHWTLK5xfRLaGResom2yplWXLR6fjHum6xZtuxWOZXbhMWsqwrN2+06B3zfiubTnw2EEfBt4QYsL8fnBV4rT91ZFwfvmSgWfCLy2sUsrQqdrGH1M8b0nLu3fdsHemqcNBoDvP3eQGNcM5zy49P9+578fHmTtT6Swk+0GYC9IimAPK+NXHD4LWC/cUbCpqAM= sa_ansible
"@ 

# Write public key to file
$content | Set-Content -Path "c:\users\$user\.ssh\authorized_keys"