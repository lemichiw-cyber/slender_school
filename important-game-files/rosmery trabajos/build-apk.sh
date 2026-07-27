#!/bin/bash
# Build APK para Rosmery - Plataforma Educativa Pastelita
# Requiere: Java 17+, Android SDK, Node.js
#
# Alternativa (más fácil):
# Sube los archivos a https://pwabuilder.com y genera el APK desde la nube

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
echo "=== Build APK Rosmery ==="
echo "Directorio: $DIR"

# Buscar Java
if ! command -v java &>/dev/null; then
  echo "ERROR: Java no está instalado. Instala JDK 17+"
  exit 1
fi

JAVA_VER=$(java -version 2>&1 | head -1 | sed 's/[^0-9.]//g' | cut -d. -f1)
if [ "$JAVA_VER" -lt 17 ]; then
  echo "ERROR: Se requiere Java 17+. Versión actual: $(java -version 2>&1 | head -1)"
  exit 1
fi

echo "✓ Java $(java -version 2>&1 | head -1)"

# Buscar Android SDK
ANDROID_HOME="${ANDROID_HOME:-$HOME/.bubblewrap/android-sdk}"
if [ ! -d "$ANDROID_HOME" ]; then
  echo "Descargando Android SDK..."
  mkdir -p "$ANDROID_HOME/cmdline-tools"
  curl -L -o /tmp/android-sdk.zip "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
  python3 -c "import zipfile; zipfile.ZipFile('/tmp/android-sdk.zip').extractall('$ANDROID_HOME/cmdline-tools/')"
  mv "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest"
  rm -f /tmp/android-sdk.zip
  echo "✓ Android SDK descargado"
fi

export ANDROID_HOME
export JAVA_HOME="${JAVA_HOME:-$(dirname $(dirname $(readlink -f $(which java))))}"

# Aceptar licencias
echo "Aceptando licencias de Android SDK..."
yes | "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" --licenses >/dev/null 2>&1 || true

# Instalar plataformas necesarias
echo "Instalando plataformas Android..."
"$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" \
  "platforms;android-33" \
  "build-tools;33.0.2" \
  >/dev/null 2>&1

# Configurar Bubblewrap
export BUBBLEWRAP_KEYSTORE_PASSWORD="rosmery123"
export BUBBLEWRAP_KEY_PASSWORD="rosmery123"

# Generar proyecto Android (si no existe)
if [ ! -f "$DIR/twa-manifest.json" ]; then
  echo "Generando TWA manifest..."
  npx @bubblewrap/cli init --manifest="manifest.json" --directory="$DIR"
fi

# Construir APK
echo "Construyendo APK..."
npx @bubblewrap/cli build --manifest="$DIR/twa-manifest.json"

echo ""
echo "=== APK generado ==="
echo "Busca el archivo .apk en $DIR"
