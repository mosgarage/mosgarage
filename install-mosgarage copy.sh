#!/usr/bin/env bash
set -euo pipefail
echo "Running MosGarage installer (local)"
REPO=${1:-https://github.com/mosgarage/mosgarage.git}
TARGET=${2:-$HOME/mosgarage}
mkdir -p "$TARGET"
if [ -d "$TARGET/.git" ]; then cd "$TARGET" && git pull --rebase || true; else git clone "$REPO" "$TARGET"; fi
cd "$TARGET"
if ! command -v docker >/dev/null 2>&1; then echo "Docker is required. Please install Docker or Docker Desktop first."; exit 1; fi
docker compose -f docker-compose.yml -f docker-compose.override.yml up -d --build
echo "MosGarage started. Visit http://localhost:8090 and http://localhost:8080 (VSCode)"
