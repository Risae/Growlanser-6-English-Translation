.open "00000596.mss", 0x0
.ps2

/*
0x5F0 is the one for the "P" in the win screen

0x5F0: Texture ID
0x5F4: Ingame position X
0x5F8: Ingame position Y
0x5FC: Ingame width			<-		0x10 > 0x20
0x600: Ingame height
0x604: TM2 texture X		<-		0x120 > 0x15D
0x608: TM2 texture Y
0x60C: TM2 width			<-		0x10 > 0x20
0x610: TM2 height
*/

.orga 0x5FC
	.byte 0x20

.orga 0x604
	.byte 0x15D

.orga 0x60C
	.byte 0x20

.close