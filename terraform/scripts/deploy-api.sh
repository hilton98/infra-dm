#!/bin/bash

DB_HOST=${DB_HOST}
DB_NAME=${DB_NAME}
DB_USERNAME=${DB_USERNAME}
DB_PASSWORD=${DB_PASSWORD}

echo "Update System..."
sudo apt update && sudo apt upgrade -y

echo "Installing Node..."
sudo apt-get install -y curl

curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh

sudo -E bash nodesource_setup.sh

sudo apt-get install -y nodejs

node -v

APP_DIR="/home/ubuntu/app"

sudo echo "Create .env..."
sudo echo "DB_HOST=${DB_HOST}" > .env
sudo echo "DB_USERNAME=${DB_USERNAME}" >> .env
sudo echo "DB_PASSWORD=${DB_PASSWORD}" >> .env
sudo echo "DB_NAME=${DB_NAME}" >> .env

if [ ! -d "$APP_DIR" ]; then
  echo "Directory $APP_DIR not found. Cloning repository..."
  git clone https://github.com/hilton98/device-management-api.git "$APP_DIR"
else
  echo "Directory $APP_DIR found. Update repository..."
  cd "$APP_DIR"
  git pull origin main
fi

cd "$APP_DIR"

echo "Installing API dependencies..."
sudo npm install

echo "Run Migrations..."
sudo npm run migration:run

echo "Build API..."
sudo npm run build

echo "Installing PM2..."
sudo npm install -g pm2

echo "Start/Restart API with PM2..."
pm2 start dist/main.js --name dm-api || pm2 restart dm-api
