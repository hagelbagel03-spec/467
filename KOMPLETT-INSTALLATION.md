# 🏛️ STADTWACHE - Komplette Server-Installation

## Server-Details
- **IP-Adresse:** 212.227.57.238
- **IPv6:** 2a02:2479:39:4500::1
- **Benutzer:** Administrator
- **System:** Ubuntu/Debian Server

---

## 📋 Installations-Anleitung

### 🔧 Schritt 1: Dateien auf Server übertragen

```bash
# Via SCP (von Ihrem lokalen Computer)
scp SERVER-INSTALLATION.sh root@212.227.57.238:/opt/
scp DEPLOY-STADTWACHE.sh root@212.227.57.238:/opt/

# Oder per SSH direkt auf Server erstellen
ssh root@212.227.57.238
cd /opt
# Dann Scripts manuell erstellen (siehe unten)
```

### 🚀 Schritt 2: System-Installation ausführen

```bash
# Als root auf dem Server
cd /opt
chmod +x SERVER-INSTALLATION.sh
./SERVER-INSTALLATION.sh
```

**Das Script installiert:**
- ✅ Node.js 18.x + Yarn
- ✅ Python 3 + pip + venv
- ✅ MongoDB 7.0
- ✅ Nginx (Reverse Proxy)
- ✅ Firewall (UFW)
- ✅ Systemd Services
- ✅ Benutzer "stadtwache"

### 📦 Schritt 3: Stadtwache-App deployen

```bash
# Als stadtwache-User
sudo -u stadtwache bash /opt/DEPLOY-STADTWACHE.sh
```

**Das Deployment-Script:**
- ✅ Erstellt Projekt-Struktur
- ✅ Installiert Python Dependencies
- ✅ Installiert Frontend Dependencies
- ✅ Initialisiert MongoDB
- ✅ Startet alle Services

---

## 🌐 Zugriff nach Installation

### **Frontend (Hauptseite):**
```
http://212.227.57.238
```

### **Backend API:**
```
http://212.227.57.238/api
```

### **API Dokumentation:**
```
http://212.227.57.238/api/docs
```

---

## 🔐 Standard-Login-Daten

### **Administrator:**
- **E-Mail:** admin@stadtwache.de
- **Passwort:** admin123
- **Berechtigung:** Vollzugriff

### **Wächter:**
- **E-Mail:** waechter@stadtwache.de
- **Passwort:** waechter123
- **Berechtigung:** Basis-Funktionen

---

## 🔧 Service-Verwaltung

### **Services prüfen:**
```bash
systemctl status stadtwache-backend
systemctl status stadtwache-frontend
systemctl status mongod
systemctl status nginx
```

### **Services neu starten:**
```bash
systemctl restart stadtwache-backend
systemctl restart stadtwache-frontend
```

### **Logs anzeigen:**
```bash
journalctl -u stadtwache-backend -f
journalctl -u stadtwache-frontend -f
```

---

## 📱 APK-Erstellung nach Installation

Nach erfolgreicher Installation können Sie APKs erstellen:

### **Option 1: HTML-zu-APK (Empfohlen)**
1. Besuchen Sie: https://appsgeyser.com/
2. Wählen Sie: "Website to App"
3. URL eingeben: `http://212.227.57.238`
4. APK generieren und herunterladen

### **Option 2: PWA-Installation**
1. Öffnen Sie `http://212.227.57.238` auf Android
2. Browser-Menü → "Zur Startseite hinzufügen"
3. App wird installiert

---

## 🛡️ Sicherheits-Konfiguration

### **Firewall-Status:**
```bash
ufw status verbose
```

### **Offene Ports:**
- **80** (HTTP - Nginx)
- **443** (HTTPS - für SSL später)
- **22** (SSH)
- **3000** (Frontend - temporär)
- **8001** (Backend API - temporär)

### **SSL/HTTPS aktivieren (Optional):**
```bash
# Certbot installieren
apt install certbot python3-certbot-nginx
# SSL-Zertifikat erstellen
certbot --nginx -d 212.227.57.238
```

---

## 🔍 Fehlerdiagnose

### **Backend läuft nicht:**
```bash
# Logs prüfen
journalctl -u stadtwache-backend
# Manuell starten
cd /opt/stadtwache
source venv/bin/activate
python backend/server.py
```

### **Frontend läuft nicht:**
```bash
# Logs prüfen
journalctl -u stadtwache-frontend
# Manuell starten
cd /opt/stadtwache/frontend
npm start
```

### **MongoDB-Probleme:**
```bash
# Status prüfen
systemctl status mongod
# Neustarten
systemctl restart mongod
```

### **Nginx-Probleme:**
```bash
# Konfiguration testen
nginx -t
# Neustarten
systemctl restart nginx
```

---

## 📊 Monitoring

### **System-Ressourcen:**
```bash
htop
df -h
free -m
```

### **Netzwerk:**
```bash
netstat -tulpn | grep -E ':(80|443|3000|8001|27017)'
```

### **Service-Status:**
```bash
systemctl list-units --state=running | grep stadtwache
```

---

## 🔄 Updates

### **System-Updates:**
```bash
apt update && apt upgrade -y
```

### **Stadtwache-Updates:**
```bash
# Services stoppen
systemctl stop stadtwache-backend stadtwache-frontend

# Code aktualisieren (wenn Git verwendet)
cd /opt/stadtwache
sudo -u stadtwache git pull

# Dependencies aktualisieren
sudo -u stadtwache bash -c "
source venv/bin/activate
pip install -r backend/requirements.txt
cd frontend && npm install
"

# Services starten
systemctl start stadtwache-backend stadtwache-frontend
```

---

## 📞 Support

Bei Problemen:

1. **Service-Logs prüfen**
2. **Firewall-Einstellungen überprüfen**
3. **MongoDB-Verbindung testen**
4. **Nginx-Konfiguration validieren**

**Wichtige Befehle:**
```bash
# Vollständiger Status-Check
systemctl status stadtwache-backend stadtwache-frontend mongod nginx
ufw status
curl -I http://localhost:8001/api/health
curl -I http://localhost:3000
```

---

## 🎯 Ergebnis

Nach erfolgreicher Installation haben Sie:

✅ **Vollständig funktionsfähige Stadtwache-App**  
✅ **Sichere Server-Konfiguration**  
✅ **Automatische Service-Verwaltung**  
✅ **Bereit für APK-Erstellung**  
✅ **Professionelles Deployment**  

**Ihre Stadtwache-App ist jetzt live unter:** `http://212.227.57.238` 🚀