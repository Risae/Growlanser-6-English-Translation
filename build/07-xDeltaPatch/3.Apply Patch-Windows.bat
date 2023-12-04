@echo off
mkdir old
.\xdelta-3.1.0-x86_64.exe -v -d -s "Growlanser 6 Precarious World.iso" ".\vcdiff\Growlanser 6 Precarious World.iso.vcdiff" "Growlanser 6 Precarious World English.ISO"
move "Growlanser 6 Precarious World.iso" old
echo Completed!
@pause
