Visit https://growlanser6english.blogspot.com/ and https://discord.gg/59Nw2U2 for more information.

<details> <summary>Source folder</summary>

- `GL6_CHAR.DAT` contains character models
- `GL6_FACE.DAT` contains image files
- `GL6_FILE.DAT` contains image and files
- `GL6_MAP.DAT` contains the map data
- `GL6_MOV.DAT` contains the game cutscenes
- `GL6_SCEN.DAT` contains the script files for Growlanser 6.
- `SLPM_667.16` contains information on changes to the ELF of the game.

Naming convention for `GL6_SCEN.DAT` script files:

- `[ONGOING]` This file still needs to be fully translated
- `[TRANSLATED]` This file has been translated and needs to be edited
- `[EDITED]` This file has been translated and edited and needs to be proofread
- `[PROOFREAD]` This file has been translated, edited and proofread

</details>

<details> <summary>Build folder</summary>

Batch that can compile all the translated repository files into the games .DATs and ELF. The following is a list of files that need to be imported into the .DATs:

`GL_FACE.DAT`

- `00000144.FACE` TIM2 title cards for Warslee, Rio Rey, PMB HQ
	- `00000000.tm2`
- `00000145.FACE` TIM2 title cards for Totuwa. Juwaina, Felmentia
- `00000146.FACE` TIM2 title cards for Zaramba, Zerdok, Geilenach
- `00000147.FACE` TIM2 title cards for Jaergen, XXX, Pothrad Village
- `00000148.FACE` TIM2 title cards for Transgate Center, XXX, XXX
- `00000149.FACE` TIM2 title cards for Makinus, Dastis, Dragonpit Tower
	- `00000000.tm2`
- `00000150.FACE` TIM2 title cards for Schizarz, Leystan, Jian Mountain. El Hingis, Hingistan
- `00000151.FACE` TIM2 title cards for Jian Mountain, Fomeros, Royferon
- `00000152.FACE` TIM2 title cards for XXX, Transgate Center, XXX

`GL6_FILE.DAT`

- `00000046.fnt` Latin Alphabet and Katakana IMPORTANT
- `00000566.mss` Spell casting screen text box coord
- `00000569.mss` Yurii Main Menu text box coord
- `00000573.mss` Buying and Selling text box coord
- `00000594.mss` Equipment change screen
- `00000596.mss` Winning screen P to KP modification
- `00000602.tm2` GL6 Icons
- `00000604.tm2` Character Menu
- `00000606.tm2` Mission complete screen
- `00000608.tm2` Prologue stats screen
- `00000611.tm2` Yurii Main Menu
- `00000612.tm2` Friend rating screen
- `00000647.tm2` Gem creating screen
- `00000803.dat` Additional Plate info text
- `00000806.dat` Yurii Attributes

`GL6_MOV.DAT`

- ?

`GL6_SCEN.DAT`

- Translated SCEN files
- `00000001.SCEN.asm` Modified debug save room 
- `00000043.SCEN.asm` Modified text boxes with voice lines 

`SLPM_667.16`

- `SLPM_667.16_translation.asm` Translation and other fixes for the ELF
- `SLPM_667.16_VWF.asm` VWF for the game

</details>

<details> <summary>Tools folder</summary>

Contains various tools and scripts used in the Growlanser 6 translation.

</details>

<details> <summary>Translation Guide folder</summary>

Contains Translation Guides and Manuals/Game Guides used in the Growlanser 6 translation.

</details>