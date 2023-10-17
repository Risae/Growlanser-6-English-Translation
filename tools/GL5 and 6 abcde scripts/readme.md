`abcde.tbl` is the table file that abcde's Cartographer and Atlas needs to translate hexadecimal bytes into UTF8 human readable characters.

## Examples for abcde's Cartographer

<details> <summary><i>abcde Cartographer GL6 commands</i></summary>

Only the values for `#POINTER TABLE START:`, `#POINTER TABLE STOP:` and `#BASE POINTER:` need to be inserted.

```
#GAME NAME:		Growlanser 6

#BLOCK NAME:            Dialogue Block (POINTER_RELATIVE)
#TYPE:                  NORMAL
#METHOD:                POINTER_RELATIVE
#POINTER ENDIAN:        LITTLE
#POINTER TABLE START:   $XXXX <---
#POINTER TABLE STOP:    $XXXX <---
#POINTER SIZE:          $04
#POINTER SPACE:         $00
#ATLAS PTRS:            Yes
#BASE POINTER:          $XXXX <---
#TABLE:                 abcde.tbl
#COMMENTS:              Both
#SHOW END ADDRESS:      No
#END BLOCK
```

</details>

<details> <summary><i>abcde Cartographer.bat example</i></summary>

```
perl abcde.pl -m bin2text -t "abcde.tbl" -cm abcde::Cartographer "GAME .SCEN/.SCEC/.STXT FILE" "abcde Cartographer_GL6_commands.txt" Cartographer_GL6_dumped_script_000 -s

pause
```

</details>


## Examples for abcde's Atlas

<details> <summary><i>abcde Atlas GL6 commands template</i></summary>

This example needs to be placed at the top of the file.

```
#VAR(dialogue, TABLE)
#ADDTBL("abcde.tbl", dialogue)
#ACTIVETBL(dialogue)

#VAR(PTR, CUSTOMPOINTER)
#CREATEPTR(PTR, "LINEAR", >>TEXTBLOCK<<, 32)

#VAR(PTRTBL, POINTERTABLE)
#PTRTBL(PTRTBL, >>POINTERSTART<<, 4, PTR)

#JMP(>>TEXTBLOCK<<)
#HDR(>>TEXTBLOCK<<)
```

</details>

<details> <summary><i>abcde Atlas.bat example</i></summary>

```
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "GAME .SCEN/.SCEC/.STXT FILE" "SCRIPT FILE NAME TO BE INSERTED"

pause
```

</details>

<details> <summary><i>abcde Atlas bulk import.bat example</i></summary>

```
set LOGFILE=batch.log
call :LOG > %LOGFILE%
exit /B

:LOG

perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000000.SCEN" "PATH2\00000000.SCEN Debug map menu"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000001.SCEN" "PATH2\00000001.SCEN Debug save room"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000002.SCEN" "PATH2\00000002.SCEN Dummy file"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000003.SCEN" "PATH2\00000003.SCEN Dummy file"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000004.SCEN" "PATH2\00000004.SCEN Debug map (9999)"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000005.SCEN" "PATH2\00000005.SCEN Prologue Tutorial [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000006.SCEN" "PATH2\00000006.SCEN CHAPTER 2.3 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000007.SCEN" "PATH2\00000007.SCEN CHAPTER 3.3 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000008.SCEN" "PATH2\00000008.SCEN CHAPTER 8.1 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000009.SCEN" "PATH2\00000009.SCEN CHAPTER 8.3 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000010.SCEN" "PATH2\00000010.SCEN CHAPTER 12.2 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000011.SCEN" "PATH2\00000011.SCEN CHAPTER 14.2 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000012.SCEN" "PATH2\00000012.SCEN CHAPTER 15.2 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000013.SCEN" "PATH2\00000013.SCEN Debug"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000014.SCEN" "PATH2\00000014.SCEN CHAPTER 7.3 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000015.SCEN" "PATH2\00000015.SCEN CHAPTER 16.2 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000016.SCEN" "PATH2\00000016.SCEN CHAPTER 2.5 (below Dastis City) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000017.SCEN" "PATH2\00000017.SCEN CHAPTER 7.4 (Pothrad Cave) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000018.SCEN" "PATH2\00000018.SCEN CHAPTER 7.5 (Transgate center) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000019.SCEN" "PATH2\00000019.SCEN CHAPTER 8.4 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000020.SCEN" "PATH2\00000020.SCEN CHAPTER 11.1 (Resistance hideout) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000021.SCEN" "PATH2\00000021.SCEN CHAPTER 13.2 (Yarstill Prison) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000022.SCEN" "PATH2\00000022.SCEN CHAPTER 12.1 (Giant) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000023.SCEN" "PATH2\00000023.SCEN CHAPTER 15.3 (El Hingis HQ) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000024.SCEN" "PATH2\00000024.SCEN CHAPTER 18.1 (Dragon Tower) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000025.SCEN" "PATH2\00000025.SCEN CHAPTER 19.1 (Celestial ship) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000026.SCEN" "PATH2\00000026.SCEN CHAPTER 9.2 (Underground ancient ship) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000027.SCEN" "PATH2\00000027.SCEN CHAPTER 9.4 (Past Kaiser Island) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000028.SCEN" "PATH2\00000028.SCEN CHAPTER 4.1 (Ship to Goatland) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000029.SCEN" "PATH2\00000029.SCEN CHAPTER 19.2 (Past Celestial Ship) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000030.SCEN" "PATH2\00000030.SCEN CHAPTER 14.3 (Makinus City 2) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000031.SCEN" "PATH2\00000031.SCEN CHAPTER 2.1 (Makinus City) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000032.SCEN" "PATH2\00000032.SCEN CHAPTER 2.4 (Dastis City) [ONGOING]"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000033.SCEN" "PATH2\00000033.SCEN Dummy file"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000034.SCEN" "PATH2\00000034.SCEN CHAPTER 3.1 (Schizarz) [ONGOING]"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000035.SCEN" "PATH2\00000035.SCEN Dummy file"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000036.SCEN" "PATH2\00000036.SCEN CHAPTER 8.2 (Leystan) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000037.SCEN" "PATH2\00000037.SCEN CHAPTER 13.1 (Leystan 2) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000038.SCEN" "PATH2\00000038.SCEN CHAPTER 14.3 (Royferon) [ONGOING]"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000039.SCEN" "PATH2\00000039.SCEN Dummy file"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000040.SCEN" "PATH2\00000040.SCEN CHAPTER 15.1 (El Hingis) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000041.SCEN" "PATH2\00000041.SCEN CHAPTER 16.3 (Great Land Village) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000042.SCEN" "PATH2\00000042.SCEN CHAPTER 6.5 (Pothrad village) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000043.SCEN" "PATH2\00000043.SCEN CHAPTER 1 (Lennox Facility 1) [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000044.SCEN" "PATH2\00000044.SCEN CHAPTER 12.3 (Lennox Facility 2) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000045.SCEN" "PATH2\00000045.SCEN CHAPTER 14.4 (Fomeros HQ) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000046.SCEN" "PATH2\00000046.SCEN CHAPTER 2.2 (Monopolis HQ) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000047.SCEN" "PATH2\00000047.SCEN CHAPTER 14.1 (Monopolis HQ 2) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000048.SCEN" "PATH2\00000048.SCEN CHAPTER 6.3 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000049.SCEN" "PATH2\00000049.SCEN CHAPTER 5.3 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000050.SCEN" "PATH2\00000050.SCEN CHAPTER 5.2 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000051.SCEN" "PATH2\00000051.SCEN CHAPTER 4.7 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000052.SCEN" "PATH2\00000052.SCEN CHAPTER 4.6 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000053.SCEN" "PATH2\00000053.SCEN CHAPTER 4.4 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000054.SCEN" "PATH2\00000054.SCEN CHAPTER 10.6 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000055.SCEN" "PATH2\00000055.SCEN CHAPTER 10.4 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000056.SCEN" "PATH2\00000056.SCEN CHAPTER 7.1 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000057.SCEN" "PATH2\00000057.SCEN CHAPTER 4.3 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000058.SCEN" "PATH2\00000058.SCEN CHAPTER 10.5 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000059.SCEN" "PATH2\00000059.SCEN"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000060.SCEN" "PATH2\00000060.SCEN CHAPTER 17.1 [ONGOING]"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000061.SCEN" "PATH2\00000061.SCEN Dummy file"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000062.SCEN" "PATH2\00000062.SCEN Dummy file"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000063.SCEN" "PATH2\00000063.SCEN CHAPTER 17.2 (Juwaina Cave) [ONGOING]"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000064.SCEN" "PATH2\00000064.SCEN Dummy file"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000065.SCEN" "PATH2\00000065.SCEN CHAPTER X.X (Goatland Cave) {ONGOING]"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000066.SCEN" "PATH2\00000066.SCEN Dummy file"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000067.SCEN" "PATH2\00000067.SCEN Dummy file"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000068.SCEN" "PATH2\00000068.SCEN Dummy file"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000069.SCEN" "PATH2\00000069.SCEN CHAPTER 7.2 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000070.SCEN" "PATH2\00000070.SCEN"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000071.SCEN" "PATH2\00000071.SCEN Dummy file"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000072.SCEN" "PATH2\00000072.SCEN"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000073.SCEN" "PATH2\00000073.SCEN CHAPTER 10.1 (PMB HQ) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000074.SCEN" "PATH2\00000074.SCEN CHAPTER 4.2 (Warslee village) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000075.SCEN" "PATH2\00000075.SCEN CHAPTER 6.4 (Felmentia) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000076.SCEN" "PATH2\00000076.SCEN CHAPTER X.X (Zerdok) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000077.SCEN" "PATH2\00000077.SCEN CHAPTER X.X (Rio Rey) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000078.SCEN" "PATH2\00000078.SCEN CHAPTER 4.5 (Zaramba) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000079.SCEN" "PATH2\00000079.SCEN CHAPTER 6.1 (Totuwa) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000080.SCEN" "PATH2\00000080.SCEN CHAPTER 4.8 (Geilenach) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000081.SCEN" "PATH2\00000081.SCEN CHAPTER X.X (Juwaina) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000082.SCEN" "PATH2\00000082.SCEN CHAPTER 5.1 (Jaergen) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000083.SCEN" "PATH2\00000083.SCEN CHAPTER 10.2 (PMB HQ 2) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000084.SCEN" "PATH2\00000084.SCEN CHAPTER 9.1 (Guardian's Village) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000085.SCEN" "PATH2\00000085.SCEN"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000086.SCEN" "PATH2\00000086.SCEN CHAPTER X.X (Well extra dungeon) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000087.SCEN" "PATH2\00000087.SCEN CHAPTER 11.3 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000088.SCEN" "PATH2\00000088.SCEN Debug map"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000089.SCEN" "PATH2\00000089.SCEN Debug map (0005)"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000090.SCEN" "PATH2\00000090.SCEN CHAPTER 9.3 (Past Warslee village) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000091.SCEN" "PATH2\00000091.SCEN CHAPTER 9.5 (Warslee after reconstruction) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000092.SCEN" "PATH2\00000092.SCEN"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000093.SCEN" "PATH2\00000093.SCEN CHAPTER 16.1 (Lennox 3) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000094.SCEN" "PATH2\00000094.SCEN"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000095.SCEN" "PATH2\00000095.SCEN"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000096.SCEN" "PATH2\00000096.SCEN CHAPTER 20.1 (Ending) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000097.SCEC" "PATH2\00000097.SCEC"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000098.SCEC" "PATH2\00000098.SCEC"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000099.SCEC" "PATH2\00000099.SCEC"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000100.SCEC" "PATH2\00000100.SCEC game map 1"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000101.SCEC" "PATH2\00000101.SCEC Dummy file"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000102.SCEC" "PATH2\00000102.SCEC game map 2"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000103.SCEC" "PATH2\00000103.SCEC CHAPTER 12.4 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000104.SCEC" "PATH2\00000104.SCEC (Steed Merchant)"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000105.SCEC" "PATH2\00000105.SCEC Dummy file"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000106.SCEC" "PATH2\00000106.SCEC Debug"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000107.SCEC" "PATH2\00000107.SCEC CHAPTER 4.9 (Fairy development screen) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000108.SCEC" "PATH2\00000108.SCEC"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000109.SCEC" "PATH2\00000109.SCEC Voice check Debug overview"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000110.SCEC" "PATH2\00000110.SCEC Voice check Debug"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000111.SCEC" "PATH2\00000111.SCEC Voice check Debug"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000112.SCEC" "PATH2\00000112.SCEC Voice check Debug"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000113.SCEC" "PATH2\00000113.SCEC Voice check Debug"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000114.SCEC" "PATH2\00000114.SCEC Voice check Debug"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000115.SCEC" "PATH2\00000115.SCEC Voice check Debug"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000116.SCEC" "PATH2\00000116.SCEC Voice check Debug"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000117.SCEC" "PATH2\00000117.SCEC Voice check Debug"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000118.SCEC" "PATH2\00000118.SCEC Dummy file"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000119.SCEC" "PATH2\00000119.SCEC Dummy file"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000120.SCEC" "PATH2\00000120.SCEC Dummy file"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000121.SCEC" "PATH2\00000121.SCEC Dummy file"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000122.SCEC" "PATH2\00000122.SCEC Dummy file"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000123.SCEC" "PATH2\00000123.SCEC Dummy file"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000124.SCEC" "PATH2\00000124.SCEC Dummy file"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000125.SCEC" "PATH2\00000125.SCEC Dummy file"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000126.SCEC" "PATH2\00000126.SCEC"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000127.SCEC" "PATH2\00000127.SCEC CHAPTER 4.X [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000128.SCEC" "PATH2\00000128.SCEC"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000129.SCEC" "PATH2\00000129.SCEC CHAPTER 5.4 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000130.SCEC" "PATH2\00000130.SCEC CHAPTER 11.4 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000131.SCEC" "PATH2\00000131.SCEC"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000132.SCEC" "PATH2\00000132.SCEC CHAPTER 3.2 (Schizarz 2, Makinus 2) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000133.SCEC" "PATH2\00000133.SCEC CHAPTER 6.2 (Totuwa 2, Schizarz 3, Leystan 3) [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000134.SCEC" "PATH2\00000134.SCEC"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000135.SCEC" "PATH2\00000135.SCEC CHAPTER 14.2 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000136.SCEC" "PATH2\00000136.SCEC CHAPTER 11.2 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000137.SCEC" "PATH2\00000137.SCEC CHAPTER 10.3 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000138.SCEC" "PATH2\00000138.SCEC CHAPTER 18.2 [ONGOING]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000139.SCEC" "PATH2\00000139.SCEC"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000140.SDMY" "PATH2\00000140.SDMY"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000141.STXT" "PATH2\00000141.STXT NPC Names [TRANSLATED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000142.STXT" "PATH2\00000142.STXT Item Names [TRANSLATED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000143.STXT" "PATH2\00000143.STXT Monster and Other Character Names [TRANSLATED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000144.STXT" "PATH2\00000144.STXT Ability Tree [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000145.STXT" "PATH2\00000145.STXT Yurii's Skills [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000146.STXT" "PATH2\00000146.STXT Spell Names [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000147.STXT" "PATH2\00000147.STXT Some more Character Names [TRANSLATED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000148.STXT" "PATH2\00000148.STXT Plate Names [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000149.STXT" "PATH2\00000149.STXT Ability Names [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000150.STXT" "PATH2\00000150.STXT Knacks List [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000151.STXT" "PATH2\00000151.STXT Item Descriptions [TRANSLATED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000152.STXT" "PATH2\00000152.STXT Using Key Items [TRANSLATED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000153.STXT" "PATH2\00000153.STXT Spells Descriptions [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000154.STXT" "PATH2\00000154.STXT Knacks Descriptions [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000155.STXT" "PATH2\00000155.STXT Ability Descriptions [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000156.STXT" "PATH2\00000156.STXT Yurii's Skill Descriptions [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000157.STXT" "PATH2\00000157.STXT Menu Help [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000158.STXT" "PATH2\00000158.STXT Memory Card Text [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000159.STXT" "PATH2\00000159.STXT System Settings Descriptions [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000160.STXT" "PATH2\00000160.STXT AI Settings Descriptions [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000161.STXT" "PATH2\00000161.STXT Music Appendix [TRANSLATED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000162.STXT" "PATH2\00000162.STXT Voice Credits [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000163.STXT" "PATH2\00000163.STXT System Settings [COMPLETED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000164.STXT" "PATH2\00000164.STXT Gem names short [TRANSLATED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000165.STXT" "PATH2\00000165.STXT"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000166.STXT" "PATH2\00000166.STXT Gem Names 1 [COMPLETED]"
::perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000167.STXT" "PATH2\00000167.STXT Dummy file"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000168.STXT" "PATH2\00000168.STXT Gem Properties [TRANSLATED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000169.STXT" "PATH2\00000169.STXT Gem Properties Descriptions [TRANSLATED]"
perl abcde.pl -m text2bin -t "abcde.tbl" -cm abcde::Atlas "PATH1\00000170.STXT" "PATH2\00000170.STXT Ore Descriptions [TRANSLATED]"

pause
```

</details>