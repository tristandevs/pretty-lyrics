#!/bin/bash

# Define paths
USERNAME=$(whoami)
SPICETIFY_EXT_DIR="C:/Users/$USERNAME/AppData/Roaming/spicetify/Extensions"
SPICETIFY_CONFIG="C:/Users/$USERNAME/AppData/Roaming/spicetify/config-xpui.ini"
JS_FILE_URL="https://raw.githubusercontent.com/tristandevs/pretty-lyrics/main/Builds/Release/pretty-lyrics.mjs"
JS_FILE_NAME="pretty-lyrics.mjs"

# Create Extensions directory if it doesn't exist
if [[ ! -d "$SPICETIFY_EXT_DIR" ]]; then
    echo "Creating Extensions directory at $SPICETIFY_EXT_DIR"
    mkdir -p "$SPICETIFY_EXT_DIR"
fi

# Download the pretty-lyrics.mjs file
echo "Downloading $JS_FILE_NAME from $JS_FILE_URL..."
curl -o "$SPICETIFY_EXT_DIR/$JS_FILE_NAME" "$JS_FILE_URL"
if [[ $? -ne 0 ]]; then
    echo "Failed to download $JS_FILE_NAME. Exiting."
    exit 1
fi
echo "Downloaded $JS_FILE_NAME to $SPICETIFY_EXT_DIR."

# Check if config-xpui.ini exists
if [[ ! -f "$SPICETIFY_CONFIG" ]]; then
    echo "Config file not found: $SPICETIFY_CONFIG"
    echo "Please ensure Spicetify is installed and initialized. Exiting."
    exit 1
fi

# Backup the config-xpui.ini file
echo "Backing up config-xpui.ini..."
cp "$SPICETIFY_CONFIG" "$SPICETIFY_CONFIG.bak"

# Modify the config-xpui.ini to add the extension entry
echo "Modifying config-xpui.ini to include $JS_FILE_NAME..."
if grep -q "extensions" "$SPICETIFY_CONFIG"; then
    # Update existing extensions line
    sed -i "s/extensions *=.*/extensions            = $JS_FILE_NAME/" "$SPICETIFY_CONFIG"
else
    # Add the extensions line under [AdditionalOptions]
    sed -i "/\[AdditionalOptions\]/a extensions            = $JS_FILE_NAME" "$SPICETIFY_CONFIG"
fi
echo "Updated config-xpui.ini to include $JS_FILE_NAME."

# Inform user of success
echo "Setup complete! The $JS_FILE_NAME file has been added and configured."