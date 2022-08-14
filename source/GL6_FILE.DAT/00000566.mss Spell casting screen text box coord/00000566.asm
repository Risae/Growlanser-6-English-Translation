.open "00000566.mss", 0x0
.ps2

/*
The using magic screen is made up of 2 strings of text.

0x3230 - 1st string
0x3268 - 2nd string

TextureID -> (-1 in this case, cuz it's only text)
In-game X ?
In-game Y

ELF Code that grabs the value of the Y position of 1st and 2nd string: 
Location: 0x205A4C (ingame 0x3059CC)
[2C0040C4] - lwc1 f00,0x2C(v0)

Location: 0x205BB0 (ingame 0x305B30)
[500040C4] - lwc1 f00,0x50(v0)

The Y Position of the 1st and 2nd string will be switched:
0x3238: [EDFFFFFF] -> [00000000]
0x3270: [00000000] -> [EDFFFFFF]
*/

.orga 0x3238
	.byte 0x00, 0x00, 0x00, 0x00

.orga 0x3270
	.byte 0xED, 0xFF, 0xFF, 0xFF

.close