.open "00000803.dat", 0x0
.ps2

/*
をコピーしました。[0D0A]
has been copied.[0D0A]

はコピーできませんでした。[0D0A]
couldn't be copied.[0D0A]

は取得できません。[0D0A]
cannot be obtained.[0D0A]

をコピーするにはLv1以上必要です。[0D0A]
needs to be Lv1 or higher to copy.[0D0A]

のプレートをはがします。[0D0A]
plate will be removed.[0D0A]

プレートに蓄えられたLvと[0D0A]
The Lv and KP gained for[0D0A]

技能ポイントは失われます。[0D0A]
this plate will be lost.[0D0A]

よろしいですか？
Is this OK?[20][20][20][20][20][20][20][20][20][20][20][20][20][20][20][20]
*/

.orga 0x0
	.ascii "has been copied."
	.byte 0x0D, 0x0A
	.ascii "couldn't be copied."
	.byte 0x0D, 0x0A
	.ascii "cannot be obtained."
	.byte 0x0D, 0x0A
	.ascii "needs to be Lv1 or higher to copy."
	.byte 0x0D, 0x0A
	.ascii "plate will be removed."
	.byte 0x0D, 0x0A
	.ascii "The Lv and KP gained for"
	.byte 0x0D, 0x0A
	.ascii "this plate will be lost."
	.byte 0x0D, 0x0A
	.ascii "Is this OK?"
	.byte 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20

.close