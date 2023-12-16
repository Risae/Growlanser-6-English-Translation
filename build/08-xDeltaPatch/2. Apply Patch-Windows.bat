@echo off
echo "[i] Starting to patch the ISO."
.\bin\xdelta-3.1.0-x86_64.exe -v -d -s "Growlanser 6 Precarious World.iso" ".\vcdiff\Growlanser 6 Precarious World.iso.vcdiff" "Growlanser 6 Precarious World English.iso"
echo "[i] Completed!"
@pause