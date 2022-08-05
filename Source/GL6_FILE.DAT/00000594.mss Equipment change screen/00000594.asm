.open "00000594.mss", 0x0
.ps2

/*
The equipping armor/weapons and removing them has 3 strings of text.
In both equipping and removing those coordinate values are being used:

0x220 - 1st string
0x258 - 2nd string
0x290 - 3rd string

TextureID -> (-1 in this case, cuz it's only text)
In-game X ?
In-game Y

ELF Code that grabs the value of the Y position of 1st and 2nd string: 
Location: (ingame 0x33B4FC)
[4C0140C4] - lwc1 f00,0x14C(v0)

Location: (ingame 0x33B55C)
[700140C4] - lwc1 f00,0x170(v0)

The Y Position of the 1st and 2nd string will be switched:
0x228: 0x0D -> 0x23
0x260: 0x23 -> 0x0D
*/

.orga 0x228
	.byte 0x23

.orga 0x260
	.byte 0x0D

.close