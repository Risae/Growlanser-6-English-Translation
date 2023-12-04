#!/bin/sh
cd "$(cd "$(dirname "$0")" && pwd)"
mkdir ./old
chmod +x ./xdelta3_mac
./xdelta3_mac -v -d -s "Growlanser 6 Precarious World.iso" "vcdiff/Growlanser 6 Precarious World.iso.vcdiff" "Growlanser 6 Precarious World English.ISO"
mv "Growlanser 6 Precarious World.iso" old
