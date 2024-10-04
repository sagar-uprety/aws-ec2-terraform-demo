#!/bin/bash

# Update system packages
sudo apt update -y

# Install required packages (GCC, make, Node.js)
sudo apt install -y build-essential

# Remove existing Node.js and related packages to prevent conflicts
sudo apt remove --purge -y nodejs libnode72
sudo apt autoremove -y

# Install Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install git
sudo apt install -y git

# Clone the repository to the desired location
sudo git clone https://github.com/sagar-uprety/nodejs-app.git /home/ec2-user/app

# Change to the application directory
cd /home/ec2-user/app

# Install Node.js dependencies
sudo npm install

# Install pm2 globally
sudo npm install -g pm2

# Start the app using pm2
sudo pm2 start npm --name "nodejs-app" -- start

# Configure pm2 to start on system boot
sudo pm2 startup systemd

# Save the pm2 process list
sudo pm2 save
