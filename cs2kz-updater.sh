#!/bin/bash
# Script: cs2kz-updater.sh
# Description: Automatically updates the CS2KZ server with the latest release from GitHub
# Requirements: jq (JSON processor) - Install with: sudo apt install jq

# Define variables
REPO_URL="https://api.github.com/repos/KZGlobalTeam/cs2kz-metamod/releases"

# Path to CS2 server directory
CS2SERVER_DIR="/home/cs2server/serverfiles/game/csgo/"

# Fetch the JSON response and extract the latest tag name
LATEST_TAG=$(curl -sSL "${REPO_URL}" | jq -r '.[0].tag_name')

# Check if the latest tag is different from the stored version
if [ "${LATEST_TAG}" != "$(cat version.txt)" ]; then
    echo "New version available: ${LATEST_TAG}"
    echo "${LATEST_TAG}" > version.txt

    # Fetch the download URL for the Linux-related asset
    DOWNLOAD_URL=$(curl -sSL "${REPO_URL}" | jq -r '.[0].assets[] | select(.name | contains("linux")) | .browser_download_url')

    if [ -n "${DOWNLOAD_URL}" ]; then
        echo "Downloading asset: ${DOWNLOAD_URL}"
        wget "${DOWNLOAD_URL}" -P "${CS2SERVER_DIR}"
        echo "Download complete."

        FILENAME=$(basename "${DOWNLOAD_URL}")
        tar -xzvf "${CS2SERVER_DIR}/${FILENAME}" -C "${CS2SERVER_DIR}"
        echo "Extraction complete."

        rm "${CS2SERVER_DIR}/${FILENAME}"
        echo "Deleted ${FILENAME}."
    else
        echo "No Linux-related asset found in the latest release."
    fi
else
    echo "No new version available."
fi