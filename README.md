# 🔌 PowerSparq ⚡

## Realizatori și Contribuții

- **Nita Andrei**
  - Programare Front-End & Back-End, SysAdmin

## Ce este PowerSparq?

PowerSparq este o soluție tehnologică destinată economisirii energiei, care permite utilizatorilor să controleze și să acceseze desktopurile la distanță folosind tehnologia Wake on LAN (WoL) prin internetul global și o interfață implementată pe un dispozitiv Raspberry Pi. Prin această soluție, utilizatorii vor putea porni desktopul la distanță numai atunci când este necesar, evitând astfel timpul în care acesta trebuie să fie în mod constant pornit.

## Care este soluția propusă?

PowerSparq este conceput pentru a oferi o metodă eficientă și ecologică de gestionare a desktopurilor prin intermediul unei interfețe web simplificate, găzduită pe un Raspberry Pi.

Această platformă permite utilizatorilor să inițieze pornirea desktopurilor lor de la distanță printr-un simplu clic, evitând astfel consumul inutil de energie care ar rezulta din menținerea continuă în funcțiune a acestora.

Prin implementarea acestei soluții, utilizatorii beneficiază de acces la fișierele și aplicațiile lor fără a compromite eficiența energetică, contribuind în același timp la reducerea impactului asupra mediului.

## Care sunt funcționalitățile aplicației?

### Wake on LAN (WoL)

Folosim un script Python pe Raspberry Pi pentru a trimite pachete Magic Wake on LAN către adresa MAC a desktopului pentru a-l porni de la distanță cu ajutorul bibliotecii Python wakeonlan.

### Interfața aplicației

Am dezvoltat o aplicație pentru controlul desktopului de la distanță și pentru accesarea funcției de WoL.

### Accesul la ecranul desktopului de la distanță

Utilizăm un client VNC (Virtual Network Computing) pentru a accesa și controla ecranul desktopului de la distanță.

### Securitate

Ne asigurăm că interfața web și conexiunile VNC sunt securizate folosind HTTPS pentru criptarea comunicațiilor.

Folosim o bază de date criptată unde sunt stocate conturile pentru autentificarea în interfața web.

Utilizând tunelarea Cloudflare, PowerSparq îmbunătățește securitatea prin crearea unui tunel securizat între Raspberry Pi și infrastructura Cloudflare, eliminând astfel necesitatea porturilor deschise și asigurând criptarea avansată a datelor și prevenind atacuri în rețeaua de acasă.

## Ce elemente distinctive are PowerSparq?

PowerSparq se diferențiază de soluții consacrate precum AnyDesk sau TeamViewer prin câteva aspecte cheie:

### Reducerea consumului de energie

Folosește tehnologia Wake on LAN pentru a permite pornirea desktopurilor doar când este necesar, reducând semnificativ consumul de energie față de alte soluții care necesită funcționarea continuă a sistemelor pentru acces la distanță.

### Flexibilitate și accesibilitate

Oferă o interfață web simplă și intuitivă pe Raspberry Pi, ușor de utilizat pentru toți utilizatorii, spre deosebire de interfețele mai complexe ale AnyDesk sau TeamViewer.

### Securitate

Asigură securitate sporită prin criptarea comunicațiilor și un sistem robust de autentificare, oferind un nivel de protecție superior comparativ cu soluțiile standard, care se concentrează mai mult pe funcționalități generale decât pe personalizarea securității.

Aceste caracteristici fac din PowerSparq o opțiune atrăgătoare pentru cei interesați de eficiența energetică, ușurința de utilizare și securitatea datelor.

# 📖 Ghid de Configurare pentru 🔌 PowerSparq ⚡

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
