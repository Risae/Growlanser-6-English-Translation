#!/bin/sh
cd "$(cd "$(dirname "$0")" && pwd)"
mkdir old
chmod +x xdelta3
./xdelta3 -v -d -s "Growlanser 6 Precarious World.iso" "vcdiff/Growlanser 6 Precarious World.iso.vcdiff" "Growlanser 6 Precarious World English.ISO"
mv "Growlanser 6 Precarious World.iso" old
