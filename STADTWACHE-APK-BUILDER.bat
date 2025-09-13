@echo off
title STADTWACHE APK BUILDER - v1.0
color 0E

cls
echo.
echo  ██████████████████████████████████████████████████████████
echo  █                                                        █
echo  █              STADTWACHE APK BUILDER v1.0               █
echo  █          Sicherheitsbehörde Schwelm - Mobile App       █
echo  █                                                        █
echo  ██████████████████████████████████████████████████████████
echo.
echo  🏛️  Professionelle Stadtwache-App für Sicherheitskräfte
echo  📱  Erstellt optimierte APK-Dateien für Android
echo  🔧  Automatische Installation aller Dependencies
echo.
echo ========================================================
echo.

REM Admin-Rechte prüfen
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  WICHTIG: Dieses Script sollte als Administrator ausgeführt werden
    echo    für beste Kompatibilität.
    echo.
    timeout /t 3 >nul
)

REM Systemvoraussetzungen prüfen
echo [SCHRITT 1/6] 🔍 Systemvoraussetzungen prüfen...
echo.

REM Node.js prüfen
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Node.js ist nicht installiert!
    echo.
    echo 📥 AUTOMATISCHE INSTALLATION EMPFOHLEN:
    echo    1. Laden Sie Node.js LTS von https://nodejs.org/ herunter
    echo    2. Installieren Sie es mit Standard-Einstellungen
    echo    3. Starten Sie Ihren Computer neu
    echo    4. Führen Sie dieses Script erneut aus
    echo.
    echo ⏸️  Script pausiert für Node.js Installation...
    pause
    exit /b 1
) else (
    echo ✅ Node.js gefunden: 
    node --version
    npm --version
    echo.
)

REM Git prüfen (optional)
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo ⚠️  Git nicht gefunden (optional, aber empfohlen)
    echo    Download: https://git-scm.com/download/win
) else (
    echo ✅ Git gefunden: 
    git --version
)

echo.
echo [SCHRITT 2/6] 📁 Arbeitsverzeichnis vorbereiten...

REM Ins App-Verzeichnis wechseln
cd /d "%~dp0"
if not exist "frontend" (
    echo ❌ Frontend-Ordner nicht gefunden!
    echo    Stellen Sie sicher, dass das Script im Haupt-App-Verzeichnis liegt.
    echo    Erwartete Struktur:
    echo    - frontend/
    echo    - backend/
    echo    - *.bat
    echo.
    pause
    exit /b 1
)

echo ✅ App-Struktur gefunden
echo    📂 Frontend: %CD%\frontend
echo    📂 Backend: %CD%\backend

echo.
echo [SCHRITT 3/6] 🚀 Expo-Umgebung einrichten...

REM Globale Tools installieren
echo 🔧 Installiere Expo CLI...
call npm install -g @expo/cli eas-cli --silent
if %errorlevel% neq 0 (
    echo ⚠️  Globale Installation fehlgeschlagen, verwende lokale Version...
    echo    Dies ist normal und kein Problem.
)

REM In Frontend-Verzeichnis wechseln
cd frontend

echo.
echo [SCHRITT 4/6] 📦 App-Dependencies installieren...
echo    Dies kann 2-3 Minuten dauern...

REM Package Manager erkennen
if exist "yarn.lock" (
    echo 🧶 Verwende Yarn...
    call yarn install --silent
    set "pkg_manager=yarn"
) else (
    echo 📦 Verwende NPM...
    call npm install --silent
    set "pkg_manager=npm"
)

if %errorlevel% neq 0 (
    echo ❌ Dependencies-Installation fehlgeschlagen!
    echo.
    echo 🔧 FEHLERBEHEBUNG:
    echo    1. Internetverbindung prüfen
    echo    2. Cache leeren: npm cache clean --force
    echo    3. node_modules löschen und neu installieren
    echo.
    pause
    exit /b 1
)

echo ✅ Dependencies erfolgreich installiert

echo.
echo [SCHRITT 5/6] ⚙️  Expo-Konfiguration optimieren...

REM Expo-Pakete reparieren
call npx expo install --fix --silent
if %errorlevel% neq 0 (
    echo ⚠️  Expo-Fix mit Warnungen abgeschlossen (normalerweise nicht kritisch)
) else (
    echo ✅ Expo-Konfiguration optimiert
)

echo.
echo [SCHRITT 6/6] 🏗️  APK-Build starten...
echo.
echo ┌─────────────────────────────────────────────────────────┐
echo │                   BUILD-OPTIONEN                        │
echo └─────────────────────────────────────────────────────────┘
echo.
echo   1️⃣  EAS Cloud Build (EMPFOHLEN)
echo      🌐 Build in der Cloud (kostenlos)
echo      ⏱️  10-15 Minuten
echo      📧 APK per E-Mail
echo      ✅ Immer funktionsfähig
echo.
echo   2️⃣  Lokaler Build (Experten)
echo      💻 Build auf diesem Computer
echo      ⏱️  5-10 Minuten
echo      ⚠️  Benötigt Android Studio
echo      📱 APK direkt verfügbar
echo.
echo   3️⃣ Development Build (Testing)
echo      🧪 Für Entwickler und Tests
echo      🔍 Mit Debug-Informationen
echo      📲 Sofortiges Testing möglich
echo.
echo   4️⃣  Setup beenden (ohne Build)
echo      ⏸️  Installation komplett
echo      🔧 Manuelle Builds möglich
echo.

set /p choice="➤ Wählen Sie eine Option (1-4): "
echo.

if "%choice%"=="1" goto cloudBuild
if "%choice%"=="2" goto localBuild
if "%choice%"=="3" goto devBuild
if "%choice%"=="4" goto setupComplete
goto invalidChoice

:cloudBuild
echo 🌐 STARTE EAS CLOUD BUILD...
echo.
echo ⚠️  WICHTIG: Sie benötigen einen kostenlosen Expo-Account!
echo    📝 Registrierung auf: https://expo.dev
echo.

set /p hasAccount="Haben Sie bereits einen Expo-Account? (J/N): "
if /i "%hasAccount%"=="N" (
    echo.
    echo 📝 ACCOUNT ERSTELLEN:
    echo    1. Besuchen Sie: https://expo.dev
    echo    2. Klicken Sie auf "Sign Up"  
    echo    3. Erstellen Sie Ihren kostenlosen Account
    echo    4. Bestätigen Sie Ihre E-Mail-Adresse
    echo.
    echo ⏸️  Script pausiert für Account-Erstellung...
    pause
)

echo.
echo 🔐 ANMELDUNG BEI EXPO...
call npx eas login
if %errorlevel% neq 0 (
    echo ❌ Anmeldung fehlgeschlagen!
    echo.
    echo 🔧 FEHLERBEHEBUNG:
    echo    1. E-Mail und Passwort korrekt eingeben
    echo    2. Account auf expo.dev verifiziert?
    echo    3. Internetverbindung prüfen
    echo.
    pause
    exit /b 1
)

echo.
echo 🏗️  APK-BUILD GESTARTET...
echo    ⏱️  Dies dauert normalerweise 10-15 Minuten
echo    📧 Sie erhalten eine E-Mail mit dem Download-Link
echo    ☕ Zeit für einen Kaffee!
echo.

call npx eas build --platform android --profile preview
if %errorlevel% neq 0 (
    echo ❌ Cloud-Build fehlgeschlagen!
    echo.
    echo 🔧 HÄUFIGE LÖSUNGEN:
    echo    1. Internetverbindung stabil?
    echo    2. Expo-Account korrekt verifiziert?
    echo    3. Versuchen Sie: npx eas build --platform android --profile preview --clear-cache
    echo.
    pause
    exit /b 1
)

goto buildSuccess

:localBuild
echo 💻 STARTE LOKALEN BUILD...
echo.
echo ⚠️  VORAUSSETZUNGEN:
echo    - Android Studio installiert
echo    - Android SDK konfiguriert
echo    - Java JDK 8 oder höher
echo.

set /p continueLocal="Alle Voraussetzungen erfüllt? (J/N): "
if /i "%continueLocal%"=="N" (
    echo.
    echo 📥 ANDROID STUDIO SETUP:
    echo    1. Download: https://developer.android.com/studio
    echo    2. Installieren mit Standard-Einstellungen
    echo    3. SDK Tools installieren lassen
    echo    4. ANDROID_HOME Umgebungsvariable setzen
    echo.
    pause
    exit /b 1
)

echo.
echo 🔧 VORBEREITE ANDROID-BUILD...
call npx expo prebuild --platform android
if %errorlevel% neq 0 (
    echo ❌ Prebuild fehlgeschlagen!
    pause
    exit /b 1
)

echo 🏗️  KOMPILIERE APK...
call npx expo run:android --variant release
if %errorlevel% neq 0 (
    echo ❌ Lokaler Build fehlgeschlagen!
    echo.
    echo 🔧 MÖGLICHE LÖSUNGEN:
    echo    1. Android Studio korrekt installiert?
    echo    2. SDK Tools verfügbar?
    echo    3. Umgebungsvariablen gesetzt?
    echo.
    echo 💡 ALTERNATIVE: Verwenden Sie Option 1 (Cloud Build)
    pause
    exit /b 1
)

goto buildSuccess

:devBuild
echo 🧪 STARTE DEVELOPMENT BUILD...
echo.
call npx eas build --platform android --profile development
if %errorlevel% neq 0 (
    echo ❌ Development Build fehlgeschlagen!
    pause
    exit /b 1
)
goto buildSuccess

:setupComplete
echo ✅ SETUP ERFOLGREICH ABGESCHLOSSEN!
echo.
echo 🔧 VERFÜGBARE BEFEHLE:
echo    npx expo start              - App in Entwicklung testen
echo    npx eas build --platform android --profile preview  - APK erstellen
echo    npx expo run:android        - Auf Emulator testen
echo.
goto endScript

:invalidChoice
echo ❌ Ungültige Auswahl! Bitte wählen Sie 1-4.
timeout /t 2 >nul
goto [SCHRITT 6/6]

:buildSuccess
cls
echo.
echo  ██████████████████████████████████████████████████████████
echo  █                                                        █
echo  █                 🎉 BUILD ERFOLGREICH! 🎉                █
echo  █                                                        █
echo  ██████████████████████████████████████████████████████████
echo.
echo  ✅ Ihre Stadtwache APK wurde erfolgreich erstellt!
echo.
echo  📱 INSTALLATION AUF ANDROID:
echo     1. APK-Datei auf Ihr Android-Gerät übertragen
echo     2. "Unbekannte Quellen" in Einstellungen aktivieren:
echo        Einstellungen → Sicherheit → Unbekannte Quellen ☑️
echo     3. APK-Datei antippen und installieren
echo.
echo  🚀 APP-FEATURES:
echo     📋 Vorfall-Management (Melden, Zuweisen, Verwalten)
echo     💬 Real-Time Chat zwischen Wächtern
echo     👥 Team-Übersicht mit Status-Anzeige
echo     📊 Berichte erstellen und archivieren
echo     ⚙️  Admin-Panel für Benutzerverwaltung
echo.
echo  🔐 STANDARD-ZUGANGSDATEN:
echo     Admin: admin@stadtwache.de / admin123
echo     Demo:  waechter@stadtwache.de / waechter123
echo.
echo  🔧 ENTWICKLUNG:
echo     npx expo start --tunnel     - App testen
echo     npx eas build --platform android --profile preview  - Neue APK
echo.

:endScript
echo.
echo ════════════════════════════════════════════════════════════
echo  🏛️  STADTWACHE SCHWELM - Mobile Security Solution
echo     💻 Entwickelt für professionelle Sicherheitskräfte
echo     📞 Support: github.com/hagelbagel03-spec/neu401
echo ════════════════════════════════════════════════════════════
echo.
echo 📄 Ausführliche Anleitung: README-APK-BUILD.md
echo.
pause