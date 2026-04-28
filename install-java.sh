#!/bin/bash

set -euo pipefail

JDK_DIR="/opt/jdk"
JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.16%2B8/OpenJDK17U-jdk_x64_linux_hotspot_17.0.16_8.tar.gz"
TMP_FILE="/tmp/jdk.tar.gz"
TARGET_USER="web"
TARGET_HOME="/home/web"

echo "======================================"
echo "☕ Java Installer (WEB USER ONLY)"
echo "======================================"

# -----------------------------
# 1. Check existing installation
# -----------------------------
if [ -x "$JDK_DIR/bin/java" ]; then
  echo "✔ Java already installed at $JDK_DIR"
  sudo -u $TARGET_USER $JDK_DIR/bin/java -version
  exit 0
fi

# -----------------------------
# 2. Create directory
# -----------------------------
echo "===> Creating JDK directory"

sudo mkdir -p "$JDK_DIR"
sudo chown -R "$TARGET_USER:$TARGET_USER" "$JDK_DIR"
sudo chmod 750 "$JDK_DIR"

# -----------------------------
# 3. Download JDK
# -----------------------------
echo "===> Downloading JDK..."

wget -q --show-progress -O "$TMP_FILE" "$JDK_URL"

if [ ! -s "$TMP_FILE" ]; then
  echo "❌ Download failed"
  exit 1
fi

# -----------------------------
# 4. Extract JDK
# -----------------------------
echo "===> Extracting JDK..."

sudo tar -xzf "$TMP_FILE" -C "$JDK_DIR" --strip-components=1
rm -f "$TMP_FILE"

# -----------------------------
# 5. Configure environment for WEB user only
# -----------------------------
echo "===> Configuring environment for user web"

WEB_PROFILE="$TARGET_HOME/.bash_profile"

sudo -u "$TARGET_USER" bash -c "
if ! grep -q JAVA_HOME $WEB_PROFILE 2>/dev/null; then
  cat <<EOF >> $WEB_PROFILE

# Java Environment
export JAVA_HOME=$JDK_DIR
export PATH=\$JAVA_HOME/bin:\$PATH
EOF
fi
"

# -----------------------------
# 6. Apply immediately for current script
# -----------------------------
export JAVA_HOME="$JDK_DIR"
export PATH="$JAVA_HOME/bin:$PATH"

# -----------------------------
# 7. Verify as web user
# -----------------------------
echo "===> Verifying Java as web user..."

sudo -u "$TARGET_USER" $JDK_DIR/bin/java -version

echo ""
echo "✅ Java installed successfully for user: $TARGET_USER"
echo "📍 JAVA_HOME: $JAVA_HOME"