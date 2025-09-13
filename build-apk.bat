@echo off
title Stadtwache APK Build Tool
color 0A

echo.
echo ========================================
echo    STADTWACHE APK BUILD TOOL
echo ========================================
echo.

REM Check if Node.js is installed
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [FEHLER] Node.js ist nicht installiert!
    echo Bitte installieren Sie Node.js von: https://nodejs.org/
    pause
    exit /b 1
)

REM Check if yarn is installed
where yarn >nul 2>nul
if %errorlevel% neq 0 (
    echo [INFO] Yarn wird installiert...
    npm install -g yarn
)

REM Check if Expo CLI is installed
where expo >nul 2>nul
if %errorlevel% neq 0 (
    echo [INFO] Expo CLI wird installiert...
    npm install -g @expo/cli
)

REM Check if EAS CLI is installed
where eas >nul 2>nul
if %errorlevel% neq 0 (
    echo [INFO] EAS CLI wird installiert...
    npm install -g eas-cli
)

echo [INFO] Wechsle in Frontend-Verzeichnis...
cd /d "%~dp0\frontend"

echo [INFO] Installiere Dependencies...
call yarn install
if %errorlevel% neq 0 (
    echo [FEHLER] Dependencies konnten nicht installiert werden!
    pause
    exit /b 1
)

echo.
echo ========================================
echo    APK BUILD OPTIONEN
echo ========================================
echo.
echo 1. Development Build (Debug APK)
echo 2. Preview Build (Unsigned APK) 
echo 3. Production Build (Release APK)
echo 4. Local Build (ohne EAS)
echo.
set /p choice="Waehlen Sie eine Option (1-4): "

if "%choice%"=="1" goto development
if "%choice%"=="2" goto preview  
if "%choice%"=="3" goto production
if "%choice%"=="4" goto local
goto invalid

:development
echo.
echo [INFO] Starte Development Build...
call eas build --platform android --profile development
goto end

:preview
echo.
echo [INFO] Starte Preview Build...
call eas build --platform android --profile preview
goto end

:production
echo.
echo [INFO] Starte Production Build...
call eas build --platform android --profile production
goto end

:local
echo.
echo [INFO] Starte lokalen Build...
echo [WARNUNG] Lokaler Build benoetigt Android SDK!
call expo run:android --variant release
goto end

:invalid
echo [FEHLER] Ungueltige Auswahl!
pause
exit /b 1

:end
echo.
echo ========================================
echo    BUILD ABGESCHLOSSEN
echo ========================================
echo.
echo Die APK-Datei wurde erstellt!
echo.
echo Zusaetzliche Befehle:
echo - expo start --android    (App in Emulator testen)
echo - eas build --platform android --profile preview --local (Lokaler Build)
echo.
pause