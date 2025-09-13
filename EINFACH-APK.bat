@echo off
title Stadtwache - Einfach APK
color 0A

echo.
echo ===============================================
echo      STADTWACHE - EINFACHE APK LÖSUNG
echo ===============================================
echo.

echo Erstelle einfache App...

cd frontend

if not exist "simple" mkdir simple
cd simple

echo Erstelle HTML-App...

echo ^<!DOCTYPE html^> > app.html
echo ^<html^> >> app.html
echo ^<head^> >> app.html
echo ^<title^>Stadtwache^</title^> >> app.html
echo ^<meta name="viewport" content="width=device-width, initial-scale=1"^> >> app.html
echo ^<style^> >> app.html
echo body{font-family:Arial;background:#1E3A8A;color:white;margin:0;padding:20px} >> app.html
echo .container{max-width:400px;margin:0 auto;background:rgba(255,255,255,0.1);padding:30px;border-radius:15px} >> app.html
echo h1{text-align:center;margin-bottom:20px} >> app.html
echo input{width:100%%;padding:15px;margin:10px 0;border:none;border-radius:8px;font-size:16px} >> app.html
echo button{width:100%%;padding:15px;background:#10B981;color:white;border:none;border-radius:8px;font-size:16px;cursor:pointer;margin:10px 0} >> app.html
echo button:hover{background:#059669} >> app.html
echo .demo{background:rgba(255,255,255,0.1);padding:15px;border-radius:8px;margin-top:15px} >> app.html
echo .features{display:none} >> app.html
echo .feature{background:rgba(255,255,255,0.1);padding:20px;margin:10px 0;border-radius:8px;text-align:center;cursor:pointer} >> app.html
echo .feature:hover{background:rgba(255,255,255,0.2)} >> app.html
echo ^</style^> >> app.html
echo ^</head^> >> app.html
echo ^<body^> >> app.html
echo ^<div class="container"^> >> app.html
echo ^<div id="login"^> >> app.html
echo ^<h1^>🏛️ STADTWACHE^</h1^> >> app.html
echo ^<p^>Sicherheitsbehörde Schwelm^</p^> >> app.html
echo ^<input type="email" id="email" placeholder="E-Mail"^> >> app.html
echo ^<input type="password" id="password" placeholder="Passwort"^> >> app.html
echo ^<button onclick="login()"^>Anmelden^</button^> >> app.html
echo ^<div class="demo"^> >> app.html
echo ^<h3^>Demo-Accounts:^</h3^> >> app.html
echo ^<p^>Admin: admin@stadtwache.de / admin123^</p^> >> app.html
echo ^<p^>Wächter: waechter@stadtwache.de / waechter123^</p^> >> app.html
echo ^</div^> >> app.html
echo ^</div^> >> app.html
echo ^<div id="app" class="features"^> >> app.html
echo ^<h1^>Stadtwache Dashboard^</h1^> >> app.html
echo ^<p id="welcome"^>Willkommen^</p^> >> app.html
echo ^<div class="feature" onclick="alert('Vorfall-Management: Vorfälle melden und verwalten')"^>📋 Vorfälle^</div^> >> app.html
echo ^<div class="feature" onclick="alert('Real-Time Chat: Live-Kommunikation zwischen Wächtern')"^>💬 Chat^</div^> >> app.html
echo ^<div class="feature" onclick="alert('Team-Übersicht: Status und Standort von Kollegen')"^>👥 Team^</div^> >> app.html
echo ^<div class="feature" onclick="alert('Berichte-System: Schichtberichte erstellen')"^>📊 Berichte^</div^> >> app.html
echo ^<div class="feature" onclick="alert('Admin-Panel: Benutzerverwaltung')"^>⚙️ Admin^</div^> >> app.html
echo ^<div class="feature" onclick="alert('Notfall-System: Schnelle Hilfe anfordern')"^>🚨 Notfall^</div^> >> app.html
echo ^<button onclick="logout()"^>Abmelden^</button^> >> app.html
echo ^</div^> >> app.html
echo ^</div^> >> app.html
echo ^<script^> >> app.html
echo function login(){var e=document.getElementById('email').value;var p=document.getElementById('password').value;if(e.includes('@')^&^&p.length^>0){document.getElementById('login').style.display='none';document.getElementById('app').style.display='block';document.getElementById('welcome').textContent='Willkommen, '+e.split('@')[0]}else{alert('Bitte E-Mail und Passwort eingeben')}} >> app.html
echo function logout(){document.getElementById('login').style.display='block';document.getElementById('app').style.display='none';document.getElementById('email').value='';document.getElementById('password').value=''} >> app.html
echo ^</script^> >> app.html
echo ^</body^> >> app.html
echo ^</html^> >> app.html

echo OK: HTML-App erstellt

echo.
echo Starte Server...
start /min python -m http.server 8080

timeout /t 3

echo.
echo ===============================================
echo         APP ERFOLGREICH ERSTELLT!
echo ===============================================
echo.
echo IHRE STADTWACHE-APP:
echo URL: http://localhost:8080/app.html
echo.
echo LOGIN-DATEN:
echo admin@stadtwache.de / admin123
echo waechter@stadtwache.de / waechter123
echo.
echo APK ERSTELLEN:
echo 1. https://appsgeyser.com/ öffnen
echo 2. "Website to App" wählen
echo 3. URL eingeben: http://localhost:8080/app.html
echo 4. APK herunterladen
echo.
echo ALTERNATIVE:
echo 1. app.html Datei auf Handy kopieren
echo 2. Im Browser öffnen
echo 3. "Zur Startseite hinzufügen"
echo.

set /p open="App jetzt öffnen? (J/N): "
if /i "%open%"=="J" start http://localhost:8080/app.html

echo.
echo ===============================================
echo              FERTIG!
echo ===============================================
echo.
echo Ihre Stadtwache-App läuft!
echo Datei: frontend/simple/app.html
echo Server: http://localhost:8080/app.html
echo.
pause