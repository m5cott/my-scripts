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

# Basic Firewall setup with ufw
$priv ufw default deny incoming
$priv ufw default allow outgoing
$priv ufw logging on
$priv ufw enable

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

# Git config
git config --global user.name m5cott
git config --global user.email mcscottbsn@outlook.com
git config --global color.ui auto
git config --global core.editor "vim"

# Setting up home dir and dotfiles
cd Downloads && git clone https://github.com/m5cott/my-configs
cd my-configs && ./setup.sh

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

# go lang
curl -L -o /tmp/go1.15.3.linux-amd64.tar.gz https://golang.org/dl/go1.15.3.linux-amd64.tar.gz
$priv tar -C /usr/local -xzf /tmp/go1.15.3.linux-amd64.tar.gz
$priv echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.profile
source $HOME/.profile
go version
rm -rf /tmp/go1.15.3.linux-amd64.tar.gz

# powerline-go
go get -u github.com/justjanne/powerline-go

# pwsh
curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.0.3/powershell-7.0.3-linux-x64.tar.gz
$priv mkdir -p /opt/microsoft/powershell/7
$priv tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
$priv chmod +x /opt/microsoft/powershell/7/pwsh
$priv ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
rm -rf /tmp/powershell.tar.gz

# youtube-dl
$priv curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
$priv chmod a+rx /usr/local/bin/youtube-dl
