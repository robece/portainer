#!/usr/bin/env bash
# setup.sh — Starts portainer.
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
echo "  $SERVICE setup"
echo "================================================"
echo ""

# -- Verify Docker is running -------------------------------------------------
if ! $DOCKER info &>/dev/null; then
    echo "[error] Docker is not running. Start the Docker service and try again."
    echo "        powershell: Start-Service docker"
    exit 1
fi

# -- Start --------------------------------------------------------------------
echo "[*] Starting $SERVICE..."
$DOCKER compose up -d

echo ""
echo "[ok] $SERVICE is running."
echo ""
$DOCKER ps --filter "name=$SERVICE"
echo ""
echo "  UI   : http://localhost:9000"
echo "  Logs : $DOCKER compose logs -f"
echo ""
