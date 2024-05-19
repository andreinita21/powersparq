# Ghid de Configurare pentru Aplicația PowerSparq

Acest document descrie metodele de configurare disponibile pentru aplicația PowerSparq. Utilizatorii pot opta fie pentru un script automatizat Bash, fie pentru o configurare manuală detaliată.

## Instalare Automată

Puteți folosi scriptul Bash oferit pentru a automatiza procesul de instalare și configurare. Acesta va instala Apache, noVNC, websockify și va configura SSL cu un certificat de la Let's Encrypt.

### Pași de instalare automată:

1. **Descărcați scriptul**:
   Descărcați `setup_noVNC.sh` din repository-ul nostru sau copiați-l direct în serverul dvs.

2. **Executați scriptul**:
   Deschideți un terminal pe server și executați următoarele comenzi:

chmod +x setup_noVNC.sh
./setup_noVNC.sh

Urmați instrucțiunile pe ecran pentru a completa configurarea.

## Instalare Manuală

Dacă preferați controlul total asupra procesului de instalare, urmați instrucțiunile detaliate de mai jos.

### 1. Instalare și configurare Apache

sudo apt update
sudo apt install apache2

### 2. Instalare Git și descărcare noVNC și websockify

sudo apt install git
cd /var/www/html
sudo git clone https://github.com/novnc/noVNC.git
sudo mv noVNC vnc
cd vnc
sudo git clone https://github.com/novnc/websockify.git

### 3. Configurați Apache pentru a servi noVNC
Creați un fișier de configurare Apache:

sudo nano /etc/apache2/sites-available/vnc.conf

Adăugați configurarea:

<VirtualHost :>
ProxyPreserveHost On
ProxyPass /websockify ws://127.0.0.1:6080/
ProxyPassReverse /websockify ws://127.0.0.1:6080/
ServerName [YOUR_DOMAIN]
DocumentRoot /var/www/html/vnc
<Directory "/var/www/html/vnc">
Options Indexes FollowSymLinks
AllowOverride All
Require all granted
</Directory>
</VirtualHost>

Activează site-ul și modulele necesare, apoi restartează Apache:

sudo a2enmod proxy proxy_wstunnel proxy_http
sudo a2ensite vnc.conf
sudo systemctl restart apache2

### 4. Configurați websockify ca serviciu systemd

Adăugați:
[Unit]
Description=Websockify Service for noVNC
After=network.target

[Service]
ExecStart=/var/www/html/vnc/websockify/run --web=/var/www/html/vnc 6080 [YOUR_VNC_IP]:5900
Restart=always
User=www-data

[Install]
WantedBy=multi-user.target

Activare și start:
sudo systemctl daemon-reload
sudo systemctl enable websockify.service
sudo systemctl start websockify.service

### 5. Instalare Certbot și configurare SSL
sudo apt install certbot python3-certbot-apache
sudo certbot --apache

## Note Suplimentare
- Asigurați-vă că serverul este accesibil public pe porturile 80 și 443 pentru validarea Let's Encrypt.
- Certificatul SSL va fi reînnoit automat de Certbot.
