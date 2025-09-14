#!/bin/bash
# STADTWACHE - Deployment Script
# Deployt die komplette Anwendung nach der System-Installation

set -e

echo "=============================================="
echo "  🚀 STADTWACHE - DEPLOYMENT"
echo "      Server: 212.227.57.238"
echo "      Code-Deployment & Setup"
echo "=============================================="
echo

# Farben
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[DEPLOY]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Arbeitsverzeichnis
WORKDIR="/opt/stadtwache"
CURRENT_USER=$(whoami)

# Prüfe ob als stadtwache-User ausgeführt
if [[ "$CURRENT_USER" != "stadtwache" ]]; then
    error "Dieses Script muss als 'stadtwache' User ausgeführt werden!"
    echo "Verwenden Sie: sudo -u stadtwache bash $0"
    exit 1
fi

# In Arbeitsverzeichnis wechseln
cd $WORKDIR

# Git-Repository klonen (oder Code kopieren)
deploy_code() {
    log "Stadtwache-Code wird deployed..."
    
    # Falls Git verfügbar ist, Repository klonen
    if command -v git &> /dev/null; then
        if [[ -d ".git" ]]; then
            log "Repository wird aktualisiert..."
            git pull
        else
            log "Repository wird geklont..."
            # Hier würden Sie Ihr Repository klonen
            # git clone https://github.com/ihr-username/stadtwache.git .
            
            # Für jetzt erstellen wir die Struktur manuell
            create_project_structure
        fi
    else
        create_project_structure
    fi
}

# Projekt-Struktur erstellen
create_project_structure() {
    log "Projekt-Struktur wird erstellt..."
    
    # Backend-Verzeichnis
    mkdir -p backend
    mkdir -p frontend
    
    # Backend-Code (vereinfacht)
    cat > backend/server.py << 'EOF'
#!/usr/bin/env python3
"""
Stadtwache Backend Server
FastAPI + MongoDB für Sicherheitsbehörde Schwelm
"""

from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import motor.motor_asyncio
from passlib.context import CryptContext
from jose import JWTError, jwt
from datetime import datetime, timedelta
import os
from typing import Optional
import uvicorn

# Konfiguration
SECRET_KEY = "stadtwache-secret-key-schwelm-2024"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# MongoDB
MONGO_URL = "mongodb://localhost:27017"
DATABASE_NAME = "stadtwache"

# FastAPI App
app = FastAPI(
    title="Stadtwache API",
    description="API für Sicherheitsbehörde Schwelm",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Security
security = HTTPBearer()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# MongoDB Client
client = motor.motor_asyncio.AsyncIOMotorClient(MONGO_URL)
db = client[DATABASE_NAME]

@app.on_event("startup")
async def startup_db_client():
    print(f"🔗 Connected to MongoDB: {MONGO_URL}")

@app.on_event("shutdown") 
async def shutdown_db_client():
    client.close()

# Basis-Routen
@app.get("/")
async def root():
    return {
        "message": "Stadtwache API",
        "server": "212.227.57.238",
        "status": "online",
        "version": "1.0.0"
    }

@app.get("/api/health")
async def health_check():
    return {"status": "healthy", "timestamp": datetime.utcnow()}

# Auth-Routen
@app.post("/api/auth/login")
async def login(credentials: dict):
    email = credentials.get("email")
    password = credentials.get("password")
    
    # Demo-Authentication
    if email == "admin@stadtwache.de" and password == "admin123":
        token = jwt.encode(
            {"sub": email, "exp": datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)},
            SECRET_KEY,
            algorithm=ALGORITHM
        )
        return {
            "access_token": token,
            "token_type": "bearer",
            "user": {"email": email, "role": "admin"}
        }
    elif email == "waechter@stadtwache.de" and password == "waechter123":
        token = jwt.encode(
            {"sub": email, "exp": datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)},
            SECRET_KEY,
            algorithm=ALGORITHM
        )
        return {
            "access_token": token,
            "token_type": "bearer", 
            "user": {"email": email, "role": "waechter"}
        }
    else:
        raise HTTPException(status_code=401, detail="Invalid credentials")

# API-Routen
@app.get("/api/incidents")
async def get_incidents():
    return [
        {"id": 1, "title": "Demo Vorfall 1", "status": "open"},
        {"id": 2, "title": "Demo Vorfall 2", "status": "in_progress"},
        {"id": 3, "title": "Demo Vorfall 3", "status": "resolved"}
    ]

@app.get("/api/team")
async def get_team():
    return [
        {"email": "admin@stadtwache.de", "status": "online", "role": "admin"},
        {"email": "waechter@stadtwache.de", "status": "on_patrol", "role": "waechter"}
    ]

@app.get("/api/chat/messages")
async def get_messages():
    return [
        {"sender": "admin@stadtwache.de", "message": "System ist online", "timestamp": datetime.utcnow()},
        {"sender": "waechter@stadtwache.de", "message": "Schicht begonnen", "timestamp": datetime.utcnow()}
    ]

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)
EOF

    # Requirements.txt
    cat > backend/requirements.txt << 'EOF'
fastapi==0.104.1
uvicorn[standard]==0.24.0
motor==3.3.1
pymongo==4.5.0
passlib[bcrypt]==1.7.4
python-jose[cryptography]==3.3.0
python-multipart==0.0.6
EOF

    # Frontend package.json (vereinfacht)
    cat > frontend/package.json << 'EOF'
{
  "name": "stadtwache-frontend",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node server.js",
    "dev": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5"
  }
}
EOF

    # Einfacher Express Server für Frontend
    cat > frontend/server.js << 'EOF'
const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.static('public'));

// Hauptroute
app.get('/', (req, res) => {
    res.send(`
    <!DOCTYPE html>
    <html>
    <head>
        <title>Stadtwache Schwelm</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            body { font-family: Arial; background: #1E3A8A; color: white; margin: 0; padding: 20px; }
            .container { max-width: 400px; margin: 0 auto; background: rgba(255,255,255,0.1); padding: 30px; border-radius: 15px; }
            h1 { text-align: center; }
            .status { background: rgba(16,185,129,0.3); padding: 10px; border-radius: 5px; margin: 10px 0; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🏛️ STADTWACHE</h1>
            <p>Sicherheitsbehörde Schwelm</p>
            <div class="status">✅ Server online: 212.227.57.238</div>
            <div class="status">🔗 API: <a href="/api/docs" style="color: #10B981;">/api/docs</a></div>
            <div class="status">👤 Demo-Login verfügbar</div>
            <p><strong>Login-Daten:</strong></p>
            <p>👨‍💼 Admin: admin@stadtwache.de / admin123</p>
            <p>👮‍♂️ Wächter: waechter@stadtwache.de / waechter123</p>
        </div>
    </body>
    </html>
    `);
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(\`🚀 Stadtwache Frontend läuft auf Port \${PORT}\`);
    console.log(\`📱 Zugriff: http://212.227.57.238:\${PORT}\`);
});
EOF

    log "Projekt-Struktur erstellt"
}

# Python Virtual Environment erstellen
setup_python_env() {
    log "Python Virtual Environment wird erstellt..."
    
    cd $WORKDIR
    python3 -m venv venv
    source venv/bin/activate
    
    # Backend Dependencies installieren
    pip install --upgrade pip
    pip install -r backend/requirements.txt
    
    log "Python Environment konfiguriert"
}

# Frontend Dependencies installieren
setup_frontend() {
    log "Frontend Dependencies werden installiert..."
    
    cd $WORKDIR/frontend
    npm install
    
    log "Frontend Dependencies installiert"
}

# Datenbank initialisieren
init_database() {
    log "Datenbank wird initialisiert..."
    
    cd $WORKDIR
    source venv/bin/activate
    
    # Einfaches DB-Init Script
    python3 -c "
import asyncio
import motor.motor_asyncio
from passlib.context import CryptContext
from datetime import datetime

async def init_db():
    client = motor.motor_asyncio.AsyncIOMotorClient('mongodb://localhost:27017')
    db = client['stadtwache']
    
    # Test der Verbindung
    try:
        await client.admin.command('ping')
        print('✅ MongoDB Verbindung erfolgreich')
        
        # Standard-User erstellen
        users = db.users
        pwd_context = CryptContext(schemes=['bcrypt'], deprecated='auto')
        
        admin_user = {
            'email': 'admin@stadtwache.de',
            'password_hash': pwd_context.hash('admin123'),
            'role': 'admin',
            'created_at': datetime.utcnow()
        }
        
        waechter_user = {
            'email': 'waechter@stadtwache.de', 
            'password_hash': pwd_context.hash('waechter123'),
            'role': 'waechter',
            'created_at': datetime.utcnow()
        }
        
        await users.insert_one(admin_user)
        await users.insert_one(waechter_user)
        
        print('✅ Standard-Benutzer erstellt')
        
    except Exception as e:
        print(f'❌ Fehler: {e}')
    finally:
        client.close()

asyncio.run(init_db())
"
    
    log "Datenbank initialisiert"
}

# Services starten
start_services() {
    log "Services werden gestartet..."
    
    # Backend starten
    sudo systemctl start stadtwache-backend
    sudo systemctl start stadtwache-frontend
    
    # Status prüfen
    sleep 3
    sudo systemctl status stadtwache-backend --no-pager
    sudo systemctl status stadtwache-frontend --no-pager
    
    log "Services gestartet"
}

# Hauptfunktion
main() {
    log "Starte Stadtwache-Deployment..."
    
    log "1/6 Code-Deployment..."
    deploy_code
    
    log "2/6 Python Environment..."
    setup_python_env
    
    log "3/6 Frontend Setup..."
    setup_frontend
    
    log "4/6 Datenbank initialisieren..."
    init_database
    
    log "5/6 Services starten..."
    start_services
    
    echo
    echo "=============================================="
    echo "  🎉 DEPLOYMENT ABGESCHLOSSEN!"
    echo "=============================================="
    echo
    echo "✅ Stadtwache erfolgreich deployed!"
    echo
    echo "🌐 ZUGRIFF:"
    echo "   Frontend: http://212.227.57.238"
    echo "   Backend:  http://212.227.57.238/api"
    echo "   API Docs: http://212.227.57.238/api/docs"
    echo
    echo "🔐 LOGIN-DATEN:"
    echo "   👨‍💼 Admin: admin@stadtwache.de / admin123"
    echo "   👮‍♂️ Wächter: waechter@stadtwache.de / waechter123"
    echo
    echo "🔧 SERVICE-VERWALTUNG:"
    echo "   sudo systemctl status stadtwache-backend"
    echo "   sudo systemctl status stadtwache-frontend"
    echo "   sudo systemctl restart stadtwache-backend"
    echo "   sudo systemctl restart stadtwache-frontend"
    echo
    echo "📱 APK kann jetzt erstellt werden mit:"
    echo "   URL: http://212.227.57.238"
    echo
}

# Script ausführen
main "$@"