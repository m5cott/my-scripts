#!/bin/bash
#
# Name: ubuntu-install.sh
# Purpose: One stop shop to setting up an ubuntu system
# Author: Michael Scott (m5cott)
# Created: 2020-11-01
# License: MIT License
#

# Global Variables
priv="sudo"
file="applications"

function install {
    which $1 &> /dev/null

    if [ $? -ne 0 ]; then
        echo "Installing: ${1}..."
        $priv apt install $1
    else
        echo "Already installed: ${1}"
    fi
}

# Check if user is sudo
echo "Please enter your password to continue"
[ "$UID" -eq 0 ] || exec $priv "$0" "$@"

# Installing Packages from Main Repo
while IFS= read -r line
do
    install "$line"
done <"$file"

# Adding VM groups to current user
$priv usermod -aG kvm $USER
$priv usermod -aG libvirt $USER
$priv usermod -aG libvirt-qemu $USER
$priv usermod -aG libvirt-dnsmasq $USER

# Snaps
$priv snap install qemu-virgil --edge
$priv snap connect qemu-virgil:audio-record
$priv snap connect qemu-virgil:kvm
$priv snap connect qemu-virgil:raw-usb
$priv snap connect qemu-virgil:removable-media

# Quickemu
git clone https://github.com/wimpysworld/quickemu.git

# Pop Shell
git clone https://github.com/pop-os/shell
cd shell && make local-install

# Cascadia Code PL (Work in Progress)
wget https://github.com/microsoft/cascadia-code/releases/download/v2009.22/CascadiaCode-2009.22.zip
unzip CascadiaCode-2009.22.zip -d CascadiaCode

# VS Code
wget -O code.deb https://go.microsoft.com/fwlink/?LinkID=760868
$priv dpkg -i code.deb
rm -f code.deb

# youtube-dl
$priv curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
$priv chmod a+rx /usr/local/bin/youtube-dl
