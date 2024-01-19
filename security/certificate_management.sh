#!/bin/bash

#script to manage SSL/TLS certificates using certbot

domain="domain.com"
email="email@example.com"

#install certbot if not already installed
if ! command -v certbot &> /dev/null; then
    echo "Installing certbot..."
    sudo apt-get update
    sudo apt-get install certbot
fi

#obtain or renew SSL/TLS certificate
echo "Obtaining/renewing SSL/TLS certificate for $domain..."
sudo certbot certonly --standalone -d "$domain" --email "$email" --agree-tos --non-interactive

#After obtaining/renewing the certificate you may want to reload services using the new certificate
#For example, if you are using Nginx:
    #sudo service nginx reload

echo "SSL/TLS certificate management completed for $domain"