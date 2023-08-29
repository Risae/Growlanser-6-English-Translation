quickBMS is a tool which allows us to dump and rebuild the game's archive files (for example *.DAT). Think of it like WinZip.

In the beginning of the Translation we used the following quickBMS Script:

```
# Growlanser VI: Precarious World
# script for QuickBMS http://quickbms.aluigi.org

idstring "FLK\0"
get DUMMY long
get ZERO long
get ZERO long
get DUMMY long
get DUMMY long
get FILES long
get DUMMY long
for i = 0 < FILES
    get OFFSET long
    get SIZE long
    log "" OFFSET SIZE
next i
```

<details> <summary><i>quickbms reimport1 - MOV.bat</i></summary>

A reimport example for the MOV files.

```
quickbms -w -r growlanser.bms "<PATH>\GL6_MOV.DAT" "<PATH>\<FOLDER CONTAINING MODIFIED GL6_MOV.DAT FILES"

pause
```

</details>

<details> <summary><i>quickbms reimport2 - FILE.bat</i></summary>

A reimport example for the FILE files.

```
quickbms -w -r -r growlanser.bms "<PATH>\GL6_FILE.DAT" "<PATH>\<FODLDER CONTAINING MODIFIED GL6_FILE.DAT FILES>"

pause
```

</details>

<details> <summary><i>quickbms reimport2 - SCEN.bat</i></summary>

A reimport example for the SCEN files.

```
quickbms -w -r -r growlanser.bms "<PATH>\GL6_SCEN.DAT" "<PATH>\<FOLDER CONTAINING MODIFIED GL6_SCEN.DAT FILES>"

pause
```

</details>