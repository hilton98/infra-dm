#!/bin/bash

if [ ! -d "/home/ubuntu/app" ]; then
  echo "Directory /home/ubuntu/app not found. Cloning repository..."
  git clone https://github.com/hilton98/device-management-api.git /home/ubuntu/app
else
  echo "Directory /home/ubuntu/app found. Update repository..."
  cd /home/ubuntu/app
  git pull origin main
fi

cd /home/ubuntu/app

echo "Instaling dependencies..."
npm install

echo "Build api..."
npm run build

echo "Instaling PM2..."
sudo npm install -g pm2

echo "Starting/Restart api with PM2..."
pm2 start dist/main.js --name dm-api || pm2 restart dm-api
