@echo off
title STADTWACHE APK BUILDER - ROBUST
color 0A

echo.
echo ===============================================
echo       STADTWACHE APK BUILDER v1.0
echo    Sicherheitsbehoerde Schwelm - Mobile App
echo ===============================================
echo.

echo [SCHRITT 1] Node.js pruefen...
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo FEHLER: Node.js ist nicht installiert!
    echo Bitte installieren Sie Node.js von https://nodejs.org/
    pause
    exit /b 1
)

echo OK: Node.js gefunden
node --version
npm --version
echo.

echo [SCHRITT 2] Verzeichnis pruefen...
if not exist "frontend" (
    echo FEHLER: Frontend-Ordner nicht gefunden!
    echo Bitte fuehren Sie das Script im Hauptverzeichnis aus.
    pause
    exit /b 1
)

echo OK: App-Struktur gefunden
echo.

echo [SCHRITT 3] In Frontend-Verzeichnis wechseln...
cd frontend
echo Aktuelles Verzeichnis: %CD%
echo.

echo [SCHRITT 4] Expo CLI installieren...
echo Versuche globale Installation...

REM Erste Methode: Normale globale Installation
call npm install -g @expo/cli --verbose
if %errorlevel% equ 0 (
    echo OK: Expo CLI global installiert
    goto step5
)

echo Globale Installation fehlgeschlagen, versuche ohne -g...
REM Zweite Methode: Lokale Installation
call npm install @expo/cli
if %errorlevel% equ 0 (
    echo OK: Expo CLI lokal installiert
    goto step5
)

echo Warnung: Expo CLI Installation problematisch
echo Versuche trotzdem fortzufahren...

:step5
echo.
echo [SCHRITT 5] EAS CLI installieren...
call npm install -g eas-cli
if %errorlevel% neq 0 (
    echo Warnung: EAS CLI global nicht installiert
    echo Versuche lokale Installation...
    call npm install eas-cli
)
echo.

echo [SCHRITT 6] Dependencies installieren...
echo Dies kann einige Minuten dauern...
call npm install
if %errorlevel% neq 0 (
    echo FEHLER: Dependencies konnten nicht installiert werden!
    echo.
    echo Moegliche Loesungen:
    echo 1. Internetverbindung pruefen
    echo 2. npm cache clean --force
    echo 3. Als Administrator ausfuehren
    pause
    exit /b 1
)

echo OK: Dependencies installiert
echo.

echo [SCHRITT 7] Expo konfigurieren...
echo Pruefe Expo Installation...

REM Versuche npx expo
call npx expo --version
if %errorlevel% equ 0 (
    echo OK: Expo ueber npx verfuegbar
    call npx expo install --fix
) else (
    echo Expo ueber npx nicht verfuegbar
    echo Versuche direkten Aufruf...
    if exist "node_modules\.bin\expo.cmd" (
        call node_modules\.bin\expo install --fix
    ) else (
        echo Warnung: Expo nicht gefunden, ueberspringe Konfiguration
    )
)
echo.

echo ===============================================
echo            BUILD-OPTIONEN
echo ===============================================
echo.
echo 1. EAS Cloud Build (Empfohlen - benoetigt Expo Account)
echo 2. Nur Setup testen (Kein Build)
echo 3. Manuelle Befehle anzeigen
echo 4. Beenden
echo.
set /p choice="Waehlen Sie (1-4): "

if "%choice%"=="1" goto easBuild
if "%choice%"=="2" goto testSetup
if "%choice%"=="3" goto showCommands
if "%choice%"=="4" goto end
goto invalidChoice

:easBuild
echo.
echo ===============================================
echo         EAS CLOUD BUILD
echo ===============================================
echo.
echo WICHTIG: Sie benoetigen einen kostenlosen Expo-Account!
echo.
echo 1. Gehen Sie zu: https://expo.dev
echo 2. Erstellen Sie einen Account (falls noch nicht vorhanden)
echo 3. Bestaetigen Sie Ihre E-Mail-Adresse
echo.
set /p continue="Account bereit? Fortfahren? (J/N): "
if /i not "%continue%"=="J" goto showCommands

echo.
echo Anmeldung bei Expo...
call npx eas login
if %errorlevel% neq 0 (
    echo FEHLER: Anmeldung fehlgeschlagen!
    echo.
    echo Moegliche Ursachen:
    echo 1. Falsche E-Mail/Passwort
    echo 2. Account nicht verifiziert
    echo 3. Internetverbindung
    echo.
    pause
    goto showCommands
)

echo.
echo APK-Build wird gestartet...
echo WICHTIG: Dies dauert 10-15 Minuten!
echo Sie erhalten eine E-Mail mit dem Download-Link.
echo.
set /p startBuild="Build jetzt starten? (J/N): "
if /i not "%startBuild%"=="J" goto showCommands

call npx eas build --platform android --profile preview
if %errorlevel% neq 0 (
    echo.
    echo Build fehlgeschlagen oder abgebrochen.
    echo Sie koennen den Build spaeter wiederholen mit:
    echo npx eas build --platform android --profile preview
    echo.
    pause
    goto showCommands
)

echo.
echo ===============================================
echo         BUILD ERFOLGREICH GESTARTET!
echo ===============================================
echo.
echo Der Build laeuft jetzt in der Expo-Cloud.
echo Sie erhalten eine E-Mail mit dem Download-Link.
echo.
goto showCommands

:testSetup
echo.
echo ===============================================
echo         SETUP-TEST
echo ===============================================
echo.
echo Pruefe Installation...
call npx expo --version
echo.
call npx eas --version
echo.
echo Wenn beide Befehle Versionen anzeigen, ist das Setup OK!
echo.
goto showCommands

:showCommands
echo.
echo ===============================================
echo         NUTZLICHE BEFEHLE
echo ===============================================
echo.
echo APK erstellen:
echo   npx eas build --platform android --profile preview
echo.
echo App testen:
echo   npx expo start --tunnel
echo.
echo Anmeldung:
echo   npx eas login
echo.
echo STANDARD-ZUGANGSDATEN der App:
echo   Admin: admin@stadtwache.de / admin123
echo   Demo:  waechter@stadtwache.de / waechter123
echo.
goto end

:invalidChoice
echo FEHLER: Ungueltige Auswahl!
timeout /t 2 >nul
goto buildMenu

:buildMenu
echo ===============================================
echo            BUILD-OPTIONEN
echo ===============================================
echo.
echo 1. EAS Cloud Build (Empfohlen - benoetigt Expo Account)
echo 2. Nur Setup testen (Kein Build)
echo 3. Manuelle Befehle anzeigen
echo 4. Beenden
echo.
set /p choice="Waehlen Sie (1-4): "

if "%choice%"=="1" goto easBuild
if "%choice%"=="2" goto testSetup
if "%choice%"=="3" goto showCommands
if "%choice%"=="4" goto end
goto invalidChoice

:end
echo.
echo ===============================================
echo              FERTIG!
echo ===============================================
echo.
echo Vielen Dank fuers Verwenden der Stadtwache App!
echo.
pause