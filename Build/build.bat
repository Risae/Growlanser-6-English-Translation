:::: Setup the build enviromnent

:: Path to the repository (1 folder above)
for %%i in ("%~dp0..") do set "GITHUBPATH=%%~fi"

:: Set Strawberry Portable Path
SET "PATH=%PATH%;%GITHUBPATH%\Build\03-Strawberry Perl Portable\perl\site\bin"
SET "PATH=%PATH%;%GITHUBPATH%\Build\03-Strawberry Perl Portable\perl\bin"
SET "PATH=%PATH%;%GITHUBPATH%\Build\03-Strawberry Perl Portable\c\bin"

:: Cleanup old build files
del "%GITHUBPATH%\Build\GL6_FACE.DAT"
del "%GITHUBPATH%\Build\GL6_FILE.DAT"
del "%GITHUBPATH%\Build\GL6_SCEN.DAT"
del "%GITHUBPATH%\Build\SLPM_667.16"
rmdir /s /q "%GITHUBPATH%\Build\05-build"
rmdir /s /q "%GITHUBPATH%\Build\04-Original files\GL6_FACE DAT"
rmdir /s /q "%GITHUBPATH%\Build\04-Original files\GL6_FILE DAT"
rmdir /s /q "%GITHUBPATH%\Build\04-Original files\GL6_SCEN DAT"

:: Create 05-Build dir
mkdir "%GITHUBPATH%\Build\05-build"

:: Create the 04-Original files folders for the .DAT files
mkdir "%GITHUBPATH%\Build\04-Original files\GL6_FACE DAT"
mkdir "%GITHUBPATH%\Build\04-Original files\GL6_FILE DAT"
mkdir "%GITHUBPATH%\Build\04-Original files\GL6_SCEN DAT"

:: Switch folder to quickbms and copy the growlanser.bms file to the folder
cd /d "%GITHUBPATH%\Build\02-quickbms 0.11\"
del "%GITHUBPATH%\Build\02-quickbms 0.11\growlanser.bms"
copy /y "%GITHUBPATH%\Tools\GL5 and 6 quickBMS scripts\growlanser.bms" "%GITHUBPATH%\Build\02-quickbms 0.11\growlanser.bms"

:: Start quickBMS to dump the .DAT files contents to the original files folder
quickbms -w growlanser.bms "%GITHUBPATH%\Build\04-Original files\GL6_FACE.DAT" "%GITHUBPATH%\Build\04-Original files\GL6_FACE DAT"
quickbms -w growlanser.bms "%GITHUBPATH%\Build\04-Original files\GL6_FILE.DAT" "%GITHUBPATH%\Build\04-Original files\GL6_FILE DAT"
quickbms -w growlanser.bms "%GITHUBPATH%\Build\04-Original files\GL6_SCEN.DAT" "%GITHUBPATH%\Build\04-Original files\GL6_SCEN DAT"


:::: SLPM_667.16

:: Delete old armips files and copy repository files plus ELF to armips folder
del "%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\SLPM_667.16_translation.asm"
del "%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\SLPM_667.16_VWF.asm"
del "%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\SLPM_667.16"
del "%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\abcde.tbl"
copy /y "%GITHUBPATH%\Source\SLPM_667.16\SLPM_667.16_translation.asm" "%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\SLPM_667.16_translation.asm"
copy /y "%GITHUBPATH%\Source\SLPM_667.16\SLPM_667.16_VWF.asm" "%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\SLPM_667.16_VWF.asm"
copy /y "%GITHUBPATH%\Build\04-Original files\SLPM_667.16" "%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\SLPM_667.16"
copy /y "%GITHUBPATH%\Tools\GL5 and 6 abcde scripts\abcde.tbl" "%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\abcde.tbl"

:: Switch to the armips folder and start the armips script
cd /d "%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86"
armips.exe SLPM_667.16_translation.asm
armips.exe SLPM_667.16_VWF.asm

:: Copy compiled ELF to the main folder
copy /y "%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\SLPM_667.16" "%GITHUBPATH%\Build\SLPM_667.16"


:::: GL6_FACE.DAT

:: delete old FACE.DAT and Copy FACE.DAT from the original files folder to the build folder
del "%GITHUBPATH%\Build\05-build\GL6_FACE.DAT"
copy /y "%GITHUBPATH%\Build\04-Original files\GL6_FACE.DAT" "%GITHUBPATH%\Build\05-build\GL6_FACE.DAT"

:: Delete FACE DAT folder and all its contents, create a new folder with the same name
rmdir /s /q "%GITHUBPATH%\Build\05-build\GL6_FACE DAT"
mkdir "%GITHUBPATH%\Build\05-build\GL6_FACE DAT"
xcopy "%GITHUBPATH%\Build\04-Original files\GL6_FACE DAT" "%GITHUBPATH%\Build\05-build\GL6_FACE DAT\"

:: Copy translated files to the build folder
mkdir "%GITHUBPATH%\Build\05-build\GL6_FACE DAT\00000144 FACE"
copy /y "%GITHUBPATH%\Source\GL6_FACE.DAT\00000144.FACE (TIM2 title cards for Warslee, Rio Rey, PMB HQ)\TRANSLATED 00000000.tm2" "%GITHUBPATH%\Build\05-build\GL6_FACE DAT\00000144 FACE\00000000.tm2"
mkdir "%GITHUBPATH%\Build\05-build\GL6_FACE DAT\00000149 FACE"
copy /y "%GITHUBPATH%\Source\GL6_FACE.DAT\00000149.FACE (TIM2 title cards for Makinus, Dastis, Dragonpit Tower)\TRANSLATED 00000000.tm2" "%GITHUBPATH%\Build\05-build\GL6_FACE DAT\00000149 FACE\00000000.tm2"

:: Switch folder to quickbms and copy the growlanser.bms file to the folder
cd /d "%GITHUBPATH%\Build\02-quickbms 0.11\"
del "%GITHUBPATH%\Build\02-quickbms 0.11\growlanser.bms"
copy /y "%GITHUBPATH%\Tools\GL5 and 6 quickBMS scripts\growlanser.bms" "%GITHUBPATH%\Build\02-quickbms 0.11\growlanser.bms"

:: Start quickBMS XXX.FACE reimport 1 script
quickbms -w -r growlanser.bms "%GITHUBPATH%\Build\05-build\GL6_FACE DAT\00000144.FACE" "%GITHUBPATH%\Build\05-build\GL6_FACE DAT\00000144 FACE"
quickbms -w -r growlanser.bms "%GITHUBPATH%\Build\05-build\GL6_FACE DAT\00000149.FACE" "%GITHUBPATH%\Build\05-build\GL6_FACE DAT\00000149 FACE"

:: Start quickBMS GL6_FACE.DAT reimport 2 script
quickbms -w -r -r growlanser.bms "%GITHUBPATH%\Build\05-build\GL6_FACE.DAT" "%GITHUBPATH%\Build\05-build\GL6_FACE DAT"

:: Move compiled FACE.DAT to main folder
copy /y "%GITHUBPATH%\Build\05-build\GL6_FACE.DAT" "%GITHUBPATH%\Build\GL6_FACE.DAT"


:::: GL6_FILE.DAT

:: delete old FILE.DAT and Copy FILE.DAT from the original files folder to the build folder
del "%GITHUBPATH%\Build\05-build\GL6_FILE.DAT"
copy /y "%GITHUBPATH%\Build\04-Original files\GL6_FILE.DAT" "%GITHUBPATH%\Build\05-build\GL6_FILE.DAT"

:: Delete FILE DAT folder and all its contents, create a new folder with the same name
rmdir /s /q "%GITHUBPATH%\Build\05-build\GL6_FILE DAT"
mkdir "%GITHUBPATH%\Build\05-build\GL6_FILE DAT"

:: Copy the translated FILE.DAT file to the GL6_FILE DAT folder
copy /y "%GITHUBPATH%\Source\GL6_FILE.DAT\00000046.fnt Latin Alphabet and Katakana IMPORTANT\ORIGINAL GL5 ENG 00000046.fnt" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000046.fnt"
copy /y "%GITHUBPATH%\Source\GL6_FILE.DAT\00000602.tm2 GL6 Icons\TRANSLATED 00000602.tm2" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000602.tm2"
copy /y "%GITHUBPATH%\Source\GL6_FILE.DAT\00000604.tm2 Character Menu\TRANSLATED 00000604.tm2" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000604.tm2"
copy /y "%GITHUBPATH%\Source\GL6_FILE.DAT\00000606.tm2 Mission complete screen\TRANSLATED 00000606.tm2" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000606.tm2"
copy /y "%GITHUBPATH%\Source\GL6_FILE.DAT\00000608.tm2 Prologue stats screen\TRANSLATED 00000608.tm2" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000608.tm2"
copy /y "%GITHUBPATH%\Source\GL6_FILE.DAT\00000611.tm2 Yurii Main Menu\TRANSLATED 00000611.tm2" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000611.tm2"
copy /y "%GITHUBPATH%\Source\GL6_FILE.DAT\00000612.tm2 Friend rating screen\TRANSLATED 00000612.tm2" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000612.tm2"
copy /y "%GITHUBPATH%\Source\GL6_FILE.DAT\00000647.tm2 Gem creating screen\TRANSLATED 00000647.tm2" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000647.tm2"

:: Copy and modify the FILE.DAT files that need hexadecimal changes
cd /d "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\"

copy /y "%GITHUBPATH%\Source\GL6_FILE.DAT\00000566.mss Spell casting screen text box coord\00000566.asm" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000566.asm"
copy /y "%GITHUBPATH%\Build\04-Original files\GL6_FILE DAT\00000566.mss" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000566.mss"
"%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\armips.exe" 00000566.asm
del "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000566.asm"

copy /y "%GITHUBPATH%\Source\GL6_FILE.DAT\00000569.mss Yurii Main Menu text box coord\00000569.asm" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000569.asm"
copy /y "%GITHUBPATH%\Build\04-Original files\GL6_FILE DAT\00000569.mss" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000569.mss"
"%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\armips.exe" 00000569.asm
del "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000569.asm"

copy /y "%GITHUBPATH%\Source\GL6_FILE.DAT\00000573.mss Buying and Selling text box coord\00000573.asm" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000573.asm"
copy /y "%GITHUBPATH%\Build\04-Original files\GL6_FILE DAT\00000573.mss" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000573.mss"
"%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\armips.exe" 00000573.asm
del "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000573.asm"

copy /y "%GITHUBPATH%\Source\GL6_FILE.DAT\00000594.mss Equipment change screen\00000594.asm" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000594.asm"
copy /y "%GITHUBPATH%\Build\04-Original files\GL6_FILE DAT\00000594.mss" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000594.mss"
"%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\armips.exe" 00000594.asm
del "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000594.asm"

copy /y "%GITHUBPATH%\Source\GL6_FILE.DAT\00000596.mss Winning screen P to KP modification\00000596.asm" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000596.asm"
copy /y "%GITHUBPATH%\Build\04-Original files\GL6_FILE DAT\00000596.mss" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000596.mss"
"%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\armips.exe" 00000596.asm
del "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000596.asm"

copy /y "%GITHUBPATH%\Source\GL6_FILE.DAT\00000803.dat Additional Plate info text\00000803.asm" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000803.asm"
copy /y "%GITHUBPATH%\Build\04-Original files\GL6_FILE DAT\00000803.dat" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000803.dat"
"%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\armips.exe" 00000803.asm
del "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000803.asm

copy /y "%GITHUBPATH%\Source\GL6_FILE.DAT\00000806.dat Yurii Attributes\00000806.asm" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000806.asm"
copy /y "%GITHUBPATH%\Build\04-Original files\GL6_FILE DAT\00000806.dat" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000806.dat"
"%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\armips.exe" 00000806.asm
del "%GITHUBPATH%\Build\05-build\GL6_FILE DAT\00000806.asm

:: Switch folder to quickbms and copy the growlanser.bms file to the folder
cd /d "%GITHUBPATH%\Build\02-quickbms 0.11\"
del "%GITHUBPATH%\Build\02-quickbms 0.11\growlanser.bms"
copy /y "%GITHUBPATH%\Tools\GL5 and 6 quickBMS scripts\growlanser.bms" "%GITHUBPATH%\Build\02-quickbms 0.11\growlanser.bms"

:: Start quickBMS GL6_FILE.DAT reimport 2 script
quickbms -w -r -r growlanser.bms "%GITHUBPATH%\Build\05-build\GL6_FILE.DAT" "%GITHUBPATH%\Build\05-build\GL6_FILE DAT"

:: Move compiled FILE.DAT to main folder
copy /y "%GITHUBPATH%\Build\05-build\GL6_FILE.DAT" "%GITHUBPATH%\Build\GL6_FILE.DAT"


::::SCEN.DAT

:: delete old SCEN.DAT and Copy SCEN.DAT from the original files folder to the build folder
del "%GITHUBPATH%\Build\05-build\GL6_SCEN.DAT"
copy /y "%GITHUBPATH%\Build\04-Original files\GL6_SCEN.DAT" "%GITHUBPATH%\Build\05-build\"

:: Delete SCEN DAT folder and all its contents, create a new folder with the same name and
:: copy all files from the original dumped SCEN folder to the build SCEN DAT folder
rmdir /s /q "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT"
mkdir "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT"
xcopy "%GITHUBPATH%\Build\04-Original files\GL6_SCEN DAT" "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\"

:: Copy the "00000001.SCEN.asm" and "00000043.SCEN.asm" armips file and modify the original SCEN files
cd "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\"

copy /y "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000001.SCEN.asm" "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000001.SCEN.asm"
"%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\armips.exe" 00000001.SCEN.asm
del "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000001.SCEN.asm"

copy /y "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000043.SCEN.asm" "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000043.SCEN.asm"
"%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\armips.exe" 00000043.SCEN.asm
del "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000043.SCEN.asm"

:: Switch current folder to the abcde folder, copy the table file and start abcde Atlas
cd /d "%GITHUBPATH%\Build\00-abcde\"
del "%GITHUBPATH%\Build\00-abcde\abcde.tbl"
copy /y "%GITHUBPATH%\Tools\GL5 and 6 abcde scripts\abcde.tbl" "%GITHUBPATH%\Build\00-abcde\abcde.tbl"

perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000000.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000000.SCEN Debug map menu [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000001.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000001.SCEN Debug save room [ONGOING]"
:: perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000002.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000002.SCEN Dummy file"
:: perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000003.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000003.SCEN Dummy file"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000004.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000004.SCEN Debug map (9999) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000005.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000005.SCEN Prologue Tutorial [EDITED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000006.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000006.SCEN CHAPTER 2.3 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000007.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000007.SCEN CHAPTER 3.3 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000008.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000008.SCEN CHAPTER 8.1 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000009.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000009.SCEN CHAPTER 8.3 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000010.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000010.SCEN CHAPTER 12.2 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000011.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000011.SCEN CHAPTER 14.2 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000012.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000012.SCEN CHAPTER 15.2 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000013.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000013.SCEN Debug [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000014.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000014.SCEN CHAPTER 7.3 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000015.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000015.SCEN CHAPTER 16.2 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000016.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000016.SCEN CHAPTER 2.5 (below Dastis City) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000017.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000017.SCEN CHAPTER 7.4 (Pothrad Cave) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000018.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000018.SCEN CHAPTER 7.5 (Transgate center) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000019.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000019.SCEN CHAPTER 8.4 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000020.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000020.SCEN CHAPTER 11.1 (Resistance hideout) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000021.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000021.SCEN CHAPTER 13.2 (Yarstill Prison) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000022.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000022.SCEN CHAPTER 12.1 (Giant) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000023.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000023.SCEN CHAPTER 15.3 (El Hingis HQ) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000024.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000024.SCEN CHAPTER 18.1 (Dragon Tower) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000025.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000025.SCEN CHAPTER 19.1 (Celestial ship) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000026.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000026.SCEN CHAPTER 9.2 (Underground ancient ship) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000027.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000027.SCEN CHAPTER 9.4 (Past Kaiser Island) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000028.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000028.SCEN CHAPTER 4.1 (Ship to Goatland) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000029.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000029.SCEN CHAPTER 19.2 (Past Celestial Ship) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000030.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000030.SCEN CHAPTER 14.3 (Makinus City 2) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000031.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000031.SCEN CHAPTER 2.1 (Makinus City) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000032.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000032.SCEN CHAPTER 2.4 (Dastis City) [TRANSLATED]"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000033.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000033.SCEN Dummy file"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000034.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000034.SCEN CHAPTER 3.1 (Schizarz) [TRANSLATED]"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000035.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000035.SCEN Dummy file"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000036.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000036.SCEN CHAPTER 8.2 (Leystan) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000037.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000037.SCEN CHAPTER 13.1 (Leystan 2) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000038.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000038.SCEN CHAPTER 14.3 (Royferon) [TRANSLATED]"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000039.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000039.SCEN Dummy file"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000040.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000040.SCEN CHAPTER 15.1 (El Hingis) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000041.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000041.SCEN CHAPTER 16.3 (Great Land Village) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000042.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000042.SCEN CHAPTER 6.5 (Pothrad village) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000043.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000043.SCEN CHAPTER 1 (Lennox Facility 1) [EDITED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000044.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000044.SCEN CHAPTER 12.3 (Lennox Facility 2) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000045.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000045.SCEN CHAPTER 14.4 (Fomeros HQ) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000046.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000046.SCEN CHAPTER 2.2 (Monopolis HQ) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000047.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000047.SCEN CHAPTER 14.1 (Monopolis HQ 2) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000048.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000048.SCEN CHAPTER 6.3 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000049.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000049.SCEN CHAPTER 5.3 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000050.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000050.SCEN CHAPTER 5.2 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000051.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000051.SCEN CHAPTER 4.7 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000052.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000052.SCEN CHAPTER 4.6 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000053.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000053.SCEN CHAPTER 4.4 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000054.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000054.SCEN CHAPTER 10.6 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000055.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000055.SCEN CHAPTER 10.4 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000056.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000056.SCEN CHAPTER 7.1 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000057.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000057.SCEN CHAPTER 4.3 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000058.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000058.SCEN CHAPTER 10.5 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000059.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000059.SCEN (Fairy's Forest) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000060.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000060.SCEN CHAPTER 17.1 [TRANSLATED]"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000061.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000061.SCEN Dummy file"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000062.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000062.SCEN Dummy file"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000063.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000063.SCEN CHAPTER 17.2 (Juwaina Cave) [TRANSLATED]"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000064.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000064.SCEN Dummy file"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000065.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000065.SCEN CHAPTER X.X (Goatland Cave) [TRANSLATED]"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000066.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000066.SCEN Dummy file"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000067.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000067.SCEN Dummy file"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000068.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000068.SCEN Dummy file"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000069.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000069.SCEN CHAPTER 7.2 (Kaiser Island) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000070.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000070.SCEN (Something related to teleporting) [ONGOING]"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000071.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000071.SCEN Dummy file"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000072.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000072.SCEN (No idea) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000073.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000073.SCEN CHAPTER 10.1 (PMB HQ) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000074.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000074.SCEN CHAPTER 4.2 (Warslee village) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000075.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000075.SCEN CHAPTER 6.4 (Felmentia) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000076.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000076.SCEN CHAPTER X.X (Zerdok) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000077.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000077.SCEN CHAPTER X.X (Rio Rey) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000078.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000078.SCEN CHAPTER 4.5 (Zaramba) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000079.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000079.SCEN CHAPTER 6.1 (Totuwa) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000080.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000080.SCEN CHAPTER 4.8 (Geilenach) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000081.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000081.SCEN CHAPTER X.X (Juwaina) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000082.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000082.SCEN CHAPTER 5.1 (Jaergen) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000083.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000083.SCEN CHAPTER 10.2 (PMB HQ 2) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000084.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000084.SCEN CHAPTER 9.1 (Guardian's Village) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000085.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000085.SCEN (PMB Colosseum 2) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000086.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000086.SCEN CHAPTER X.X (Well extra dungeon) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000087.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000087.SCEN CHAPTER 11.3 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000088.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000088.SCEN Debug map (Class callout check) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000089.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000089.SCEN Debug map (0005) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000090.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000090.SCEN CHAPTER 9.3 (Past Warslee village) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000091.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000091.SCEN CHAPTER 9.5 (Warslee after reconstruction) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000092.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000092.SCEN (something related to Futon Dog) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000093.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000093.SCEN CHAPTER 16.1 (Lennox 3) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000094.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000094.SCEN (something related to Futon Dog) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000095.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000095.SCEN (maybe from GL5) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000096.SCEN" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000096.SCEN CHAPTER 20.1 (Ending) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000097.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000097.SCEC (Yurii Friend Rating screen) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000098.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000098.SCEC (Yurii Event Memo) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000099.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000099.SCEC (Yurii Psych evaluation) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000100.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000100.SCEC game map 1"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000101.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000101.SCEC Dummy file"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000102.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000102.SCEC game map 2"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000103.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000103.SCEC CHAPTER 12.4 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000104.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000104.SCEC (Steed Express) [TRANSLATED]"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000105.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000105.SCEC Dummy file"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000106.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000106.SCEC Debug [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000107.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000107.SCEC CHAPTER 4.9 (Fairy development screen) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000108.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000108.SCEC (Fairy development screen 2) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000109.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000109.SCEC Voice check Debug overview"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000110.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000110.SCEC Voice check Debug"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000111.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000111.SCEC Voice check Debug"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000112.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000112.SCEC Voice check Debug"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000113.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000113.SCEC Voice check Debug"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000114.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000114.SCEC Voice check Debug"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000115.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000115.SCEC Voice check Debug"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000116.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000116.SCEC Voice check Debug"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000117.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000117.SCEC Voice check Debug"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000118.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000118.SCEC Dummy file"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000119.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000119.SCEC Dummy file"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000120.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000120.SCEC Dummy file"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000121.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000121.SCEC Dummy file"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000122.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000122.SCEC Dummy file"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000123.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000123.SCEC Dummy file"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000124.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000124.SCEC Dummy file"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000125.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000125.SCEC Dummy file"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000126.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000126.SCEC (some kind of Steed Express quest) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000127.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000127.SCEC CHAPTER 4.X [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000128.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000128.SCEC (PMB Colosseum) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000129.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000129.SCEC CHAPTER 5.4 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000130.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000130.SCEC CHAPTER 11.4 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000131.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000131.SCEC (no idea) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000132.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000132.SCEC CHAPTER 3.2 (Schizarz 2, Makinus 2) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000133.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000133.SCEC CHAPTER 6.2 (Totuwa 2, Schizarz 3, Leystan 3) [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000134.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000134.SCEC Debug (Motion Check) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000135.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000135.SCEC CHAPTER 14.2 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000136.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000136.SCEC CHAPTER 11.2 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000137.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000137.SCEC CHAPTER 10.3 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000138.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000138.SCEC CHAPTER 18.2 [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000139.SCEC" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000139.SCEC (maybe debug) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000140.SDMY" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000140.SDMY (no idea) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000141.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000141.STXT NPC Names [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000142.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000142.STXT Item Names [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000143.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000143.STXT Monster and Other Character Names [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000144.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000144.STXT Ability Tree [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000145.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000145.STXT Yurii's Skills [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000146.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000146.STXT Spell Names [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000147.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000147.STXT Some more Character Names [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000148.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000148.STXT Plate Names [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000149.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000149.STXT Ability Names [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000150.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000150.STXT Knacks List [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000151.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000151.STXT Item Descriptions [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000152.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000152.STXT Using Key Items [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000153.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000153.STXT Spells Descriptions [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000154.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000154.STXT Knacks Descriptions [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000155.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000155.STXT Ability Descriptions [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000156.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000156.STXT Yurii's Skill Descriptions [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000157.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000157.STXT Menu Help [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000158.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000158.STXT Memory Card Text [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000159.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000159.STXT System Settings Descriptions [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000160.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000160.STXT AI Settings Descriptions [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000161.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000161.STXT Music Appendix [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000162.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000162.STXT Voice Credits [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000163.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000163.STXT System Settings [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000164.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000164.STXT Gem names short [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000165.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000165.STXT (no idea) [ONGOING]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000166.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000166.STXT Gem Names 1 [TRANSLATED]"
::perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000167.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000167.STXT Dummy file"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000168.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000168.STXT Gem Properties [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000169.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000169.STXT Gem Properties Descriptions [TRANSLATED]"
perl abcde.pl -m text2bin -cm abcde::Atlas "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT\00000170.STXT" "%GITHUBPATH%\Source\GL6_SCEN.DAT\00000170.STXT Ore Descriptions [TRANSLATED]"

:: Switch folder to quickbms and copy the growlanser.bms file to the folder
cd /d "%GITHUBPATH%\Build\02-quickbms 0.11\"
del "%GITHUBPATH%\Build\02-quickbms 0.11\growlanser.bms"
copy /y "%GITHUBPATH%\Tools\GL5 and 6 quickBMS scripts\growlanser.bms" "%GITHUBPATH%\Build\02-quickbms 0.11\growlanser.bms"

:: Start the SCEN.DAT script
quickbms -w -r -r growlanser.bms "%GITHUBPATH%\Build\05-build\GL6_SCEN.DAT" "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT"

:: Move compiled SCEN.DAT to main folder
copy /y "%GITHUBPATH%\Build\05-build\GL6_SCEN.DAT" "%GITHUBPATH%\Build\GL6_SCEN.DAT"


:::: Cleanup after all the files have been compiled
del "%GITHUBPATH%\Build\05-build\GL6_FACE.DAT"
rmdir /s /q "%GITHUBPATH%\Build\05-build\GL6_FACE DAT"
rmdir /s /q "%GITHUBPATH%\Build\04-Original files\GL6_FACE DAT"
del "%GITHUBPATH%\Build\05-build\GL6_FILE.DAT"
rmdir /s /q "%GITHUBPATH%\Build\05-build\GL6_FILE DAT"
rmdir /s /q "%GITHUBPATH%\Build\04-Original files\GL6_FILE DAT"
del "%GITHUBPATH%\Build\05-build\GL6_SCEN.DAT"
rmdir /s /q "%GITHUBPATH%\Build\05-build\GL6_SCEN DAT"
rmdir /s /q "%GITHUBPATH%\Build\04-Original files\GL6_SCEN DAT"
rmdir /s /q "%GITHUBPATH%\Build\05-build"
del "%GITHUBPATH%\Build\00-abcde\abcde.tbl"
del "%GITHUBPATH%\Build\02-quickbms 0.11\growlanser.bms"
del "%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\SLPM_667.16_translation.asm"
del "%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\SLPM_667.16_VWF.asm"
del "%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\SLPM_667.16"
del "%GITHUBPATH%\Build\01-armips-v0.11.0-windows-x86\abcde.tbl"