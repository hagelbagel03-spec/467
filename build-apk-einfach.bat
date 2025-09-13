@echo off
title Stadtwache - Einfacher APK Build
color 0C

echo.
echo ========================================
echo    STADTWACHE - EINFACHER APK BUILD
echo ========================================
echo.
echo Dieses Script erstellt eine APK-Datei 
echo der Stadtwache App mit minimalem Aufwand.
echo.

REM Prüfe Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [FEHLER] Node.js ist nicht installiert!
    echo.
    echo BITTE INSTALLIEREN:
    echo 1. Gehen Sie zu: https://nodejs.org/
    echo 2. Laden Sie die LTS-Version herunter
    echo 3. Installieren Sie mit Standard-Einstellungen
    echo 4. Starten Sie dieses Script neu
    echo.
    pause
    exit /b 1
)

echo [OK] Node.js gefunden: 
node --version
echo.

REM Wechsle in Frontend-Verzeichnis
cd /d "%~dp0\frontend"
if not exist "package.json" (
    echo [FEHLER] Frontend-Ordner nicht gefunden!
    echo Stellen Sie sicher, dass das Script im Hauptverzeichnis liegt.
    pause
    exit /b 1
)

echo [1/4] Installiere Expo CLI...
call npm install -g @expo/cli eas-cli
if %errorlevel% neq 0 (
    echo [WARNUNG] Globale Installation fehlgeschlagen, versuche lokal...
    call npx --yes @expo/cli --version
)

echo.
echo [2/4] Installiere App-Dependencies...
call npm install
if %errorlevel% neq 0 (
    echo [FEHLER] Dependencies konnten nicht installiert werden!
    pause
    exit /b 1
)

echo.
echo [3/4] Repariere Expo-Konfiguration...
call npx expo install --fix
if %errorlevel% neq 0 (
    echo [WARNUNG] Expo-Fix fehlgeschlagen, fahre trotzdem fort...
)

echo.
echo [4/4] Erstelle APK...
echo.
echo WICHTIG: Sie benoetigen einen kostenlosen Expo-Account!
echo Falls Sie noch keinen haben, erstellen Sie einen auf: https://expo.dev
echo.
set /p login="Moechten Sie sich jetzt anmelden? (J/N): "
if /i "%login%"=="J" (
    call npx eas login
    if %errorlevel% neq 0 (
        echo [FEHLER] Login fehlgeschlagen!
        pause
        exit /b 1
    )
)

echo.
echo Starte APK-Build (kann 10-15 Minuten dauern)...
echo.
call npx eas build --platform android --profile preview
if %errorlevel% neq 0 (
    echo.
    echo [FEHLER] Build fehlgeschlagen!
    echo.
    echo MOEGLICHE LOESUNGEN:
    echo 1. Internetverbindung pruefen
    echo 2. Expo-Account verifizieren
    echo 3. 'npx eas login' erneut ausfuehren
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo    APK ERFOLGREICH ERSTELLT!
echo ========================================
echo.
echo Die APK-Datei wurde in der Expo-Cloud erstellt.
echo Sie erhalten eine E-Mail mit dem Download-Link.
echo.
echo NAECHSTE SCHRITTE:
echo 1. APK-Datei herunterladen
echo 2. Auf Android-Geraet uebertragen
echo 3. "Unbekannte Quellen" aktivieren
echo 4. APK installieren
echo.
echo TIPP: Verwenden Sie 'npx expo start --tunnel' zum Testen
echo.
pause