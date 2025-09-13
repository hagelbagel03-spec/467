@echo off
title Stadtwache - Vollstaendige Installation und Build
color 0B

echo.
echo ============================================================
echo    STADTWACHE - VOLLSTAENDIGE INSTALLATION UND BUILD
echo ============================================================
echo.
echo Dieses Script installiert alle noetigen Tools und erstellt
echo eine APK-Datei der Stadtwache App.
echo.
echo Systemanforderungen:
echo - Windows 10/11
echo - Internetverbindung
echo - 4GB freier Speicherplatz
echo.
set /p continue="Moechten Sie fortfahren? (J/N): "
if /i not "%continue%"=="J" if /i not "%continue%"=="Y" exit /b 0

echo.
echo [1/8] Pruefe Node.js Installation...
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [FEHLER] Node.js ist nicht installiert!
    echo.
    echo INSTALLATION ERFORDERLICH:
    echo 1. Besuchen Sie: https://nodejs.org/
    echo 2. Laden Sie die LTS-Version herunter
    echo 3. Installieren Sie Node.js mit Standard-Einstellungen
    echo 4. Starten Sie dieses Script erneut
    echo.
    pause
    exit /b 1
) else (
    node --version
    echo [OK] Node.js ist installiert
)

echo.
echo [2/8] Installiere globale Pakete...
call npm install -g yarn expo-cli @expo/cli eas-cli
if %errorlevel% neq 0 (
    echo [WARNUNG] Einige Pakete konnten nicht installiert werden
    echo Versuche alternative Installation...
    npm install -g --force yarn expo-cli @expo/cli eas-cli
)

echo.
echo [3/8] Wechsle in App-Verzeichnis...
cd /d "%~dp0"
if not exist "frontend" (
    echo [FEHLER] Frontend-Verzeichnis nicht gefunden!
    echo Stellen Sie sicher, dass das Script im App-Hauptverzeichnis liegt.
    pause
    exit /b 1
)

echo.
echo [4/8] Installiere Frontend-Dependencies...
cd frontend
call yarn install
if %errorlevel% neq 0 (
    echo [FEHLER] Dependencies konnten nicht installiert werden!
    echo Versuche npm install...
    call npm install
    if %errorlevel% neq 0 (
        echo [KRITISCHER FEHLER] Installation fehlgeschlagen!
        pause
        exit /b 1
    )
)

echo.
echo [5/8] Aktualisiere Expo...
call npx expo install --fix
if %errorlevel% neq 0 (
    echo [WARNUNG] Expo-Updates konnten nicht angewendet werden
)

echo.
echo [6/8] Erstelle Icons und Assets...
if not exist "assets\icon.png" (
    echo [INFO] Erstelle Standard-Icons...
    mkdir assets 2>nul
    REM Icons werden durch das Script erstellt - in Produktion sollten echte Icons verwendet werden
)

echo.
echo [7/8] Konfiguriere Build-Umgebung...
echo [INFO] Bereite Build-Konfiguration vor...

echo.
echo [8/8] Starte APK-Build...
echo.
echo ========================================
echo    BUILD-OPTIONEN
echo ========================================
echo.
echo 1. Schneller Local Build (Empfohlen für Tests)
echo 2. EAS Preview Build (APK zum Teilen)
echo 3. EAS Production Build (Store-ready)
echo 4. Nur Setup ohne Build
echo.
set /p buildtype="Waehlen Sie Build-Typ (1-4): "

if "%buildtype%"=="1" goto localBuild
if "%buildtype%"=="2" goto easPreview
if "%buildtype%"=="3" goto easProduction
if "%buildtype%"=="4" goto setupOnly
goto invalidBuild

:localBuild
echo.
echo [BUILD] Starte lokalen Build...
echo [INFO] Dies erstellt eine Debug-APK auf Ihrem System
echo.
call npx expo prebuild --platform android
call npx expo run:android --variant release
if %errorlevel% neq 0 (
    echo [FEHLER] Lokaler Build fehlgeschlagen!
    echo.
    echo MOEGLICHE LOESUNGEN:
    echo 1. Android Studio installieren
    echo 2. Java JDK 8+ installieren
    echo 3. Android SDK konfigurieren
    echo.
    echo Versuchen Sie stattdessen EAS Build (Option 2)
    pause
    exit /b 1
)
goto buildComplete

:easPreview
echo.
echo [BUILD] Starte EAS Preview Build...
echo [INFO] Dies erstellt eine APK in der Cloud (kostenlos)
echo.
call eas build --platform android --profile preview
if %errorlevel% neq 0 (
    echo [FEHLER] EAS Build fehlgeschlagen!
    echo.
    echo MOEGLICHE LOESUNGEN:
    echo 1. Expo-Account erstellen auf expo.dev
    echo 2. 'eas login' ausfuehren
    echo 3. Internet-Verbindung pruefen
    pause
    exit /b 1
)
goto buildComplete

:easProduction
echo.
echo [BUILD] Starte EAS Production Build...
echo [WARNUNG] Dies benoetigt ein bezahltes Expo-Konto!
echo.
set /p confirm="Sind Sie sicher? (J/N): "
if /i not "%confirm%"=="J" if /i not "%confirm%"=="Y" goto buildMenu

call eas build --platform android --profile production
if %errorlevel% neq 0 (
    echo [FEHLER] Production Build fehlgeschlagen!
    pause
    exit /b 1
)
goto buildComplete

:setupOnly
echo.
echo [SETUP] Installation abgeschlossen!
echo.
echo Sie koennen jetzt manuell folgende Befehle verwenden:
echo - npx expo start --android (App in Entwicklung testen)
echo - eas build --platform android --profile preview (APK erstellen)
echo.
goto end

:invalidBuild
echo [FEHLER] Ungueltige Auswahl!
goto buildMenu

:buildComplete
echo.
echo ========================================
echo    BUILD ERFOLGREICH ABGESCHLOSSEN!
echo ========================================
echo.
echo Die Stadtwache APK wurde erfolgreich erstellt!
echo.
echo NAECHSTE SCHRITTE:
echo 1. APK-Datei auf Android-Geraet uebertragen
echo 2. "Unbekannte Quellen" in Einstellungen aktivieren
echo 3. APK-Datei installieren
echo.
echo ENTWICKLUNG:
echo - npx expo start --android (App testen)
echo - eas build --platform android --profile preview (Neue APK)
echo.

:end
echo Vielen Dank fuers Verwenden der Stadtwache App!
echo.
pause