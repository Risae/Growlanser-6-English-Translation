.open "00000569.mss", 0x0
.ps2

/*
The coordinates are at 0x678. Each one is 4 bytes.
You can edit the "texture" however you want to fit "Treasure Scout".

0x678: Texture ID
0x67C: Ingame position X        <- 0x2F > 0x25
0x680: Ingame position Y
0x684: Ingame width             <- 0x58 > 0x74
0x688: Ingame height
0x68C: TM2 texture X            <- 0x70 > 0x56
0x690: TM2 texture Y
0x694: TM2 width                <- 0x58 > 0x74
0x698: TM2 height
*/

.orga 0x67C
	.byte 0x25

.orga 0x684
	.byte 0x74

.orga 0x68C
	.byte 0x56

.orga 0x694
	.byte 0x74

.close