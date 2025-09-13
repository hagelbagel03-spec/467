@echo off
title STADTWACHE - Finale APK Lösung
color 0A

echo.
echo ===============================================
echo    STADTWACHE - FINALE APK LÖSUNG
echo ===============================================
echo.
echo EAS Build Probleme erkannt - Alternative Lösung:
echo.

echo [LÖSUNG 1] HTML-APK (Funktioniert sofort)
echo 1. Öffnen Sie: https://appsgeyser.com/
echo 2. Wählen Sie: "Website to App"
echo 3. Laden Sie hoch: stadtwache-sicher.html
echo 4. APK herunterladen (5 Minuten)
echo.
echo [LÖSUNG 2] Expo Development Build
echo 1. Installieren Sie: Expo Go App
echo 2. Scannen Sie QR-Code
echo 3. App direkt testen
echo.
echo [LÖSUNG 3] PWA Installation  
echo 1. Öffnen Sie: stadtwache-sicher.html im Browser
echo 2. "Zur Startseite hinzufügen"
echo 3. App wie native nutzen
echo.

set /p choice="Welche Lösung? (1-3): "

if "%choice%"=="1" (
    start https://appsgeyser.com/
    echo HTML-Datei: stadtwache-sicher.html verwenden!
)

if "%choice%"=="2" (
    cd frontend
    start npx expo start --tunnel
    echo QR-Code scannen mit Expo Go App
)

if "%choice%"=="3" (
    cd frontend
    start python -m http.server 8080
    timeout /t 2
    start http://localhost:8080/stadtwache-sicher.html
    echo PWA-Installation möglich
)

echo.
echo ===============================================
echo         APK-ALTERNATIVE BEREIT!
echo ===============================================
echo.
echo SERVER: 212.227.57.238:8001
echo LOGIN: admin@stadtwache.de / admin123
echo LOGIN: waechter@stadtwache.de / waechter123
echo.
pause