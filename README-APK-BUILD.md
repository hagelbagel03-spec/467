# Stadtwache App - APK Build Anleitung

## 🚀 Schnellstart

### Automatische Installation (Windows)
```bash
# Einfach ausführen:
install-and-build.bat
```

### Manuelle Installation

#### 1. Voraussetzungen installieren
```bash
# Node.js von https://nodejs.org/ installieren (LTS Version)
# Dann globale Pakete installieren:
npm install -g yarn expo-cli @expo/cli eas-cli
```

#### 2. Dependencies installieren
```bash
cd frontend
yarn install
```

#### 3. APK erstellen

##### Option A: EAS Build (Empfohlen)
```bash
# Expo Account erforderlich (kostenlos)
eas login
eas build --platform android --profile preview
```

##### Option B: Lokaler Build
```bash
# Benötigt Android Studio + SDK
npx expo prebuild --platform android
npx expo run:android --variant release
```

## 📱 APK Installation

1. APK-Datei auf Android-Gerät übertragen
2. "Unbekannte Quellen" in Einstellungen aktivieren
3. APK-Datei antippen und installieren

## 🔧 Problemlösung

### Build-Fehler
- **Node.js nicht gefunden**: Von https://nodejs.org/ installieren
- **Android SDK fehlt**: Android Studio installieren
- **EAS Login fehlt**: `eas login` ausführen

### Runtime-Fehler
- **App startet nicht**: Backend-URL in .env prüfen
- **Keine Internetverbindung**: WLAN/Mobile Daten aktivieren

## 📁 Projektstruktur

```
stadtwache/
├── frontend/                 # React Native App
│   ├── app/                 # App Screens (Expo Router)
│   ├── assets/              # Icons, Images
│   ├── app.json             # Expo Konfiguration
│   └── package.json         # Dependencies
├── backend/                 # FastAPI Server
│   ├── server.py            # Haupt-Server
│   └── requirements.txt     # Python Dependencies
├── build-apk.bat           # Windows Build Script
├── install-and-build.bat   # Vollständige Installation
└── eas.json                # EAS Build Konfiguration
```

## 🔑 Features der App

- **Vorfall-Management**: Vorfälle melden und verwalten
- **Real-Time Chat**: Live-Kommunikation zwischen Wächtern
- **Team-Übersicht**: Status und Standort von Kollegen
- **Berichte**: Schichtberichte erstellen und archivieren
- **Admin-Panel**: Benutzer- und Systemverwaltung

## 🔐 Standard-Zugangsdaten

**Admin-Benutzer:**
- E-Mail: `admin@stadtwache.de`
- Passwort: `admin123`

**Demo-Wächter:**
- E-Mail: `waechter@stadtwache.de`
- Passwort: `waechter123`

## 🔄 Development

### App testen
```bash
cd frontend
npx expo start --android
```

### Backend starten
```bash
cd backend
pip install -r requirements.txt
uvicorn server:app --host 0.0.0.0 --port 8001
```

## 📦 Build-Profiles

### Development
- Debug-Build mit Hot-Reload
- Für Entwicklung und Testing

### Preview
- Unsigned APK
- Zum Teilen und Testing
- **Standardwahl für APK-Erstellung**

### Production
- Signed APK/AAB
- Store-ready
- Benötigt Signing-Konfiguration

## 🆘 Support

Bei Problemen:
1. Logs prüfen: `npx expo start` zeigt Fehler an
2. Cache leeren: `npx expo start --clear`
3. Dependencies neu installieren: `rm -rf node_modules && yarn install`

## 📱 System-Anforderungen

**Entwicklung:**
- Node.js 18+
- Yarn oder npm
- Android Studio (für lokale Builds)

**Gerät:**
- Android 5.0+ (API Level 21)
- 2GB RAM
- 100MB Speicherplatz