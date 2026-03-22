.open "00000568.mss", 0x0
.ps2

/*

Base:
0x730, 0x768        STEREO / MONO
0x7A0, 0x7D8            ON / OFF
0x810, 0x848            ON / OFF
0x880, 0x8B8            ON / OFF
0x8F0, 0x928            ON / OFF
0x960, 0x998            ON / OFF
0x9D0, 0xA08            ON / OFF
0xA40, 0xA78       REORDER / AUTO
0xAB0, 0xAE8            ON / OFF
0xB20, 0xB58, 0x0B90   1 / 2 / 3

Base +
0x14 = destination X
0x18 = destination Y
0x1C = destination width
0x20 = destination height
0x24 = source X
0x28 = source Y
0x2C = source width
0x30 = source height

*/

.orga 0x744
    .byte 0x11 // STEREO moved to the left, orig: 0x18


.orga 0xA54
    .byte 0x05 // REORDER moved to the left, orig: 0x26


.orga 0xAFC
    .byte 0x5D // OFF moved to the left, orig: 0x61 - all the other ones are already on 5D and this is a "bug" from the developers

.close