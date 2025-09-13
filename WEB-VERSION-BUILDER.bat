@echo off
title STADTWACHE - Web Version Builder
color 0B

echo.
echo ===============================================
echo      STADTWACHE - WEB VERSION (PWA)
echo ===============================================
echo.
echo Progressive Web App - funktioniert wie native App!
echo.
echo VORTEILE:
echo + Keine APK noetig
echo + Funktioniert auf allen Geraeten
echo + Automatische Updates
echo + Offline-Funktionen
echo + Installierbar wie normale App
echo.

cd frontend

echo [SCHRITT 1] Dependencies pruefen...
if not exist "node_modules" (
    echo Dependencies installieren...
    call npm install
)

echo.
echo [SCHRITT 2] Web-Build erstellen...
call npx expo export --platform web

if %errorlevel% neq 0 (
    echo FEHLER: Web-Build fehlgeschlagen!
    pause
    exit /b 1
)

echo.
echo [SCHRITT 3] Web-Server starten...
echo.
echo Die Stadtwache-App laeuft jetzt unter:
echo http://localhost:3000
echo.
echo INSTALLATION AUF HANDY:
echo 1. Oeffnen Sie http://localhost:3000 im Browser
echo 2. Waehlen Sie "Zur Startseite hinzufuegen"
echo 3. App wird wie normale App installiert!
echo.
echo Web-Server laeuft... (Strg+C zum Beenden)
call npx expo start --web

pause