#!/bin/bash
# NALA-HWSensors v2.0 (2.0.0-NCSP) — 1-Click macOS Launcher
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

echo "🛡️  Running sHeriFF + NVIDIA SkillSpector + SHA-256 Pre-Flight Check..."
python3 "$DIR/scripts/nala_hwsensors_sheriff_audit.py" --init-skins

echo "🏎️  Starting NALA-HWSensors v2.0 Live Telemetry Daemon on http://127.0.0.1:8768 ..."
(sleep 1.2 && open "http://127.0.0.1:8768") &
python3 "$DIR/macos/nala_hwsensors_daemon.py" --port 8768
