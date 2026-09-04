#!/bin/bash
apt-get update -y
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx
echo "<h1>Welcome to Tier 2: App Server</h1><p>Internal backend served from $(hostname -f)</p>" > /var/www/html/index.html
