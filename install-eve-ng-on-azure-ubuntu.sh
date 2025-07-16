#!/bin/bash

# EVE-NG Installer Script for Azure Ubuntu VM
# Tested on Ubuntu 20.04/22.04 LTS

set -e

echo "===== EVE-NG Installer for Azure Ubuntu ====="
echo "WARNING: This script will install EVE-NG Community Edition on your system."
echo "Tested on Ubuntu 20.04/22.04 LTS only."
echo "Run as root or with sudo privileges."
echo "============================================="

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo -i or sudo bash $0)"
  exit 1
fi

# 1. Update system and install necessary packages
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y

# 2. Install required dependencies
apt-get install -y \
  software-properties-common \
  bridge-utils \
  apt-transport-https \
  ca-certificates \
  wget \
  git \
  lsb-release \
  nano

# 3. Set hostname (optional, you can customize this)
hostnamectl set-hostname eve-ng

# 4. Add EVE-NG repository and key
wget -O - http://www.eve-ng.net/repo/eczema@ecze.com.gpg.key | apt-key add -
echo "deb [arch=amd64] http://www.eve-ng.net/repo xenial main" > /etc/apt/sources.list.d/eve-ng.list

apt-get update

# 5. Install EVE-NG Community Edition
apt-get install -y eve-ng

# 6. Fix permissions (required for proper operation)
cd /opt/unetlab/wrappers
./fixpermissions.sh

# 7. Optional: Open required ports in Azure NSG (document only)
echo ""
echo "===== Azure Networking Note ====="
echo "Make sure to open the following ports in your Azure Network Security Group (NSG):"
echo " - 80/tcp (HTTP, Web GUI)"
echo " - 443/tcp (HTTPS, Web GUI)"
echo " - 22/tcp (SSH)"
echo " - 8080/tcp (Web VNC Console)"
echo " - 32769-32899/tcp (Dynamips, iOL, etc. - as needed)"
echo "Refer to https://www.eve-ng.net/index.php/documentation/faq/ for full list."
echo "==============================="

# 8. Final message
echo ""
echo "EVE-NG installation complete!"
echo "Access the EVE-NG Web UI at: http://<your-azure-vm-public-ip>/"
echo "Default credentials: admin/eve"
echo "Reboot your VM for all changes to take effect."
echo "Enjoy using EVE-NG in Azure!"

exit 0
