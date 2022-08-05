.open "00000573.mss", 0x0
.ps2

/*
The buying and selling armor/weapons/items has 2 strings of text.
In both buying and selling those coordinate values are being used:

0x15A0 - 1st string
0x15D8 - 2nd string

TextureID -> (-1 in this case, cuz it's only text)
In-game X ?
In-game Y

ELF Code that grabs the value of the Y position of 1st and 2nd string: 
Location: 0x22548C (ingame 0x32540C)
[080060C6] - lwc1 f00,0x8(s3)

Location: 0x2254EC (ingame 0x32546C)
[700140C4] - lwc1 f00,0x190(v0)

The Y Position of the 1st and 2nd string will be switched:
0x15A0: 0x0D -> 0x25
0x15D8: 0x25 -> 0x0D
*/

.orga 0x15A0
	.byte 0x25

.orga 0x15D8
	.byte 0x0D

.close