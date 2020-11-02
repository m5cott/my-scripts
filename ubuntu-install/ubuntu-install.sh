#!/bin/bash
#
# Name: ubuntu-install.sh
# Purpose: One stop shop to setting up an ubuntu system
# Author: Michael Scott (m5cott)
# Created: 2020-11-01
# License: MIT License
#

function install {
    which $1 &> /dev/null

    if [ $? -ne 0 ]; then
        echo "Installing: ${1}..."
        apt install $1
    else
        echo "Already installed: ${1}"
    fi
}

# Deb Packages
install curl
install gnome-tweaks
install git
install git-core
install build-essential
install unzip
install unrar
install vim 
install pylint
install python-pip-whl
install ffmpeg 
install qemu 
install qemu-utils 
install qemu-kvm 
install libvirt-clients 
install libvirt-daemon-system 
install bridge-utils
install deluge

sudo usermod -aG kvm $USER
sudo usermod -aG libvirt $USER
sudo usermod -aG libvirt-qemu $USER
sudo usermod -aG libvirt-dnsmasq $USER

# Snaps
sudo snap install qemu-virgil --edge
sudo snap connect qemu-virgil:audio-record
sudo snap connect qemu-virgil:kvm
sudo snap connect qemu-virgil:raw-usb
sudo snap connect qemu-virgil:removable-media

# Quickemu
git clone https://github.com/wimpysworld/quickemu.git

# VS Code
wget -O code.deb https://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg -i code.deb
rm -f code.deb

# youtube-dl
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl