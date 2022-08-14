.open "00000043.SCEN", 0x0
.ps2

/*
The following changes allow textboxes to display in the TV advertisement section of the opening.

0x28E6: [D000][C900][D181][0900][D182][D000][C900][D181][0A00] -> [4200][0020][3080][90FF][EE00][497F][A101][AD02][1200]
*/

.orga 0x28E6
	.byte 0x42, 0x00
	.byte 0x00, 0x20
	.byte 0x30, 0x80
	.byte 0x90, 0xFF
	.byte 0xEE, 0x00
	.byte 0x49, 0x7F
	.byte 0xA1, 0x01
	.byte 0xAD, 0x02
	.byte 0x12, 0x00

.close