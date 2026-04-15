#!/usr/bin/env bash
# teardown.sh — Stops and removes portainer containers and images.
# Run from WSL or Git Bash as Administrator.

set -euo pipefail

# -- Always run from project root ---------------------------------------------
cd "$(dirname "$0")/.."

SERVICE="portainer"

# -- Resolve docker command (WSL calls docker.exe on the Windows host) --------
DOCKER="docker"
if grep -qi microsoft /proc/version 2>/dev/null; then
    DOCKER="docker.exe"
fi

echo ""
echo "================================================"
echo "  $SERVICE teardown"
echo "================================================"
echo ""

# -- Stop and remove containers -----------------------------------------------
echo "[*] Stopping $SERVICE..."
$DOCKER compose down

# -- Remove image -------------------------------------------------------------
read -rp "[?] Remove the Docker image as well? (y/N): " REMOVE_IMAGE
if [[ "$(echo "$REMOVE_IMAGE" | tr '[:upper:]' '[:lower:]')" == "y" ]]; then
    echo "[*] Removing image..."
    $DOCKER rmi "portainer/portainer-ce:2.39.1" 2>/dev/null && echo "[ok] Image removed." || echo "[!] Image not found, skipping."
fi

# -- Remove volume ------------------------------------------------------------
read -rp "[?] Remove the data volume? This will DELETE all data. (y/N): " REMOVE_VOL
if [[ "$(echo "$REMOVE_VOL" | tr '[:upper:]' '[:lower:]')" == "y" ]]; then
    echo "[*] Removing volume..."
    $DOCKER volume rm portainer-data 2>/dev/null && echo "[ok] Volume removed." || echo "[!] Volume not found, skipping."
fi

echo ""
echo "[ok] $SERVICE teardown complete."
echo ""
