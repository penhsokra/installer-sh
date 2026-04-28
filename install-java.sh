#!/bin/bash

set -e  # stop if error

JDK_DIR="/opt/jdk"
JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.16%2B8/OpenJDK17U-jdk_x64_linux_hotspot_17.0.16_8.tar.gz"

echo "===> Create JDK directory"
sudo mkdir -p $JDK_DIR
sudo chown $USER:$USER $JDK_DIR
sudo chmod 750 $JDK_DIR

echo "===> Download JDK"
wget -O /tmp/jdk.tar.gz "$JDK_URL"

echo "===> Extract JDK"
tar xzf /tmp/jdk.tar.gz -C $JDK_DIR --strip-components=1

echo "===> Configure environment"
if ! grep -q "JAVA_HOME" ~/.bash_profile; then
  echo 'export JAVA_HOME="/opt/jdk"' >> ~/.bash_profile
  echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bash_profile
fi

echo "===> Reload profile"
source ~/.bash_profile

echo "===> Verify Java"
java -version

echo "✅ Java installed successfully!"