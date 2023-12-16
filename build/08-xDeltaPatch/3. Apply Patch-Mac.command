#!/bin/sh
echo "[i] Starting to patch the ISO."
cd "$(cd "$(dirname "$0")" && pwd)"
chmod +x bin/xdelta3_mac
bin/xdelta3_mac -v -d -s "Growlanser 6 Precarious World.iso" "vcdiff/Growlanser 6 Precarious World.iso.vcdiff" "Growlanser 6 Precarious World English.iso"
echo "[i] Completed!"