@echo off
title STADTWACHE - GitHub Actions Build
color 0C

echo.
echo ===============================================
echo     STADTWACHE - GITHUB ACTIONS BUILD
echo ===============================================
echo.
echo Diese Methode erstellt APKs KOSTENLOS in der Cloud
echo ohne EAS und ohne Android Studio auf Ihrem PC!
echo.
echo VORTEILE:
echo + Komplett kostenlos
echo + Keine lokale Installation
echo + Professionelle Build-Umgebung
echo + Automatisiert
echo.
echo SCHRITTE:
echo.
echo 1. GitHub-Account erstellen (falls nicht vorhanden)
echo    https://github.com
echo.
echo 2. Neues Repository erstellen
echo    - Name: stadtwache-app
echo    - Public oder Private
echo.
echo 3. Diesen Ordner hochladen:
echo    %CD%
echo.
echo 4. GitHub Actions Workflow hinzufuegen
echo    (Datei wird automatisch erstellt)
echo.
echo 5. Push = APK wird automatisch erstellt!
echo.
set /p continue="GitHub Actions Setup starten? (J/N): "
if /i not "%continue%"=="J" goto end

echo.
echo Erstelle GitHub Actions Workflow...
if not exist ".github" mkdir .github
if not exist ".github\workflows" mkdir .github\workflows

echo name: Android APK Build > .github\workflows\android.yml
echo. >> .github\workflows\android.yml
echo on: >> .github\workflows\android.yml
echo   push: >> .github\workflows\android.yml
echo     branches: [ main ] >> .github\workflows\android.yml
echo   pull_request: >> .github\workflows\android.yml
echo     branches: [ main ] >> .github\workflows\android.yml
echo. >> .github\workflows\android.yml
echo jobs: >> .github\workflows\android.yml
echo   build: >> .github\workflows\android.yml
echo     runs-on: ubuntu-latest >> .github\workflows\android.yml
echo. >> .github\workflows\android.yml
echo     steps: >> .github\workflows\android.yml
echo     - uses: actions/checkout@v3 >> .github\workflows\android.yml
echo. >> .github\workflows\android.yml
echo     - name: Setup Node.js >> .github\workflows\android.yml
echo       uses: actions/setup-node@v3 >> .github\workflows\android.yml
echo       with: >> .github\workflows\android.yml
echo         node-version: '18' >> .github\workflows\android.yml
echo         cache: 'npm' >> .github\workflows\android.yml
echo         cache-dependency-path: frontend/package-lock.json >> .github\workflows\android.yml
echo. >> .github\workflows\android.yml
echo     - name: Setup Java JDK >> .github\workflows\android.yml
echo       uses: actions/setup-java@v3 >> .github\workflows\android.yml
echo       with: >> .github\workflows\android.yml
echo         java-version: '11' >> .github\workflows\android.yml
echo         distribution: 'temurin' >> .github\workflows\android.yml
echo. >> .github\workflows\android.yml
echo     - name: Install dependencies >> .github\workflows\android.yml
echo       working-directory: ./frontend >> .github\workflows\android.yml
echo       run: npm install >> .github\workflows\android.yml
echo. >> .github\workflows\android.yml
echo     - name: Build APK >> .github\workflows\android.yml
echo       working-directory: ./frontend >> .github\workflows\android.yml
echo       run: ^| >> .github\workflows\android.yml
echo         npx expo prebuild --platform android >> .github\workflows\android.yml
echo         cd android >> .github\workflows\android.yml
echo         ./gradlew assembleRelease >> .github\workflows\android.yml
echo. >> .github\workflows\android.yml
echo     - name: Upload APK >> .github\workflows\android.yml
echo       uses: actions/upload-artifact@v3 >> .github\workflows\android.yml
echo       with: >> .github\workflows\android.yml
echo         name: stadtwache-apk >> .github\workflows\android.yml
echo         path: frontend/android/app/build/outputs/apk/release/app-release.apk >> .github\workflows\android.yml

echo.
echo GitHub Actions Workflow erstellt!
echo.
echo NAECHSTE SCHRITTE:
echo 1. Gehen Sie zu: https://github.com
echo 2. Erstellen Sie ein neues Repository
echo 3. Laden Sie diesen kompletten Ordner hoch
echo 4. Die APK wird automatisch erstellt!
echo 5. Download unter: Actions Tab - Artifacts
echo.

:end
echo.
pause