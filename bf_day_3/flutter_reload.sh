#!/bin/bash
# Send hot reload command to Flutter
echo "Sending hot reload command..."
osascript -e 'tell application "Terminal" to do script "r"'
echo "Hot reload triggered!"