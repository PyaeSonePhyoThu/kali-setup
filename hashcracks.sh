#!/bin/bash

# Update the system
echo "Updating system..."
sudo apt update -y

# Install required package
echo "Installing p7zip-full..."
sudo apt install p7zip-full -y

# Clone SecLists repository
echo "Cloning SecLists repository..."
git clone https://github.com/danielmiessler/SecLists.git

# Download weakpass file
echo "Downloading weakpass_4a.txt.7z..."
wget https://weakpass.com/download/2015/weakpass_4a.txt.7z -O weakpass_4a.txt.7z

# Clone OneRuleToRuleThemStill repository
echo "Cloning OneRuleToRuleThemStill repository..."
git clone https://github.com/stealthsploit/OneRuleToRuleThemStill.git

# Download megaUniqV2.rule from GitHub
echo "Downloading megaUniqV2.rule..."
wget https://raw.githubusercontent.com/PucciCatzz/Scripts/main/megaUniqV2.rule -O megaUniqV2.rule

# Confirm completion
echo "All tasks completed successfully!"