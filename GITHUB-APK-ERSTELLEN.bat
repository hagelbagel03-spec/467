@echo off
title STADTWACHE - GitHub APK Ersteller
color 0D

cls
echo.
echo ===============================================
echo      STADTWACHE - GITHUB APK ERSTELLER
echo ===============================================
echo.
echo Erstellt automatisch eine APK uber GitHub Actions
echo OHNE Android Studio oder EAS!
echo.
echo Voraussetzungen:
echo + GitHub-Account (kostenlos)
echo + Internetverbindung
echo + Dieser App-Ordner
echo.

set /p continue="Bereit fur APK-Erstellung? (J/N): "
if /i not "%continue%"=="J" goto end

echo.
echo ===============================================
echo         METHODE WAEHLEN
echo ===============================================
echo.
echo 1. Mit Git (automatisch, falls installiert)
echo 2. Manueller Upload (uber GitHub Website)
echo 3. Anleitung nur anzeigen
echo 4. Beenden
echo.
set /p method="Waehlen Sie (1-4): "

if "%method%"=="1" goto gitMethod
if "%method%"=="2" goto manualMethod
if "%method%"=="3" goto showInstructions
if "%method%"=="4" goto end
goto invalidChoice

:gitMethod
echo.
echo ===============================================
echo         GIT-METHODE (AUTOMATISCH)
echo ===============================================
echo.

REM Git prüfen
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo Git ist nicht installiert!
    echo.
    echo Git installieren:
    echo 1. https://git-scm.com/download/win
    echo 2. Standard-Installation durchfuehren
    echo 3. Computer neu starten
    echo 4. Dieses Script erneut starten
    echo.
    pause
    goto manualMethod
)

echo Git gefunden: 
git --version
echo.

REM GitHub Credentials abfragen
echo GitHub-Zugangsdaten eingeben:
set /p github_user="GitHub Username: "
set /p github_repo="Repository Name (z.B. stadtwache-app): "

echo.
echo Vorbereitung...

REM Git Repository initialisieren
if not exist ".git" (
    echo Git Repository initialisieren...
    git init
    git branch -M main
)

REM .gitignore erstellen
echo node_modules/ > .gitignore
echo .expo/ >> .gitignore
echo dist/ >> .gitignore
echo .env.local >> .gitignore
echo *.log >> .gitignore

echo Git Repository vorbereitet.
echo.

echo Dateien hinzufuegen...
git add .
git commit -m "Stadtwache App - Initial commit with GitHub Actions"

echo.
echo Repository-URL: https://github.com/%github_user%/%github_repo%.git
echo.
echo WICHTIG: Erstellen Sie das Repository auf GitHub:
echo 1. Gehen Sie zu: https://github.com/new
echo 2. Repository Name: %github_repo%
echo 3. Public waehlen (fuer kostenlose Actions)
echo 4. Ohne README erstellen
echo 5. Repository erstellen
echo.
set /p repo_created="Repository auf GitHub erstellt? (J/N): "
if /i not "%repo_created%"=="J" (
    echo Bitte erstellen Sie zuerst das Repository auf GitHub.
    pause
    goto end
)

echo.
echo Push zu GitHub...
git remote remove origin 2>nul
git remote add origin https://github.com/%github_user%/%github_repo%.git
git push -u origin main

if %errorlevel% neq 0 (
    echo.
    echo Push fehlgeschlagen!
    echo.
    echo Moegliche Ursachen:
    echo 1. Repository existiert nicht auf GitHub
    echo 2. Falsche Zugangsdaten
    echo 3. Git-Authentifizierung erforderlich
    echo.
    echo Versuchen Sie die manuelle Methode.
    pause
    goto manualMethod
)

echo.
echo ===============================================
echo         UPLOAD ERFOLGREICH!
echo ===============================================
echo.
echo GitHub Actions wird automatisch gestartet.
echo.
goto checkBuild

:manualMethod
echo.
echo ===============================================
echo         MANUELLER UPLOAD
echo ===============================================
echo.
echo SCHRITT 1: GitHub Repository erstellen
echo 1. Gehen Sie zu: https://github.com/new
echo 2. Repository Name: stadtwache-app
echo 3. Waehlen Sie "Public" (fuer kostenlose Actions)
echo 4. NICHT "Initialize with README" ankreuzen
echo 5. "Create repository" klicken
echo.
set /p step1="Repository erstellt? (J/N): "
if /i not "%step1%"=="J" goto end

echo.
echo SCHRITT 2: ZIP-Datei erstellen
echo Erstelle ZIP-Datei fuer Upload...

REM PowerShell ZIP-Erstellung
powershell -Command "Compress-Archive -Path '.\*' -DestinationPath '.\stadtwache-upload.zip' -Force"

if exist "stadtwache-upload.zip" (
    echo ZIP-Datei erstellt: stadtwache-upload.zip
) else (
    echo ZIP-Erstellung fehlgeschlagen.
    echo Erstellen Sie manuell eine ZIP-Datei mit allen Ordnern.
)

echo.
echo SCHRITT 3: Upload auf GitHub
echo 1. Gehen Sie zu Ihrem neuen Repository
echo 2. Klicken Sie "uploading an existing file"
echo 3. Waehlen Sie die ZIP-Datei: stadtwache-upload.zip
echo 4. Oder ziehen Sie alle Ordner einzeln rein:
echo    - frontend/
echo    - backend/
echo    - .github/
echo    - alle .bat und .txt Dateien
echo 5. Commit message: "Initial commit"
echo 6. "Commit changes" klicken
echo.
set /p step3="Upload abgeschlossen? (J/N): "
if /i not "%step3%"=="J" goto end

goto checkBuild

:checkBuild
echo.
echo ===============================================
echo         APK-BUILD UEBERWACHEN
echo ===============================================
echo.
echo Gehen Sie zu Ihrem GitHub Repository:
echo https://github.com/%github_user%/%github_repo%
echo.
echo 1. Klicken Sie auf "Actions" Tab
echo 2. Sie sehen "Android APK Build" Workflow
echo 3. Build Status:
echo    - Gelb = Build laeuft (10-15 Minuten)
echo    - Gruen = Build erfolgreich
echo    - Rot = Build fehlgeschlagen
echo.
echo 4. Bei erfolgreichem Build:
echo    - Klicken Sie auf den Build
echo    - Scrollen Sie zu "Artifacts"
echo    - Klicken Sie "stadtwache-apk" fuer Download
echo.
echo 5. APK Installation:
echo    - APK auf Android-Geraet kopieren
echo    - "Unbekannte Quellen" aktivieren
echo    - APK installieren
echo.

set /p open_github="GitHub Actions jetzt oeffnen? (J/N): "
if /i "%open_github%"=="J" (
    start https://github.com/%github_user%/%github_repo%/actions
)

goto success

:showInstructions
echo.
echo ===============================================
echo         DETAILLIERTE ANLEITUNG
echo ===============================================
echo.
type APK-ERSTELLEN-GITHUB.txt
echo.
pause
goto end

:success
echo.
echo ===============================================
echo         APK-ERSTELLUNG GESTARTET!
echo ===============================================
echo.
echo Ihre Stadtwache APK wird jetzt erstellt!
echo.
echo ZEITPLAN:
echo ⏱️  Build-Zeit: ca. 10-15 Minuten
echo 📧 Benachrichtigung per E-Mail (optional)
echo 💾 Download: 7 Tage verfuegbar
echo.
echo STANDARD-ZUGANGSDATEN der App:
echo 👨‍💼 Admin: admin@stadtwache.de / admin123
echo 👮‍♂️ Demo:  waechter@stadtwache.de / waechter123
echo.
echo APP-FEATURES:
echo 📋 Vorfall-Management
echo 💬 Real-Time Chat
echo 👥 Team-Uebersicht
echo 📊 Berichte-System
echo ⚙️  Admin-Panel
echo.
echo Build-Status checken:
echo https://github.com/%github_user%/%github_repo%/actions
echo.
goto end

:invalidChoice
echo Ungueltige Auswahl!
timeout /t 2 >nul
goto gitMethod

:end
echo.
echo ===============================================
echo              FERTIG!
echo ===============================================
echo.
echo Vielen Dank fuers Verwenden des Stadtwache APK Builders!
echo.
echo Bei Problemen:
echo - Pruefen Sie GitHub Actions Logs
echo - ZIP-Datei: stadtwache-upload.zip verwenden
echo - Alle Dateien muessen hochgeladen werden
echo.
echo 🏛️ STADTWACHE SCHWELM - Professional Security Solution
echo.
pause