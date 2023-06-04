#!/bin/sh

# Add user and group
groupadd sa_ansible
useradd -g sa_ansible -G wheel -m -s /bin/bash sa_ansible

# Create a random password
echo sa_ansible:$(openssl rand -base64 14) | chpasswd

# Configure SSH public key
mkdir /home/sa_ansible/.ssh
cat <<EOF> /home/sa_ansible/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfr9pOP8v6YDCaSEV90fzASzM4tbKE1TJ9oVen+euDZcbz5MihPuI5/EVfS98CQHVhn/dw3Bc/VK9lOWNymzpXWMkaNIvCcdGAB7EnLO0PjwOiueePZmVgGvFB4L8VeE+LNqQeiGJHa9qNhxQrc/hO2q+ziLQ7kA9h9e6g7HBBYvJ3WNodxQpmdcRcPHKZKHLJ8gtUIqaHFAABSueWfKlOl5FNFwEYuCu0I4aie1z6rIKyuej9zcoiEG3EDU7I0ozWlPcXiQCWfMAjzS/TCLM1zTP6UczlPcipW76YjMg7A9Zdge9KrT8ajSl01Wc4Q5HOUHWTLK5xfRLaGResom2yplWXLR6fjHum6xZtuxWOZXbhMWsqwrN2+06B3zfiubTnw2EEfBt4QYsL8fnBV4rT91ZFwfvmSgWfCLy2sUsrQqdrGH1M8b0nLu3fdsHemqcNBoDvP3eQGNcM5zy49P9+578fHmTtT6Swk+0GYC9IimAPK+NXHD4LWC/cUbCpqAM= sa_ansible
EOF
chown -R sa_ansible:sa_ansible /home/sa_ansible/.ssh
chmod 700 /home/sa_ansible/.ssh
chmod 600 /home/sa_ansible/.ssh/authorized_keys