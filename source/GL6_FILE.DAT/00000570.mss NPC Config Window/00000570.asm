.open "00000570.mss", 0x0
.ps2

/*
AI Magic Use Config Window

0x9AC - 64 -> 74 = background color X value
0xA14 - 65 -> 75 = right line X value
0xA54 - 3C -> 4C = top line X value
0xA8C - 3C -> 4C = bottom line X value
0xAF4 - 54 -> 64 = top right edge X value
0xB64 - 54 -> 64 = bottom right edge X value
*/

.orga 0x9AC
	.word 0x74

.orga 0xA14
	.word 0x75

.orga 0xA54
	.word 0x4C

.orga 0xA8C
	.word 0x4C

.orga 0xAF4
	.word 0x64

.orga 0xB64
	.word 0x64


/*
AI Auto Activate Config Window

0xCD4 - 64 -> 84 = background color X value
0xD3C - 65 -> 85 = right line X value
0xD7C - 3C -> 5C = top line X value
0xDB4 - 3C -> 5C = bottom line X value
0xE1C - 54 -> 74 = top right edge X value
0xE8C - 54 -> 74 = bottom right edge X value
*/

.orga 0xCD4
	.word 0x84

.orga 0xD3C
	.word 0x85

.orga 0xD7C
	.word 0x5C

.orga 0xDB4
	.word 0x5C

.orga 0xE1C
	.word 0x74

.orga 0xE8C
	.word 0x74


.close