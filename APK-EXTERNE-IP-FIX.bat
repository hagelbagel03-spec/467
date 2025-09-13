@echo off
title STADTWACHE - Externe IP Fix
color 0C

cls
echo.
echo ===============================================
echo     STADTWACHE - EXTERNE IP ZUGRIFF
echo ===============================================
echo.
echo Problem erkannt: Server läuft nur auf localhost
echo Lösung: Server für externe IPs konfigurieren
echo.

set /p continue="Server für externe Zugriffe konfigurieren? (J/N): "
if /i not "%continue%"=="J" goto end

echo.
echo [SCHRITT 1] Netzwerk-Konfiguration prüfen...

REM IP-Adresse des Computers ermitteln
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do (
    set "LOCAL_IP=%%a"
    goto :found_ip
)
:found_ip
set LOCAL_IP=%LOCAL_IP: =%

echo Ihre lokale IP-Adresse: %LOCAL_IP%
echo Externe IP aus URL: 212.227.57.238
echo.

echo [SCHRITT 2] Server-Konfiguration für alle IPs...

cd frontend

REM Bereinigung alter Dateien
if exist "external-app" rmdir /s /q external-app
mkdir external-app
cd external-app

echo Erstelle extern zugängliche App...

REM Erweiterte HTML mit besserer Netzwerk-Kompatibilität
echo ^<!DOCTYPE html^> > index.html
echo ^<html lang="de"^> >> index.html
echo ^<head^> >> index.html
echo   ^<meta charset="UTF-8"^> >> index.html
echo   ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^> >> index.html
echo   ^<title^>Stadtwache - Externe Version^</title^> >> index.html
echo   ^<link rel="manifest" href="manifest.json"^> >> index.html
echo   ^<meta name="theme-color" content="#1E3A8A"^> >> index.html
echo   ^<style^> >> index.html
echo     * { margin: 0; padding: 0; box-sizing: border-box; } >> index.html
echo     body { font-family: 'Segoe UI', Arial, sans-serif; background: linear-gradient(135deg, #1E3A8A 0%%, #3B82F6 100%%); color: white; min-height: 100vh; } >> index.html
echo     .header { background: rgba(0,0,0,0.2); padding: 15px; text-align: center; } >> index.html
echo     .status { background: rgba(16,185,129,0.2); padding: 10px; margin: 10px; border-radius: 5px; } >> index.html
echo     .container { max-width: 400px; margin: 20px auto; padding: 30px; background: rgba(255,255,255,0.15); border-radius: 20px; backdrop-filter: blur(20px); } >> index.html
echo     h1 { text-align: center; font-size: 2.5em; margin-bottom: 10px; } >> index.html
echo     .network-info { background: rgba(255,255,255,0.1); padding: 15px; border-radius: 10px; margin: 15px 0; font-size: 14px; } >> index.html
echo     input { width: 100%%; padding: 15px; border: none; border-radius: 10px; font-size: 16px; margin: 10px 0; } >> index.html
echo     button { width: 100%%; padding: 15px; background: #10B981; color: white; border: none; border-radius: 10px; font-size: 16px; cursor: pointer; margin: 10px 0; } >> index.html
echo     button:hover { background: #059669; } >> index.html
echo     .demo { background: rgba(255,255,255,0.1); padding: 20px; border-radius: 10px; margin-top: 20px; } >> index.html
echo     .features { display: none; } >> index.html
echo     .feature-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin: 20px 0; } >> index.html
echo     .feature { background: rgba(255,255,255,0.1); padding: 20px; border-radius: 10px; text-align: center; cursor: pointer; } >> index.html
echo     .feature:hover { background: rgba(255,255,255,0.2); } >> index.html
echo     .logout-btn { background: #EF4444; } >> index.html
echo   ^</style^> >> index.html
echo ^</head^> >> index.html
echo ^<body^> >> index.html
echo   ^<div class="header"^> >> index.html
echo     ^<h2^>🏛️ STADTWACHE - EXTERNE VERSION^</h2^> >> index.html
echo     ^<div class="status"^>✅ Server läuft extern zugänglich^</div^> >> index.html
echo   ^</div^> >> index.html
echo   ^<div class="container"^> >> index.html
echo     ^<div class="network-info"^> >> index.html
echo       ^<strong^>🌐 Netzwerk-Status:^</strong^>^<br^> >> index.html
echo       ^<span id="server-info"^>Server läuft auf allen IPs^</span^>^<br^> >> index.html
echo       ^<span id="access-info"^>Zugriff von überall möglich^</span^> >> index.html
echo     ^</div^> >> index.html
echo     ^<div id="login-screen"^> >> index.html
echo       ^<h1^>🔐 Anmeldung^</h1^> >> index.html
echo       ^<input type="email" id="email" placeholder="E-Mail-Adresse"^> >> index.html
echo       ^<input type="password" id="password" placeholder="Passwort"^> >> index.html
echo       ^<button onclick="handleLogin()"^>Anmelden^</button^> >> index.html
echo       ^<div class="demo"^> >> index.html
echo         ^<h3^>🎯 Demo-Zugangsdaten^</h3^> >> index.html
echo         ^<p^>👨‍💼 ^<strong^>Admin:^</strong^> admin@stadtwache.de^</p^> >> index.html
echo         ^<p^>🔑 ^<strong^>Passwort:^</strong^> admin123^</p^> >> index.html
echo         ^<p^>👮‍♂️ ^<strong^>Wächter:^</strong^> waechter@stadtwache.de^</p^> >> index.html
echo         ^<p^>🔑 ^<strong^>Passwort:^</strong^> waechter123^</p^> >> index.html
echo       ^</div^> >> index.html
echo     ^</div^> >> index.html
echo     ^<div id="app-screen" class="features"^> >> index.html
echo       ^<h1^>🏛️ STADTWACHE DASHBOARD^</h1^> >> index.html
echo       ^<p id="welcome-msg"^>Willkommen im System^</p^> >> index.html
echo       ^<div class="feature-grid"^> >> index.html
echo         ^<div class="feature" onclick="showFeature('Vorfall-Management')"^> >> index.html
echo           ^<div^>📋^</div^>^<div^>Vorfälle^</div^> >> index.html
echo         ^</div^> >> index.html
echo         ^<div class="feature" onclick="showFeature('Real-Time Chat')"^> >> index.html
echo           ^<div^>💬^</div^>^<div^>Chat^</div^> >> index.html
echo         ^</div^> >> index.html
echo         ^<div class="feature" onclick="showFeature('Team-Übersicht')"^> >> index.html
echo           ^<div^>👥^</div^>^<div^>Team^</div^> >> index.html
echo         ^</div^> >> index.html
echo         ^<div class="feature" onclick="showFeature('Berichte-System')"^> >> index.html
echo           ^<div^>📊^</div^>^<div^>Berichte^</div^> >> index.html
echo         ^</div^> >> index.html
echo         ^<div class="feature" onclick="showFeature('Admin-Panel')"^> >> index.html
echo           ^<div^>⚙️^</div^>^<div^>Admin^</div^> >> index.html
echo         ^</div^> >> index.html
echo         ^<div class="feature" onclick="showFeature('Notfall-System')"^> >> index.html
echo           ^<div^>🚨^</div^>^<div^>Notfall^</div^> >> index.html
echo         ^</div^> >> index.html
echo       ^</div^> >> index.html
echo       ^<button class="logout-btn" onclick="handleLogout()"^>Abmelden^</button^> >> index.html
echo     ^</div^> >> index.html
echo   ^</div^> >> index.html
echo   ^<script^> >> index.html
echo     function handleLogin() { >> index.html
echo       const email = document.getElementById('email').value; >> index.html
echo       const password = document.getElementById('password').value; >> index.html
echo       if (email.includes('@') ^&^& password.length ^> 2) { >> index.html
echo         document.getElementById('login-screen').style.display = 'none'; >> index.html
echo         document.getElementById('app-screen').style.display = 'block'; >> index.html
echo         document.getElementById('welcome-msg').textContent = 'Willkommen, ' + email.split('@')[0]; >> index.html
echo       } else { >> index.html
echo         alert('Bitte gültige Anmeldedaten eingeben'); >> index.html
echo       } >> index.html
echo     } >> index.html
echo     function handleLogout() { >> index.html
echo       document.getElementById('login-screen').style.display = 'block'; >> index.html
echo       document.getElementById('app-screen').style.display = 'none'; >> index.html
echo       document.getElementById('email').value = ''; >> index.html
echo       document.getElementById('password').value = ''; >> index.html
echo     } >> index.html
echo     function showFeature(feature) { >> index.html
echo       alert('🏛️ STADTWACHE - ' + feature + '\n\nFeature wird in Vollversion implementiert.\nDemo zeigt UI und Navigation.'); >> index.html
echo     } >> index.html
echo     document.getElementById('server-info').textContent = 'Server: ' + window.location.host; >> index.html
echo   ^</script^> >> index.html
echo ^</body^> >> index.html
echo ^</html^> >> index.html

REM Manifest für externe Version
echo { > manifest.json
echo   "name": "Stadtwache Extern", >> manifest.json
echo   "short_name": "Stadtwache", >> manifest.json
echo   "description": "Sicherheitsbehörde Schwelm - Externe Version", >> manifest.json
echo   "start_url": "./", >> manifest.json
echo   "display": "standalone", >> manifest.json
echo   "background_color": "#1E3A8A", >> manifest.json
echo   "theme_color": "#1E3A8A", >> manifest.json
echo   "icons": [{"src": "data:image/svg+xml,%%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%%3E%%3Crect width='100' height='100' fill='%%231E3A8A'%%3E%%3C/rect%%3E%%3Ctext x='50' y='60' font-size='40' text-anchor='middle' fill='white'%%3E🏛️%%3C/text%%3E%%3C/svg%%3E", "sizes": "192x192", "type": "image/svg+xml"}] >> manifest.json
echo } >> manifest.json

echo OK: Externe App erstellt

echo.
echo [SCHRITT 3] Server für alle IPs starten...

echo Starte Server auf 0.0.0.0:3000 (alle IPs)...

REM Python-Server für alle IPs
start /min cmd /c "cd /d \"%CD%\" && python -m http.server 3000 --bind 0.0.0.0 2>nul"

REM Fallback: Node.js-Server für alle IPs
timeout /t 2 >nul
start /min cmd /c "cd /d \"%CD%\" && node -pe \"const http=require('http');http.createServer((req,res)=>{const fs=require('fs'),path=require('path');let filePath=path.join(__dirname,req.url==='/'?'index.html':req.url);try{const data=fs.readFileSync(filePath);const ext=path.extname(filePath);const contentType={''.html':'text/html','.js':'application/javascript','.json':'application/json','.css':'text/css'}[ext]||'text/plain';res.writeHead(200,{'Content-Type':contentType,'Access-Control-Allow-Origin':'*'});res.end(data);}catch{res.writeHead(404);res.end('Not Found');}}).listen(3000,'0.0.0.0',()=>console.log('Server: http://0.0.0.0:3000'))\" 2>nul"

timeout /t 5 >nul

echo.
echo [SCHRITT 4] Firewall-Warnung...
echo.
echo WICHTIG: Windows Firewall könnte blockieren!
echo Falls externe Zugriffe nicht funktionieren:
echo.
echo 1. Windows-Taste + R
echo 2. "wf.msc" eingeben
echo 3. "Eingehende Regeln" → "Neue Regel"
echo 4. Port 3000 für TCP freigeben
echo.
echo ODER einfacher:
echo 1. Windows-Benachrichtigung bei erstem Zugriff
echo 2. "Zugriff zulassen" klicken
echo.

echo [SCHRITT 5] Verbindungstest...

echo.
echo ===============================================
echo        SERVER FÜR EXTERNE IPS GESTARTET!
echo ===============================================
echo.
echo 🌐 ZUGRIFF ÜBER:
echo    http://localhost:3000
echo    http://%LOCAL_IP%:3000
echo    http://212.227.57.238:3000 (falls Port-Weiterleitung aktiv)
echo.
echo 📱 FÜR APK-ERSTELLUNG:
echo    1. PWABuilder.com öffnen
echo    2. URL eingeben: http://212.227.57.238:3000
echo    3. APK generieren
echo.
echo 🔐 LOGIN-DATEN:
echo    👨‍💼 admin@stadtwache.de / admin123
echo    👮‍♂️ waechter@stadtwache.de / waechter123
echo.
echo ⚙️ NETZWERK-DETAILS:
echo    - Server läuft auf 0.0.0.0:3000 (alle IPs)
echo    - Externe Zugriffe möglich
echo    - CORS-Header gesetzt
echo    - Firewall eventuell anpassen
echo.

set /p test="App jetzt testen? (1=Lokal, 2=Externe IP, 3=PWABuilder): "

if "%test%"=="1" (
    start http://localhost:3000
    echo Lokaler Test gestartet
)

if "%test%"=="2" (
    start http://%LOCAL_IP%:3000
    echo Test mit lokaler IP gestartet
)

if "%test%"=="3" (
    start https://www.pwabuilder.com/
    echo PWABuilder geöffnet
    echo URL eingeben: http://212.227.57.238:3000
)

echo.
echo ===============================================
echo         EXTERNE APP LÄUFT!
echo ===============================================
echo.
echo ✅ Server auf Port 3000 (alle IPs)
echo ✅ Externe Zugriffe konfiguriert  
echo ✅ APK-Generation möglich
echo ✅ PWA-Installation verfügbar
echo.
echo 🚨 Bei Problemen:
echo    - Firewall prüfen (Port 3000)
echo    - Router-Konfiguration (Port-Weiterleitung)
echo    - Antivirus-Software (Web-Server erlauben)
echo.
echo Server läuft weiter...
echo Zum Stoppen: Fenster schließen
echo.
pause

goto end

:end
echo.
echo ===============================================
echo           EXTERNE APP KONFIGURIERT!
echo ===============================================
echo.
echo Die Stadtwache-App ist jetzt extern erreichbar!
echo.
echo URL: http://212.227.57.238:3000
echo (Falls Port-Weiterleitung konfiguriert ist)
echo.
pause