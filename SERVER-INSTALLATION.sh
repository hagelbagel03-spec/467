#!/bin/bash
# STADTWACHE - Server Installation Script
# Für Server: 212.227.57.238 (IPv6: 2a02:2479:39:4500::1)

set -e
clear

echo "=============================================="
echo "  🏛️  STADTWACHE - SERVER INSTALLATION"
echo "      Server: 212.227.57.238"
echo "      Administrator Setup"
echo "=============================================="
echo

# Farben für bessere Ausgabe
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Funktion zum Prüfen der Berechtigung
check_permissions() {
    if [[ $EUID -ne 0 ]]; then
        error "Dieses Script muss als root ausgeführt werden!"
        echo "Verwenden Sie: sudo $0"
        exit 1
    fi
}

# System-Updates
update_system() {
    log "System wird aktualisiert..."
    apt update && apt upgrade -y
    log "System erfolgreich aktualisiert"
}

# Node.js installieren
install_nodejs() {
    log "Node.js wird installiert..."
    
    # NodeSource Repository hinzufügen
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    apt-get install -y nodejs
    
    # Yarn installieren
    npm install -g yarn
    
    log "Node.js $(node --version) und Yarn $(yarn --version) installiert"
}

# Python und Dependencies installieren
install_python() {
    log "Python und Dependencies werden installiert..."
    
    apt-get install -y python3 python3-pip python3-venv python3-dev
    pip3 install --upgrade pip
    
    log "Python $(python3 --version) installiert"
}

# MongoDB installieren
install_mongodb() {
    log "MongoDB wird installiert..."
    
    # MongoDB GPG Key hinzufügen
    curl -fsSL https://pgp.mongodb.com/server-7.0.asc | gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
    
    # MongoDB Repository hinzufügen
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
    
    apt-get update
    apt-get install -y mongodb-org
    
    # MongoDB starten und aktivieren
    systemctl start mongod
    systemctl enable mongod
    
    log "MongoDB erfolgreich installiert und gestartet"
}

# Nginx installieren und konfigurieren
install_nginx() {
    log "Nginx wird installiert und konfiguriert..."
    
    apt-get install -y nginx
    
    # Nginx-Konfiguration für Stadtwache
    cat > /etc/nginx/sites-available/stadtwache << 'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name 212.227.57.238;

    # Frontend (Expo/React)
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Backend API
    location /api/ {
        proxy_pass http://localhost:8001/api/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # API Docs
    location /docs {
        proxy_pass http://localhost:8001/docs;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

    # Site aktivieren
    ln -sf /etc/nginx/sites-available/stadtwache /etc/nginx/sites-enabled/
    rm -f /etc/nginx/sites-enabled/default
    
    # Nginx testen und starten
    nginx -t
    systemctl restart nginx
    systemctl enable nginx
    
    log "Nginx erfolgreich konfiguriert"
}

# Firewall konfigurieren
configure_firewall() {
    log "Firewall wird konfiguriert..."
    
    ufw --force enable
    ufw allow ssh
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw allow 3000/tcp  # Frontend (temporär für Development)
    ufw allow 8001/tcp  # Backend API
    
    log "Firewall konfiguriert"
}

# Stadtwache-User erstellen
create_stadtwache_user() {
    log "Stadtwache-Benutzer wird erstellt..."
    
    # User erstellen
    useradd -m -s /bin/bash stadtwache || true
    usermod -aG sudo stadtwache
    
    # SSH-Verzeichnis erstellen
    mkdir -p /home/stadtwache/.ssh
    chmod 700 /home/stadtwache/.ssh
    chown stadtwache:stadtwache /home/stadtwache/.ssh
    
    log "Benutzer 'stadtwache' erstellt"
}

# Arbeitsverzeichnis erstellen
create_workdir() {
    log "Arbeitsverzeichnis wird erstellt..."
    
    mkdir -p /opt/stadtwache
    chown stadtwache:stadtwache /opt/stadtwache
    
    log "Arbeitsverzeichnis /opt/stadtwache erstellt"
}

# Systemd Services erstellen
create_services() {
    log "Systemd Services werden erstellt..."
    
    # Backend Service
    cat > /etc/systemd/system/stadtwache-backend.service << 'EOF'
[Unit]
Description=Stadtwache Backend API
After=network.target mongod.service
Requires=mongod.service

[Service]
Type=simple
User=stadtwache
WorkingDirectory=/opt/stadtwache/backend
Environment=PATH=/opt/stadtwache/venv/bin
ExecStart=/opt/stadtwache/venv/bin/uvicorn server:app --host 0.0.0.0 --port 8001
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

    # Frontend Service
    cat > /etc/systemd/system/stadtwache-frontend.service << 'EOF'
[Unit]
Description=Stadtwache Frontend
After=network.target

[Service]
Type=simple
User=stadtwache
WorkingDirectory=/opt/stadtwache/frontend
Environment=NODE_ENV=production
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

    # Services aktivieren
    systemctl daemon-reload
    systemctl enable stadtwache-backend
    systemctl enable stadtwache-frontend
    
    log "Systemd Services erstellt"
}

# Hauptfunktion
main() {
    log "Starte Server-Installation für Stadtwache..."
    
    # Berechtigungen prüfen
    check_permissions
    
    # Installation beginnen
    log "1/9 System-Updates..."
    update_system
    
    log "2/9 Node.js Installation..."
    install_nodejs
    
    log "3/9 Python Installation..."
    install_python
    
    log "4/9 MongoDB Installation..."
    install_mongodb
    
    log "5/9 Nginx Installation..."
    install_nginx
    
    log "6/9 Firewall-Konfiguration..."
    configure_firewall
    
    log "7/9 Benutzer erstellen..."
    create_stadtwache_user
    
    log "8/9 Arbeitsverzeichnis erstellen..."
    create_workdir
    
    log "9/9 Services konfigurieren..."
    create_services
    
    echo
    echo "=============================================="
    echo "  🎉 SYSTEM-INSTALLATION ABGESCHLOSSEN!"
    echo "=============================================="
    echo
    echo "✅ System ist bereit für Stadtwache-Deployment"
    echo "✅ MongoDB läuft auf: localhost:27017"
    echo "✅ Nginx konfiguriert für: 212.227.57.238"
    echo "✅ Firewall aktiviert"
    echo "✅ Services vorbereitet"
    echo
    echo "🔄 NÄCHSTE SCHRITTE:"
    echo "1. Stadtwache-Code deployen:"
    echo "   sudo -u stadtwache bash /opt/DEPLOY-STADTWACHE.sh"
    echo
    echo "2. Services starten:"
    echo "   systemctl start stadtwache-backend"
    echo "   systemctl start stadtwache-frontend"
    echo
    echo "3. Status prüfen:"
    echo "   systemctl status stadtwache-backend stadtwache-frontend"
    echo
    echo "📱 APP-ZUGRIFF:"
    echo "   http://212.227.57.238 (über Nginx)"
    echo "   http://212.227.57.238/api/docs (API Dokumentation)"
    echo
}

# Script ausführen
main "$@"