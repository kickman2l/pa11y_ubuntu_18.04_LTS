#!/bin/bash

# install required packages 'package.list'
sudo apt-get update -y
sudo apt-get install -y $(cat package.list)

# enabling and starting mongo
sudo systemctl enable mongodb
sudo systemctl start mongodb

# configuring nginx
sudo systemctl enable nginx
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
sudo /bin/cp -r ./default /etc/nginx/sites-available/
sudo /bin/cp -r ./self-signed.conf /etc/nginx/snippets/
sudo /bin/cp -r ./ssl-params.conf /etc/nginx/snippets/
sudo /bin/cp -r ./pa11y.service /etc/systemd/system/

# checkout and install pa11y
git clone https://github.com/pa11y/pa11y-dashboard.git
cd ./pa11y-dashboard/ && npm install

sudo systemctl enable pa11y
sudo systemctl start pa11y

#start nginx
sudo nginx -s reload
sudo systemctl start nginx
