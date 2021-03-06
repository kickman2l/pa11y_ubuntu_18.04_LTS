#!/bin/bash

# install required packages 'package.list'
sudo apt-get update -y
sudo apt-get install -y $(cat package.list)
sudo npm install forever -g

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

# checkout and install pa11y
git clone https://github.com/kickman2l/pa11y-dashboard.git
cd ./pa11y-dashboard/ && npm install

#start nginx
sudo nginx -s reload
sudo systemctl start nginx

mkdir "/home/ubuntu/logs_backups"
mkdir "/home/ubuntu/logs_backups/logs"
mkdir "/home/ubuntu/logs_backups/backups"

(crontab -l ; echo "0 20 * * * mongodump --host=127.0.0.1 --port=27017 --db=pa11y-webservice --out=/home/ubuntu/logs_backups/backups/") | crontab -