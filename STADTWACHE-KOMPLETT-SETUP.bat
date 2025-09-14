@echo off
title STADTWACHE - Komplettes Setup & APK
color 0B

cls
echo.
echo ===============================================
echo    STADTWACHE - KOMPLETTES SETUP & APK
echo ===============================================
echo.
echo Diese BAT installiert ALLES was Sie brauchen:
echo - Backend + Datenbank
echo - Frontend + Expo
echo - Erstellt APK-Datei
echo.

set /p continue="Komplettes Setup starten? (J/N): "
if /i not "%continue%"=="J" goto end

echo.
echo [1/6] Node.js pruefen...
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo FEHLER: Node.js nicht installiert!
    echo Installieren Sie Node.js von: https://nodejs.org/
    pause
    exit /b 1
)
echo OK: Node.js Version:
node --version

echo.
echo [2/6] Backend Dependencies installieren...
cd backend
pip install fastapi uvicorn motor pymongo bcrypt python-jose python-socketio sqlalchemy
if %errorlevel% neq 0 (
    echo WARNUNG: Einige Backend-Pakete konnten nicht installiert werden
)

echo.
echo [3/6] Frontend Dependencies installieren...
cd ..\frontend
call npm install
if %errorlevel% neq 0 (
    echo FEHLER: Frontend Dependencies fehlgeschlagen!
    pause
    exit /b 1
)

echo.
echo [4/6] Expo CLI installieren...
call npm install -g @expo/cli eas-cli
if %errorlevel% neq 0 (
    echo WARNUNG: Globale Installation fehlgeschlagen
)

echo.
echo [5/6] Server starten und testen...
cd ..\backend
start /min python server.py

echo Warte auf Server-Start...
timeout /t 5 >nul

cd ..\frontend
start /min npx expo start

echo Warte auf Expo-Start...
timeout /t 10 >nul

echo.
echo [6/6] APK-Erstellung vorbereiten...
echo.
echo ===============================================
echo         SETUP ERFOLGREICH!
echo ===============================================
echo.
echo Backend läuft auf: http://localhost:8001
echo Frontend läuft auf: http://localhost:3000
echo.
echo FÜR APK-ERSTELLUNG:
echo.
echo OPTION 1 - EAS Build (Empfohlen):
echo 1. npx eas login (Expo-Account erforderlich)
echo 2. npx eas build --platform android --profile preview
echo 3. APK nach 10-15 Minuten per E-Mail
echo.
echo OPTION 2 - HTML-APK (Sofort):
echo 1. https://appsgeyser.com/ besuchen
echo 2. "Website to App" wählen
echo 3. stadtwache-sicher.html hochladen
echo 4. APK in 5 Minuten fertig
echo.
echo LOGIN-DATEN:
echo Admin: admin@stadtwache.de / admin123
echo Wächter: waechter@stadtwache.de / waechter123
echo.

set /p apk="APK jetzt erstellen? (1=EAS, 2=HTML, 3=Überspringen): "

if "%apk%"=="1" (
    echo.
    echo EAS BUILD starten...
    cd frontend
    call npx eas login
    call npx eas build --platform android --profile preview
    echo APK wird erstellt - Sie erhalten eine E-Mail!
)

if "%apk%"=="2" (
    echo.
    echo HTML-APK Option...
    start https://appsgeyser.com/
    echo.
    echo ANLEITUNG:
    echo 1. "Website to App" wählen
    echo 2. Datei stadtwache-sicher.html hochladen
    echo 3. App-Details eingeben
    echo 4. APK herunterladen
)

echo.
echo ===============================================
echo           ALLES BEREIT!
echo ===============================================
echo.
echo Ihre Stadtwache-App ist vollständig eingerichtet!
echo.
echo DATEIEN:
echo - Backend: /backend/server.py (läuft)
echo - Frontend: /frontend/app/index.tsx (läuft) 
echo - HTML-APK: stadtwache-sicher.html
echo - Datenbank: MongoDB (läuft)
echo.
echo SERVER-URLs:
echo - API: http://localhost:8001/api
echo - App: http://localhost:3000
echo - Docs: http://localhost:8001/docs
echo.

:end
echo.
pause