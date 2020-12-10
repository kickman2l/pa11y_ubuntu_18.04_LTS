#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y libnss3
sudo apt-get install -y libgconf-2-4
sudo apt-get install -y libx11-xcb-dev
sudo apt-get install -y libxcomposite-dev
sudo apt-get install -y libxcursor-dev
sudo apt-get install -y libxdamage-dev
sudo apt-get install -y libxi-dev
sudo apt-get install -y libxtst-dev
sudo apt-get install -y libcups2-dev
sudo apt-get install -y libxss1
sudo apt-get install -y libxrandr-dev
sudo apt-get install -y libasound2-dev
sudo apt-get install -y libatk-adaptor
sudo apt-get install -y libpangocairo-1.0-0
sudo apt-get install -y libgtk-3-dev

sudo apt-get install -y git
sudo apt-get install -y nodejs
sudo apt-get install -y npm
sudo apt-get install -y nginx

sudo apt-get install -y mongodb
sudo systemctl enable mongodb
sudo systemctl start mongodb

git clone https://github.com/pa11y/pa11y-dashboard.git
cd ./pa11y-dashboard/ && npm install

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

sudo /bin/cp -r ../default /etc/nginx/sites-available/
sudo /bin/cp -r ../self-signed.conf /etc/nginx/snippets/
sudo /bin/cp -r ../ssl-params.conf /etc/nginx/snippets/

node index.js &> output.log &

sudo systemctl enable nginx
sudo nginx -s reload
sudo systemctl start nginx