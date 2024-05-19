#!/bin/bash

# Actualizare și instalare dependențe
sudo apt update && sudo apt install apache2 git certbot python3-certbot-apache -y

# Solicită input de la utilizator
echo "Introdu portul pentru websockify:"
read websockify_port
echo "Introdu IP-ul desktopului in reteaua locala (ex. 192.168.1.100):"
read desktop_ip
echo "Introdu portul pe care ruleaza VNC pe desktop (ex. 5900):"
read vnc_port

# Setează și clonează noVNC și websockify
cd /var/www/html
sudo git clone https://github.com/novnc/noVNC.git
sudo mv noVNC vnc
cd vnc
sudo git clone https://github.com/novnc/websockify.git

# Creează și configurează Apache Virtual Host
sudo bash -c "cat > /etc/apache2/sites-available/vnc.conf <<EOF
<VirtualHost *:*>
    ProxyPreserveHost On
    ProxyPass /websockify ws://127.0.0.1:$websockify_port/
    ProxyPassReverse /websockify ws://127.0.0.1:$websockify_port/
    ServerName $(hostname -I | awk '{print \$1}')
    DocumentRoot /var/www/html/vnc
    <Directory "/var/www/html/vnc">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF"

# Activează site-ul și modulele necesare
sudo a2enmod proxy proxy_wstunnel proxy_http
sudo a2ensite vnc.conf
sudo systemctl restart apache2

# Configurare serviciu systemd pentru websockify
sudo bash -c "cat > /etc/systemd/system/websockify.service <<EOF
[Unit]
Description=Websockify Service for noVNC
After=network.target

[Service]
ExecStart=/var/www/html/vnc/websockify/run --web=/var/www/html/vnc $websockify_port $desktop_ip:$vnc_port
Restart=always
User=www-data

[Install]
WantedBy=multi-user.target
EOF"

# Start și enable websockify service
sudo systemctl daemon-reload
sudo systemctl enable websockify.service
sudo systemctl start websockify.service

# Obține și configurează certificat SSL
sudo certbot --apache --non-interactive --agree-tos -m your@email.com --domains $(hostname -I | awk '{print \$1}')
