.open "00000598.mss", 0x0
.ps2

/*
Canceling teleporting window:

LmoveWnd
textbox Y Value: 0x88 - [46]

YesNoWnd
Yes/No textbox X Value: 0x33C - [6E] -> [58]
*/

// To-Do: Textbox needs to be bigger


// Yes/No Window
.orga 0x33C
	.byte 0x58

/*
Teleport screen city text boxes

Dastis:
2nd Part of the textbox X Value: 0x804 - [7E] -> [50]
2nd Part of the textbox Y Value: 0x808 - [7E]
3nd Part of the textbox X Value: 0x86C - [84] -> [56]
Pointer of the textbox X Value: 0x8A4 - [46]
Pointer of the textbox Y Value: 0x8A8 - [F3FFFFFF]

Makinus:
2nd Part of the textbox X Value: 0x8FC - [60] -> [50]
3nd Part of the textbox X Value: 0x964 - [66] -> [56]
Pointer of the textbox X Value: 0x99C - [36]
Pointer of the textbox Y Value: 0x9A0 - [F3FFFFFF]

Royferon:
2nd Part of the textbox X Value: 0x9F4 - [B8] -> [57]
3nd Part of the textbox X Value: 0xA5C - [BE] -> [5C]
Pointer of the textbox X Value: 0xA94 - [2c]
Pointer of the textbox Y Value: 0xA98 - [18]

Leystan:
2nd Part of the textbox X Value: 0xAEC - [74] -> [55]
3nd Part of the textbox X Value: 0xB54 - [7A] -> [5A]
Pointer of the textbox X Value: 0XB8C - [46]
Pointer of the textbox Y Value: 0xB90 - [F3FFFFFF]

Pothrad Village:
2nd Part of the textbox X Value: 0xBE4 - [5E] -> [80]
3nd Part of the textbox X Value: 0xC4C - [64] -> [86]
Pointer of the textbox X Value: 0xC84 - [77] -> [99]
Pointer of the textbox Y Value: 0xC88 - [06]

Schizarz:
2nd Part of the textbox X Value: 0xCDC - [60] -> [57]
3nd Part of the textbox X Value: 0xD44 - [66] -> [5C]
Pointer of the textbox X Value: 0xD7C - [36]
Pointer of the textbox Y Value: 0xD80 - [F3FFFFFF]

El Hingis:
2nd Part of the textbox X Value: 0xDD4 - [8C] -> [55]
3nd Part of the textbox X Value: 0xE3C - [92] -> [5A]
Pointer of the textbox X Value: 0xE74 - [2C]
Pointer of the textbox Y Value: 0xE78 - [18]

*/

// Dastis - To-Do: Move the text more to the right
.orga 0x804
	.byte 0x48

.orga 0x86C
	.byte 0x4D


// Makinus
.orga 0x8FC
	.byte 0x4A

.orga 0x964
	.byte 0x50


// Royferon
.orga 0x9F4
	.byte 0x57

.orga 0xA5C
	.byte 0x5C


// Leystan
.orga 0xAEC
	.byte 0x48

.orga 0xB54
	.byte 0x4E


// Pothrad Village
.orga 0xBE4
	.byte 0x8A

.orga 0xC4C
	.byte 0x90

.orga 0xC84
	.byte 0xA4


// Schizarz
.orga 0xCDC
	.byte 0x4B

.orga 0xD44
	.byte 0x51


// El Hingis
.orga 0xDD4
	.byte 0x55

.orga 0xE3C
	.byte 0x5A

.close