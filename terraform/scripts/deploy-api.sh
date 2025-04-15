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

echo "Create .env..."
cat <<EOF > .env
DB_HOST=${DB_HOST}
DB_USERNAME=${DB_USERNAME}
DB_PASSWORD=${DB_PASSWORD}
DB_NAME=${DB_NAME}
EOF

if [ ! -d "$APP_DIR" ]; then
  echo "Directory $APP_DIR not found. Cloning repository..."
  git clone https://github.com/hilton98/project-teste.git "$APP_DIR"
else
  echo "Directory $APP_DIR found. Update repository..."
  cd "$APP_DIR"
  git pull origin main
fi

cd "$APP_DIR"

echo "Instaling API dependencies..."
npm install

echo "Build API..."
npm run build

echo "Installing PM2..."
sudo npm install -g pm2

echo "Start/Restart API with PM2..."
pm2 start dist/main.js --name dm-api || pm2 restart dm-api
