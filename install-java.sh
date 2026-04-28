#!/bin/bash

set -euo pipefail

JDK_DIR="/opt/jdk"
JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.16%2B8/OpenJDK17U-jdk_x64_linux_hotspot_17.0.16_8.tar.gz"
TMP_FILE="/tmp/jdk.tar.gz"

echo "======================================"
echo "☕ Java Temurin 17 Installer"
echo "======================================"

# -----------------------------
# 1. Check existing installation
# -----------------------------
if [ -x "$JDK_DIR/bin/java" ]; then
  echo "✔ Java already installed at $JDK_DIR"
  java -version
  exit 0
fi

# -----------------------------
# 2. Check before creating directory
# -----------------------------
echo "===> Check JDK directory: $JDK_DIR"

if [ -d "$JDK_DIR" ]; then
  echo "✔ Directory already exists: $JDK_DIR (skip creation)"
else
  echo "===> Creating JDK directory: $JDK_DIR"
  sudo mkdir -p "$JDK_DIR"
  sudo chown "web:web" "$JDK_DIR"
  sudo chmod 750 "$JDK_DIR"
fi

# -----------------------------
# 3. Download JDK
# -----------------------------
echo "===> Downloading JDK..."

wget -q --show-progress -O "$TMP_FILE" "$JDK_URL"

# -----------------------------
# 4. Extract JDK
# -----------------------------
echo "===> Extracting JDK..."

sudo tar -xzf "$TMP_FILE" -C "$JDK_DIR" --strip-components=1

rm -f "$TMP_FILE"

# -----------------------------
# 5. Configure environment
# -----------------------------
echo "===> Configuring environment..."

PROFILE="$HOME/.bash_profile"

if ! grep -q "JAVA_HOME" "$PROFILE" 2>/dev/null; then
  cat <<EOF >> "$PROFILE"

# Java Environment
export JAVA_HOME="$JDK_DIR"
export PATH=\$JAVA_HOME/bin:\$PATH
EOF
fi

# apply immediately
export JAVA_HOME="$JDK_DIR"
export PATH="$JAVA_HOME/bin:$PATH"

# -----------------------------
# 6. Verify installation
# -----------------------------
echo "===> Verifying installation..."

java -version
which java

echo ""
echo "✅ Java installation completed successfully!"
echo "📍 JAVA_HOME: $JAVA_HOME"