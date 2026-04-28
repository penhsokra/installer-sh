#!/bin/bash

set -euo pipefail

JDK_DIR="$HOME/jdk"
TMP_FILE="/tmp/jdk.tar.gz"

JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.16%2B8/OpenJDK17U-jdk_x64_linux_hotspot_17.0.16_8.tar.gz"

echo "======================================"
echo "☕ Java Installer (WEB USER ONLY)"
echo "======================================"

# -----------------------------
# 1. Check existing installation
# -----------------------------
if [ -x "$JDK_DIR/bin/java" ]; then
  echo "✔ Java already installed at $JDK_DIR"
  "$JDK_DIR/bin/java" -version
  exit 0
fi

# -----------------------------
# 2. Download JDK
# -----------------------------
echo "===> Downloading JDK..."

wget -q --show-progress -O "$TMP_FILE" "$JDK_URL"

if [ ! -s "$TMP_FILE" ]; then
  echo "❌ Download failed"
  exit 1
fi

# -----------------------------
# 3. Extract JDK (NO directory creation)
# -----------------------------
echo "===> Extracting JDK..."

tar -xzf "$TMP_FILE" -C "$JDK_DIR" --strip-components=1

rm -f "$TMP_FILE"

# -----------------------------
# 4. Configure environment
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
# 5. Verify installation
# -----------------------------
echo "===> Verifying installation..."

java -version

echo ""
echo "✅ Java installed successfully"
echo "📍 JAVA_HOME: $JAVA_HOME"