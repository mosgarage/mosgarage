#!/usr/bin/env bash
set -euo pipefail
echo "MosGarage GitHub Pages installer"
TARGET=${1:-$HOME/mosgarage}
mkdir -p "$TARGET"
if [ -d "$TARGET/.git" ]; then cd "$TARGET" && git pull --rebase || true; else git clone https://github.com/mosgarage/mosgarage.git "$TARGET"; fi
cd "$TARGET"
chmod +x install-mosgarage.sh || true
./install-mosgarage.sh
