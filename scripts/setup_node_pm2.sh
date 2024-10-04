#!/bin/bash

# Update system packages
sudo apt update -y

# Install required packages (GCC, make, Git)
sudo apt install -y build-essential git

# Create the application directory and change ownership to ubuntu
sudo mkdir -p /home/ec2-user/app
sudo chown -R ubuntu:ubuntu /home/ec2-user/app

# Install nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# Load nvm (you might need to restart your terminal or run the following command)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Install Node.js version 18
nvm install 18

# Set it as default
nvm alias default 18

# Clone the repository to the desired location
git clone https://github.com/sagar-uprety/nodejs-app.git /home/ec2-user/app

# Change to the application directory
cd /home/ec2-user/app

# Install Node.js dependencies
npm install

# Install pm2 globally
npm install -g pm2

# Start the app using pm2
pm2 start npm --name "nodejs-app" -- start

# Configure pm2 to start on system boot
pm2 startup systemd --user ubuntu

# Save the pm2 process list
pm2 save
