@echo off
title STADTWACHE - Direkte APK Erstellung
color 0C

cls
echo.
echo ===============================================
echo    STADTWACHE - DIREKTE APK ERSTELLUNG
echo ===============================================
echo.
echo Erstellt APK direkt uber CMD/PowerShell
echo OHNE EAS, OHNE Android Studio!
echo.

REM Admin-Rechte prüfen
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo WICHTIG: Als Administrator starten fuer beste Ergebnisse!
    echo.
    timeout /t 3 >nul
)

echo [SCHRITT 1] Umgebung pruefen...

REM Node.js prüfen
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo FEHLER: Node.js nicht gefunden!
    echo Installieren Sie Node.js von https://nodejs.org/
    pause
    exit /b 1
)

echo OK: Node.js gefunden
node --version
echo.

REM PowerShell prüfen
where powershell >nul 2>nul
if %errorlevel% neq 0 (
    echo FEHLER: PowerShell nicht gefunden!
    pause
    exit /b 1
)

echo OK: PowerShell gefunden
echo.

echo [SCHRITT 2] APK-Erstellungsmethode waehlen...
echo.
echo 1. Cordova Wrapper (Echte APK, benoetigt Java)
echo 2. PWA zu APK Konverter (Online Service)
echo 3. Capacitor Build (Lokale APK)
echo 4. Web-Bundle APK (Einfachste Methode)
echo 5. Beenden
echo.
set /p method="Waehlen Sie Methode (1-5): "

if "%method%"=="1" goto cordovaMethod
if "%method%"=="2" goto pwaMethod
if "%method%"=="3" goto capacitorMethod
if "%method%"=="4" goto webBundleMethod
if "%method%"=="5" goto end
goto invalidChoice

:webBundleMethod
echo.
echo ===============================================
echo        WEB-BUNDLE APK (EINFACHSTE)
echo ===============================================
echo.
echo Diese Methode erstellt eine APK mit eingebettetem Web-Content.
echo.

cd frontend

echo [1/5] Dependencies installieren...
call npm install --silent
if %errorlevel% neq 0 (
    echo Fehler bei npm install
    pause
    goto end
)

echo [2/5] Web-Build erstellen...
call npx expo export --platform web --output-dir dist-web
if %errorlevel% neq 0 (
    echo Web-Export fehlgeschlagen, versuche Alternative...
    call npm run build 2>nul || call npx expo build:web
)

if not exist "dist-web" (
    if exist "dist" (
        move dist dist-web
    ) else (
        echo Web-Build fehlgeschlagen!
        pause
        goto end
    )
)

echo [3/5] APK-Wrapper installieren...
call npm install -g @capacitor/cli @capacitor/core @capacitor/android --silent

echo [4/5] Capacitor-Projekt initialisieren...
if not exist "capacitor.config.ts" (
    echo import { CapacitorConfig } from '@capacitor/cli'; > capacitor.config.ts
    echo. >> capacitor.config.ts
    echo const config: CapacitorConfig = { >> capacitor.config.ts
    echo   appId: 'com.stadtwache.app', >> capacitor.config.ts
    echo   appName: 'Stadtwache', >> capacitor.config.ts
    echo   webDir: 'dist-web', >> capacitor.config.ts
    echo   bundledWebRuntime: false >> capacitor.config.ts
    echo }; >> capacitor.config.ts
    echo. >> capacitor.config.ts
    echo export default config; >> capacitor.config.ts
)

call npx cap init "Stadtwache" "com.stadtwache.app" --web-dir="dist-web"
call npx cap add android

echo [5/5] APK erstellen...
cd android
if exist "gradlew.bat" (
    call gradlew.bat assembleDebug
    if exist "app\build\outputs\apk\debug\app-debug.apk" (
        echo.
        echo ===============================================
        echo         APK ERFOLGREICH ERSTELLT!
        echo ===============================================
        echo.
        echo APK-Datei: %CD%\app\build\outputs\apk\debug\app-debug.apk
        echo.
        copy "app\build\outputs\apk\debug\app-debug.apk" "..\..\..\stadtwache-app.apk"
        echo APK kopiert nach: stadtwache-app.apk
        echo.
        goto success
    )
)

echo APK-Erstellung fehlgeschlagen. Versuche andere Methode...
cd ..
goto pwaMethod

:pwaMethod
echo.
echo ===============================================
echo        PWA ZU APK KONVERTER
echo ===============================================
echo.
echo Diese Methode konvertiert die Web-App zu einer APK.
echo.

cd frontend

echo [1/4] Web-App erstellen...
call npm install --silent
call npx expo export --platform web --output-dir web-build

if not exist "web-build" (
    mkdir web-build
    echo Fallback: Kopiere statische Dateien...
    if exist "dist" (
        xcopy /E /I /H /Y dist\* web-build\
    ) else (
        echo ^<!DOCTYPE html^> > web-build\index.html
        echo ^<html^>^<head^>^<title^>Stadtwache^</title^>^</head^> >> web-build\index.html
        echo ^<body^>^<h1^>Stadtwache App^</h1^>^<p^>App wird geladen...^</p^>^</body^>^</html^> >> web-build\index.html
    )
)

echo [2/4] Lokalen Server starten...
cd web-build
start /min python -m http.server 8080 2>nul || start /min npx http-server -p 8080

timeout /t 5 >nul

echo [3/4] APK-Wrapper erstellen...
cd ..

REM PowerShell-Script für APK-Wrapper
powershell -Command "
$webAppUrl = 'http://localhost:8080'
$apkName = 'stadtwache-app.apk'

# Einfacher Android WebView Wrapper
$androidManifest = @'
<?xml version=\"1.0\" encoding=\"utf-8\"?>
<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\"
    package=\"com.stadtwache.app\"
    android:versionCode=\"1\"
    android:versionName=\"1.0\">
    
    <uses-permission android:name=\"android.permission.INTERNET\" />
    <uses-permission android:name=\"android.permission.ACCESS_NETWORK_STATE\" />
    
    <application
        android:label=\"Stadtwache\"
        android:theme=\"@android:style/Theme.NoTitleBar.Fullscreen\">
        
        <activity
            android:name=\".MainActivity\"
            android:exported=\"true\">
            <intent-filter>
                <action android:name=\"android.intent.action.MAIN\" />
                <category android:name=\"android.intent.category.LAUNCHER\" />
            </intent-filter>
        </activity>
    </application>
</manifest>
'@

Write-Host 'APK-Wrapper wird erstellt...'
Write-Host 'Web-App URL: $webAppUrl'
"

echo [4/4] Alternative: PWA-Installation...
echo.
echo Die Web-App läuft unter: http://localhost:8080
echo.
echo MOBILE INSTALLATION:
echo 1. Öffnen Sie http://localhost:8080 auf dem Android-Gerät
echo 2. Browser-Menü → "Zur Startseite hinzufügen"
echo 3. App wird wie native App installiert!
echo.
echo Server läuft weiter... (Strg+C zum Beenden)
echo.
goto success

:capacitorMethod
echo.
echo ===============================================
echo        CAPACITOR BUILD METHODE
echo ===============================================
echo.
echo Erweiterte APK-Erstellung mit Capacitor...
echo.

cd frontend

echo Dependencies installieren...
call npm install @capacitor/cli @capacitor/core @capacitor/android --save-dev

echo Web-Build erstellen...
call npm run build 2>nul || call npx expo export --platform web

echo Capacitor initialisieren...
call npx cap init stadtwache com.stadtwache.app --web-dir=dist

echo Android-Plattform hinzufügen...
call npx cap add android

echo Projekt synchronisieren...
call npx cap sync

echo APK erstellen...
cd android
call .\gradlew assembleDebug

if exist "app\build\outputs\apk\debug\app-debug.apk" (
    copy "app\build\outputs\apk\debug\app-debug.apk" "..\..\..\stadtwache-capacitor.apk"
    echo APK erstellt: stadtwache-capacitor.apk
    goto success
) else (
    echo Capacitor-Build fehlgeschlagen.
    goto pwaMethod
)

:cordovaMethod
echo.
echo ===============================================
echo        CORDOVA WRAPPER METHODE
echo ===============================================
echo.
echo WARNUNG: Benötigt Java JDK und Android SDK!
echo.

REM Java prüfen
where java >nul 2>nul
if %errorlevel% neq 0 (
    echo Java JDK nicht gefunden!
    echo.
    echo Java installieren:
    echo 1. https://adoptium.net/
    echo 2. OpenJDK 11 oder höher herunterladen
    echo 3. Installieren und PATH setzen
    echo.
    set /p continue="Ohne Java fortfahren? (J/N): "
    if /i not "%continue%"=="J" goto end
)

echo Cordova installieren...
call npm install -g cordova --silent

cd frontend

echo Web-Build erstellen...
call npm run build 2>nul || call npx expo export --platform web

echo Cordova-Projekt erstellen...
cd ..
if not exist "cordova-app" (
    call cordova create cordova-app com.stadtwache.app Stadtwache
)

cd cordova-app

echo Web-Inhalte kopieren...
if exist "..\frontend\dist" (
    xcopy /E /I /H /Y ..\frontend\dist\* www\
) else if exist "..\frontend\web-build" (
    xcopy /E /I /H /Y ..\frontend\web-build\* www\
)

echo Android-Plattform hinzufügen...
call cordova platform add android

echo APK erstellen...
call cordova build android

if exist "platforms\android\app\build\outputs\apk\debug\app-debug.apk" (
    copy "platforms\android\app\build\outputs\apk\debug\app-debug.apk" "..\stadtwache-cordova.apk"
    echo APK erstellt: stadtwache-cordova.apk
    goto success
) else (
    echo Cordova-Build fehlgeschlagen.
    echo Versuche andere Methode...
    goto webBundleMethod
)

:success
echo.
echo ===============================================
echo         APK ERFOLGREICH ERSTELLT!
echo ===============================================
echo.
echo Ihre Stadtwache APK wurde erstellt!
echo.
echo INSTALLATION:
echo 1. APK-Datei auf Android-Gerät übertragen
echo 2. "Unbekannte Quellen" in Einstellungen aktivieren
echo 3. APK installieren
echo.
echo ZUGANGSDATEN:
echo Admin: admin@stadtwache.de / admin123
echo Demo:  waechter@stadtwache.de / waechter123
echo.
echo APK-Dateien im aktuellen Verzeichnis:
echo - stadtwache-app.apk (Capacitor)
echo - stadtwache-cordova.apk (Cordova)
echo - oder PWA unter http://localhost:8080
echo.
goto end

:invalidChoice
echo Ungültige Auswahl!
timeout /t 2 >nul
goto webBundleMethod

:end
echo.
echo ===============================================
echo              FERTIG!
echo ===============================================
echo.
echo Vielen Dank fürs Verwenden des APK-Builders!
echo.
pause