#!/usr/bin/env sh
_user="$(id -u -n)"

echo "ethoFS Master Node Setup Initiated"

echo '**************************'
echo 'Installing misc dependencies'
echo '**************************'
# install dependencies
sudo yum install unzip wget -y

echo '**************************'
echo 'Installing Ether-1 Node binary'
echo '**************************'
# Download node binary
sudo systemctl stop ether1node

sudo rm geth

wget https://github.com/Ether1Project/Ether-1-SN-MN-Binaries/releases/download/1.2.o/Ether1-MN-SN-1.2.0.tar.gz

tar -xzf Ether1-MN-SN-1.2.0.tar.gz

# Make node executable
chmod +x geth

# Remove and cleanup
rm Ether1-MN-SN-1.2.0.tar.gz

echo '**************************'
echo 'Creating and setting up system service'
echo '**************************'

cat > /tmp/ether1node.service << EOL
[Unit]
Description=Ether1 Masternode/Service Node
After=network.target

[Service]

User=$_user
Group=$_user

Type=simple
Restart=always

ExecStart=/usr/sbin/geth --syncmode=fast --cache=512

[Install]
WantedBy=default.target
EOL
        sudo \mv /tmp/ether1node.service /etc/systemd/system
        sudo \rm /usr/sbin/geth
        sudo \mv geth /usr/sbin/
        sudo systemctl enable ether1node && sudo systemctl stop ether1node && sudo systemctl start ether1node
        systemctl status ether1node --no-pager --full

echo 'Done.'