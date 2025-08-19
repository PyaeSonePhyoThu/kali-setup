#!/bin/bash

# Create Tools directory
TOOLS_DIR="/root/Desktop/Tools"
mkdir -p $TOOLS_DIR

# Add Sublime Text repository and update
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Update package list and upgrade system
sudo apt-get update -y && sudo apt-get upgrade -y

# Update database
sudo updatedb

# Install tools and dependencies
sudo apt-get install -y golang
sudo apt-get install -y remmina
sudo apt-get install -y seclists
#sudo apt-get install -y netexec
sudo apt-get install -y gobuster
sudo apt-get install -y rlwrap
sudo apt-get install -y nuclei
sudo apt-get install -y zenity
sudo apt install pipx git

# Install the latest version of nuclei using go
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# Install Haiti-Hash gem
sudo gem install haiti-hash

# Install Sublime Text
sudo apt-get install -y sublime-text

# Install asnmap
wget https://github.com/projectdiscovery/asnmap/releases/download/v1.1.0/asnmap_1.1.0_linux_amd64.zip
unzip asnmap_1.1.0_linux_amd64.zip -d $TOOLS_DIR
sudo mv $TOOLS_DIR/asnmap /usr/local/bin/
rm $TOOLS_DIR/asnmap_1.1.0_linux_amd64.zip $TOOLS_DIR/LICENSE $TOOLS_DIR/README.md

# Install RustScan
wget https://github.com/RustScan/RustScan/releases/download/2.2.3/rustscan_2.2.3_amd64.deb
sudo dpkg -i rustscan_2.2.3_amd64.deb
rm rustscan_2.2.3_amd64.deb


# Clone Trickest Wordlists
git clone https://github.com/trickest/wordlists.git $TOOLS_DIR/wordlists

# Download linpeas.sh
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -P $TOOLS_DIR
chmod +x $TOOLS_DIR/linpeas.sh

# Unzip rockyou.txt.gz
gunzip /usr/share/wordlists/rockyou.txt.gz

# Install latest netexec 
pipx ensurepath
pipx install git+https://github.com/Pennyw0rth/NetExec

# Install BloodHound
