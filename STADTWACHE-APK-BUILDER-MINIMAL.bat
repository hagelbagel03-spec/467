@echo off
title STADTWACHE APK BUILDER
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
call npm install -g @expo/cli eas-cli
if %errorlevel% neq 0 (
    echo WARNUNG: Globale Installation fehlgeschlagen
    echo Versuche lokale Installation...
)
echo.

echo [SCHRITT 5] Dependencies installieren...
call npm install
if %errorlevel% neq 0 (
    echo FEHLER: Dependencies konnten nicht installiert werden!
    pause
    exit /b 1
)

echo OK: Dependencies installiert
echo.

echo [SCHRITT 6] Expo konfigurieren...
call npx expo install --fix
echo.

echo ===============================================
echo            BUILD-OPTIONEN
echo ===============================================
echo.
echo 1. EAS Cloud Build (Empfohlen)
echo 2. Lokaler Build (Android Studio erforderlich)  
echo 3. Setup beenden
echo.
set /p choice="Waehlen Sie (1-3): "

if "%choice%"=="1" goto easBuild
if "%choice%"=="2" goto localBuild
if "%choice%"=="3" goto setupEnd
goto invalidChoice

:easBuild
echo.
echo EAS CLOUD BUILD wird gestartet...
echo.
echo WICHTIG: Sie benoetigen einen Expo-Account!
echo Wenn Sie noch keinen haben, erstellen Sie einen auf expo.dev
echo.
set /p continue="Fortfahren? (J/N): "
if /i not "%continue%"=="J" goto setupEnd

echo.
echo Anmeldung bei Expo...
call npx eas login
if %errorlevel% neq 0 (
    echo FEHLER: Anmeldung fehlgeschlagen!
    pause
    goto setupEnd
)

echo.
echo APK-Build wird gestartet...
echo Dies kann 10-15 Minuten dauern.
echo.
call npx eas build --platform android --profile preview
if %errorlevel% neq 0 (
    echo FEHLER: Build fehlgeschlagen!
    pause
    goto setupEnd
)

echo.
echo ===============================================
echo         BUILD ERFOLGREICH!
echo ===============================================
echo.
echo Ihre APK wurde erstellt!
echo Sie erhalten eine E-Mail mit dem Download-Link.
echo.
goto setupEnd

:localBuild
echo.
echo LOKALER BUILD wird gestartet...
echo.
echo WARNUNG: Benoetigt Android Studio und Android SDK!
echo.
set /p continue="Alle Tools installiert? (J/N): "
if /i not "%continue%"=="J" goto setupEnd

echo.
echo Prebuild...
call npx expo prebuild --platform android
if %errorlevel% neq 0 (
    echo FEHLER: Prebuild fehlgeschlagen!
    pause
    goto setupEnd
)

echo.
echo APK kompilieren...
call npx expo run:android --variant release
if %errorlevel% neq 0 (
    echo FEHLER: Kompilierung fehlgeschlagen!
    echo Versuchen Sie stattdessen Option 1 (EAS Build)
    pause
    goto setupEnd
)

echo.
echo ===============================================
echo         BUILD ERFOLGREICH!
echo ===============================================
echo.
goto setupEnd

:invalidChoice
echo FEHLER: Ungueltige Auswahl!
echo.
goto buildMenu

:buildMenu
echo ===============================================
echo            BUILD-OPTIONEN
echo ===============================================
echo.
echo 1. EAS Cloud Build (Empfohlen)
echo 2. Lokaler Build (Android Studio erforderlich)  
echo 3. Setup beenden
echo.
set /p choice="Waehlen Sie (1-3): "

if "%choice%"=="1" goto easBuild
if "%choice%"=="2" goto localBuild
if "%choice%"=="3" goto setupEnd
goto invalidChoice

:setupEnd
echo.
echo ===============================================
echo              FERTIG!
echo ===============================================
echo.
echo STANDARD-ZUGANGSDATEN:
echo Admin: admin@stadtwache.de / admin123
echo Demo:  waechter@stadtwache.de / waechter123
echo.
echo NUTZLICHE BEFEHLE:
echo npx expo start --tunnel  (App testen)
echo npx eas build --platform android --profile preview  (Neue APK)
echo.
echo Vielen Dank fuers Verwenden der Stadtwache App!
echo.
pause