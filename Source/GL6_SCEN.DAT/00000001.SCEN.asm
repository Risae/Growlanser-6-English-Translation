.open "00000001.SCEN", 0x0
.ps2

/*
The following changes allow the player to interact with the debug save room.
Without those changes it doesn't seem possible to interact with anything in the debug room.

0x1A3C: [F014] -> [0800]
0x2F34: [8003] -> [0800]
0x365E: [1600] -> [0800]
0x367E: [0A00] -> [0800]
0x3694: [DE12] -> [0800]
0x497C: [FC05] -> [0800]
0x4F96: [DC02] -> [0800]
*/

.orga 0x1A3C
	.byte 0x08, 0x00
.orga 0x2F34
	.byte 0x08, 0x00
.orga 0x365E
	.byte 0x08, 0x00
.orga 0x367E
	.byte 0x08, 0x00
.orga 0x3694
	.byte 0x08, 0x00
.orga 0x497C
	.byte 0x08, 0x00
.orga 0x4F96
	.byte 0x08, 0x00

.close