.open "SLPM_667.16", 0x0
.ps2
.loadtable "abcde.tbl"

// This file contains all the translations to the ELF.
// Using the "abcde.tbl" file its possible to make the ".string" a little bit more readable, but not all control codes can be used.

/*
Location: 0x2F6BE0
プレートが生成されました[00]
???

Location: 0x2F6C00
の技能を取得しました[00]
???

Location: 0x2F6C20
がレベルアップしました[00]
???
*/

// To-Do


/*
Location: 0x2FA940
・はい[FFFC][00]
・Yes[FFFC][00]

Location: 0x2FA949
・いいえ[FFFF][00]
・No[FFFF][0000][0000][0000][00]
*/

.orga 0x2FA940
	.string "・Yes", 0xFF, 0xFC, 0x00

.orga 0x2FA948
	.string "・No", 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


/*
Obtained/lost item screen

Location: 0x2FAE90
[FFDF04][FF80][FFDF00]を手に入れた！[FFFE][00]
Obtained [FFDF04][FF80][FFDF00]![FFFE][00]

Location: 0x2FAEB0
[FFDF04][FF80][FFDF00]を[FF81]つ失った。[FFFE][00]
[FF81] lost [FFDF04][FF80][FFDF00].[FFFE][00]

Location: 0x2FAED0
[FFDF01][FFEA][FCFF][FFDF00]に[FFDF04][FFFC][FF80][FFDF00]を盗まれた！[FFFE][00]
[FFDF01][FFEA][FCFF][FFDF00] stole [FFDF04][FFFC][FF80][FFDF00]![FFFE][00]
*/

.orga 0x2FAE90
	.string "Obtained [COL04]", 0xFF, 0x80, "[COL00]!", 0xFF, 0xFE, 0x00, 0x00, 0x00, 0x00


.orga 0x2FAEB0
	.string 0xFF, 0x81, " lost [COL04]", 0xFF, 0x80, "[COL00].", 0xFF, 0xFE, 0x00, 0x00, 0x00, 0x00, 0x00


.orga 0x2FAED0
	.string "[COL01][CC.EAFCFF][COL00] stole [COL04]", 0xFF, 0xFC, 0xFF, 0x80, "[COL00]!", 0xFF, 0xFE, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


/*
Enemie/Ally dies/retreats message

Location: 0x30BFD8
[FF88]が[FF89]を撃破[FFFF][00]
[FF88] defeated [FF89].[FFFF][00]

Location: 0x30BFE8 (Pointer 0x30C0C4 changed: [68BF4000] -> [70BF4000])
[FF88]が死亡[FFFF][00]
[FF88] dead.[FFFF][00]

Location: 0x30BFF8 (Pointer 0x30C0C8 changed: [78BF4000] -> [80BF4000])
[FF88]が退却[FFFF][00]
[FF88] retreated.[FFFF][00]

Location: 0x30C008 (Pointer 0x30C0CC changed: [88BF4000] -> [90BF4000])
[FF88]が増援[FFFF][00]
[FF88] appeared.[FFFF][00]
*/

.orga 0x30BFD8
	.string 0xFF, 0x88, "defeated", 0xFF, 0x89, ".", 0xFF, 0xFF, 0x00


.orga 0x30C0C4
	.byte 0x70, 0xBF, 0x40, 0x00

.orga 0x30BFF0 // Original: 0x30BFE8
	.string 0xFF, 0x88, " dead", 0xFF, 0xFF, 0x00


.orga 0x30C0C8
	.byte 0x80, 0xBF, 0x40, 0x00

.orga 0x30C000 // Original: 0x30BFF8
	.string 0xFF, 0x88, " retreated.", 0xFF, 0xFF, 0x00


.orga 0x30C0C8
	.byte 0x80, 0xBF, 0x40, 0x00

.orga 0x30C010 // Original: 0x30C008
	.string 0xFF, 0x88, " appeared.", 0xFF, 0xFF, 0x00


/*
New condition screen

Location: 0x30C020
クリアー条件が変化[FFFF][00]
New victory conditions.[FFFF][00]

Location: 0x30C040
ゲームオーバー条件が変化[FFFF][00]
New defeat conditions.[FFFF][00]

Location: 0x30C060
勝敗条件が変化[FFFF][00]
Conditions have changed.[FFFF][00]

Location: 0x30C080
[FFDF04][FF88][FFDF00]が増援[FFFF][00]
[FFDF04][FF88][FFDF00] appeared.[FFFF][00]

Location: 0x30C0A0
[FFDF03][FF88][FFDF00]が増援[FFFF][00]
[FFDF03][FF88][FFDF00] appeared.[FFFF][00]
*/

.orga 0x30C020
	.string "New victory conditions.", 0xFF, 0xFF, 0x00

.orga 0x30C040
	.string "New defeat conditions.", 0xFF, 0xFF, 0x00

.orga 0x30C060
	.string "Conditions have changed.", 0xFF, 0xFF, 0x00

.orga 0x30C080
	.string "[COL04]", 0xFF, 0x88, "[COL00] appeared.", 0xFF, 0xFF, 0x00

.orga 0x30C0A0
	.string "[COL03]", 0xFF, 0x88, "[COL00] appeared.", 0xFF, 0xFF, 0x00


/*
Location: 0x30F280
基本形態の巻１１[00]
???

Location: 0x30F2B0
－－－－－－－－
???
*/

//To-Do


/*
Equipment/Gem Menu change text

Location: 0x30F350
防具を外す[00]
Remove[00]

Location: 0x30F360
ジェムを外す[00]
Remove[00]

Location: 0x30F370
[84A5]で決定[8140][00]
???
*/

.orga 0x30F350
	.string "Remove", 0x00, 0x00, 0x00

.orga 0x30F360
	.string "Remove", 0x00, 0x00, 0x00, 0x00, 0x00

// To-Do


/*
Plate level up and other text
Example string: 技能プレートGrow-HealがLvMAXになった！

Location: 0x32A018
を手に入れた！[00]
 obtained![00]

Location: 0x32A028
を盗まれた！[00]
 was stolen![00]

Location: 0x32A040
のプレートを手に入れた！[00]
 obtained![00]

Location: 0x32A060
プレート[00]
[00][00][00]

Location: 0x32A070
Lv[00]
Lv[00]

Location: 0x32A078
MAX[00]
MAX[00]

Location: 0x32A080
を手に入れた[00]
 obtained![00]

Location: 0x32A090
ユリィ[00]
Yurii[00]

Location: 0x32A098
に[00]
???

Location: 0x32A0A0 (Pointer 0x2FAF24 changed: [20A04200] -> [1BA04200])
ポイントを[00]
points increased by [00]

Location: 0x32A0B0
何も持っていなかった！[00]
???

Location: 0x32A0D0
は発動のためのＭＰが不足しています。[FFFC]詠唱を中断します。[00]
???

Location: 0x32A110
が[00]
 became [00]

Location: 0x32A118 (Pointer 0x2FAF34 changed: [98A04200] -> [A0A04200])
になった！[00]
![00]

Location: 0x32A128 (Pointer 0x2FAF38 changed: [A8A04200] -> [A3A04200])
技[00]
Skill Plate [00]
*/

.orga 0x32A018
	.string " obtained!", 0x00, 0x00, 0x00, 0x00

.orga 0x32A028
	.string " was stolen!", 0x00

.orga 0x32A040
	.string " obtained!", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32A060
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32A080
	.string " obtained!", 0x00, 0x00, 0x00

.orga 0x32A090
	.string "Yurii", 0x00, 0x00

// To-Do


.orga 0x2FAF24
	.byte 0x1B, 0xA0, 0x42, 0x00

.orga 0x32A09B // Original: 0x32A0A0
	.string "points increased by "


// To-Do

// To-Do

.orga 0x32A110
	.string " became ", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


.orga 0x2FAF24
	.byte 0xA0, 0xA0, 0x42, 0x00

.orga 0x32A120 // Original: 0x32A118
	.string "!", 0x00


.orga 0x2FAF24
	.byte 0xA3, 0xA0, 0x42, 0x00

.orga 0x32A123 // Original: 0x32A128
	.string "Skill Plate "


/*
Location: 0x32A130
支払った![00]
 paid![00]
*/

.orga 0x32A130
	.string " paid!", 0x00, 0x00


/*
Location: 0x32A140
何も起こらなかった・・・・[00]
???

Location: 0x32A160
フローが変更になりました[00]
???

Location: 0x32A180
を限定解除しました[00]
???
*/

// To-Do


/*
Some gem text

Location: 0x32A1A0
[GEM]を入手しましたが[FFFC]持ち物が一杯です！[FFFC]捨てるジェムを選んでください！[00]
 obtained,[FFFC]but you can't carry any more![FFFC]Choose a gem to throw away![00]

Location: 0x32A1F0
[GEM]を入手しましたが[FFFC]持ちきれませんでした[00]
 obtained, but[FFFC]you can't carry any more[00]

Location: 0x32A220
インパクトにより[FFFC][00]
Impact result[FFFC][00]

Location: 0x32A238
を生成しました[00]
 created[00]

Location: 0x32A248
の[00]
???

Location: 0x32A250
力[00]
???

Location: 0x32A258
＋[00]
???

Location: 0x32A260
になりました[00]
???

Location: 0x32A270
の[FFFC]装着コストが[00]
???

Location: 0x32A288
下がりました[00]
???

Location: 0x32A2A0 (Pointer 0x2FAF74 changed: [20A24200] -> [18A24200])
合成待ちのジェムが[FFFC]合成ボード上にありません[00]
Gems waiting to be synthesized[FFFC]are not on the board[00]
*/

.orga 0x32A1A0
	.string " obtained,", 0xFF, 0xFC, "but you can't carry any more!", 0xFF, 0xFC, "Choose a gem to throw away!"

.orga 0x32A1F0
	.string " obtained, but", 0xFF, 0xFC, "you can't carry any more"

.orga 0x32A220
	.string "Impact result", 0xFF, 0xFC, 0x00, 0x00, 0x00, 0x00

.orga 0x32A238
	.string " created", 0x00, 0x00, 0x00, 0x00, 0x00

// To-Do

// To-Do

// To-Do

// To-Do

// To-Do

// To-Do


.orga 0x2FAF74
	.byte 0x18, 0xA2, 0x42, 0x00

.orga 0x32A298 // Original: 0x32A2A0
	.string "Gems waiting to be synthesized", 0xFF, 0xFC, "are not on the board"


/*
Using attribute increase items

Location: 0x32A2D0
ＳＴＲが[00]
STR [00]

Location: 0x32A2E0
ＩＮＴが[00]
INT [00]

Location: 0x32A2F0
ＤＥＸが[00]
DEX [00]

Location: 0x32A300
カリスマが[00]
CHR [00]

Location: 0x32A310
ＬＶが[00]
Lv [00]

Location: 0x32A318
アップした。[00]
 up.[00]

Location: 0x32A328
ダウンした。[00]
 down.[00]

Location: 0x32A338
ポイント[00]
[00][00]

Location: 0x32A348
取得した。[00]
.[00]
*/

.orga 0x32A2D0
	.string "STR ", 0x00, 0x00, 0x00, 0x00

.orga 0x32A2E0
	.string "INT ", 0x00, 0x00, 0x00, 0x00

.orga 0x32A2F0
	.string "DEX ", 0x00, 0x00, 0x00, 0x00

.orga 0x32A300
	.string "CHR ", 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32A310
	.string "Lv ", 0x00, 0x00, 0x00, 0x00

.orga 0x32A318
	.string " up.", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32A328
	.string " down.", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32A338
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32A348
	.string ".", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


/*
Plate Points received (no idea how to translate this one)
!THERE ARE 2 VARIATIONS! Location: 0x32A128 "Skill plate" is used in one variation!

1.:
装備から生成中のプレートへの
ポイントを15ポイント取得した。

2.:
Skill Plate 能ポイントを250ポイント取得した。

Location: 0x32A360
装備から生成中のプレートへの[00]
Equipped Skill Plate[00]


'能' removal

Location: 0x16E5E0 (ingame 0x26E560)
[9400][0324][0000][43A0][5C00][0324][0100][43A0][0200][40A0][5100][043C][10DC][8424]
[0000][0000][0000][0000][0000][0000][0000][0000][0000][0000][0000][0000][0000][0000]

Other hardcoded text values follow this pattern
li         v1,**
sb         v1,0x0(v0)
li         v1,**
sb         v1,0x1(v0)
sb         zero,0x2(v0)
*/

.orga 0x32A360
	.string "Equipped Skill Plate", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x16E5E0
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


/*
Location: 0x32B460
－－

Location: 0x32B465
－－

Location: 0x32B46A
－－

Location: 0x32B46F
－－

Location: 0x32B478
－－
*/



/*
Various text in and after a fight on the top screen

1 Monster kill result screen: [技能P] -> [KP]
2+ monster Kill result screen: [敵２体] -> [2 enemies]

The enemy numbers are still in full width, needs to be fixed later!

Location: 0x32B728
を撃破[00]
 defeated[00]

Location: 0x32B730
技[00]
[00][00]
Pointer 0x30C14C changed: [B0B64200] -> [B2B64200]
Pointer 0x30C188 changed: [B0B64200] -> [B2B64200]

Location: 0x32B738
P[00]
KP[00]

Location: 0x32B740
が[00]
 [00]

Location: 0x32B748 (Pointer 0x30C164 changed: [C8B64200] -> [C3B64200])
体退却[00]
 retreated[00]

Location: 0x32B750 (Pointer 0x30C168 changed: [D0B64200] -> [CEB64200])
体増援[00]
 appeared[00]

Location: 0x32B758
[FFDF04][00]
[FFDF04][00]

Location: 0x32B760
[FFDF03][00]
[FFDF03][00]

Location: 0x32B768
[FFDF00][00]
[FFDF00][00]

Location: 0x32B770 (Pointer 0x30C178 changed: [F0B64200] -> [ECB64200])
名退却[00]
 retreated[00]

Location: 0x32B778 (Pointer 0x30C17C changed: [F8B64200] -> [F7B64200])
名増援[00]
 appeared[00]

Location: 0x32B780 (Pointer 0x30C180 changed: [00B74200] -> [01B74200])
敵[00]
[00][00]

Location: 0x32B788 (Pointer 0x30C184 changed: [08B74200] -> [07B74200])
体[00]
 enemies[00]

Location: 0x32B790
 Exp:%d %d[00]
 Exp:%d %d[00]

Location: 0x32B7A0
 %d[00]
 %d[00]
*/

.orga 0x32B728
	.string " defeated", 0x00


.orga 0x30C14C
	.byte 0xB2, 0xB6, 0x42, 0x00

.orga 0x30C188
	.byte 0xB2, 0xB6, 0x42, 0x00


.orga 0x32B738
	.string "KP", 0x00

.orga 0x32B740
	.string " ", 0x00


.orga 0x30C164
	.byte 0xC3, 0xB6, 0x42, 0x00

.orga 0x32B743 // Original: 0x32B748
	.string " retreated"


.orga 0x30C168
	.byte 0xCE, 0xB6, 0x42, 0x00

.orga 0x32B74E // Original: 0x32B750
	.string " appeared"


.orga 0x30C178
	.byte 0xEC, 0xB6, 0x42, 0x00

.orga 0x32B76C // Original: 0x32B770
	.string " retreated", 0x00


.orga 0x30C17C
	.byte 0xF7, 0xB6, 0x42, 0x00

.orga 0x32B777 // Original: 0x32B778
	.string " appeared", 0x00


.orga 0x30C180
	.byte 0x01, 0xB7, 0x42, 0x00

.orga 0x32B781 // Original: 0x32B780
	.byte 0x00, 0x00


.orga 0x30C184
	.byte 0x07, 0xB7, 0x42, 0x00

.orga 0x32B787 // Original: 0x32B788
	.string " enemies"


/*
Config Menu text

Location: 0x32BBA0
ステレオ[00]
STEREO[00]

Location: 0x32BBB0
モノラル[00]
MONO[00]

Location: 0x32BBC0
ＯＮ[00]
ON[00]

Location: 0x32BBC8
ＯＦＦ[00]
OFF[00]

Location: 0x32BBD0
再指示[00]
REORDER[00]

Location: 0x32BBD8
ＡＵＴＯ[00]
AUTO[00]
*/

.orga 0x32BBA0
	.string "STEREO", 0x00

.orga 0x32BBB0
	.string "MONO", 0x00, 0x00, 0x00

.orga 0x32BBC0
	.string "ON", 0x00

.orga 0x32BBC8
	.string "OFF", 0x00, 0x00

.orga 0x32BBD0
	.string "REORDER"

.orga 0x32BBD8
	.string "AUTO", 0x00, 0x00, 0x00


/*
Possibly the text bubble over the character icon

Location: 0x32BC28
到着[00]
Arrived[00]

Location: 0x32BC30
行動完了[00]
???

Location: 0x32BC40
待機中[00]
Waiting[00]

Location: 0x32BC48
敵発見[00]
???

Location: 0x32BC50
%s[00]
%s[00]

Location: 0x32BC58
%03d[00]
%03d[00]
*/

.orga 0x32BC28
	.string "Arrived"

// To-Do

.orga 0x32BC40
	.string "Waiting"

// To-Do


/*
Plate Menu

Location: 0x32BCA8
分岐操作[00]
Path Control[00]

Location: 0x32BCB8
フロー変更[00]
???

Location: 0x32BCC8
プレート操作[00]
???

Location: 0x32BCD8
個数[00]
  #[00]
*/

.orga 0x32BCA8
	.string "Path Control"

// To-Do

// To-Do

.orga 0x32BCD8
	.string "  #"


/*
Location: 0x32BD58
・はい[00]
・Yes[00]

Location: 0x32BD60
・いいえ[00]
・No[00]

Location: 0x32BD70
を[00]
[00][00]

Location: 0x32BD78
使用します。[00]
will be used.[00] (GL5: Using)

Location: 0x32BD90
よろしいですか？[00]
Is this okay?[00]
*/

.orga 0x32BD58
	.string "・Yes", 0x00

.orga 0x32BD60
	.string "・No", 0x00, 0x00, 0x00

.orga 0x32BD70
	.byte 0x00, 0x00

.orga 0x32BD78
	.string "will be used.", 0x00

.orga 0x32BD90
	.string "Is this okay?", 0x00, 0x00


/*
Main Menu descriptions

Location: 0x32BED0
グッズ[00]
Items[00]

Location: 0x32BED8
貴重品[00]
Special[00]

Location: 0x32BEE0
武器[00]
Weapons[00]

Location: 0x32BEE8
防具[00]
Armor[00]

Location: 0x32BEF0
ジェム[00]
Gems[00]
*/

.orga 0x32BED0
	.string "Items"

.orga 0x32BED8
	.string "Special"

.orga 0x32BEE0
	.string "Weapons"

.orga 0x32BEE8
	.string "Armor"

.orga 0x32BEF0
	.string "Gems"


/*
Knack Menu amount

Location: 0x32BEF8
残り回数[00]
Remaining[00] (clipping into window, needs to be fixed later)

Item Menu amount

Location: 0x32BF08
所持数[00]
     #[00]
*/

.orga 0x32BEF8
	.string "Remaining"

.orga 0x32BF08
	.string "     #"


/*
Location: 0x32BF10
%s Lv%d[00]
%s Lv%d[00]

Location: 0x32BF18
%s[00]
%s[00]

Location: 0x32BF20
%3d[00]
%3d[00]

Location: 0x32BF28
詠唱時間%3d[00]
???

Location: 0x32BF38
・はい[00]
・Yes[00]

Location: 0x32BF40
・いいえ[00]
・No[00]

Location: 0x32BF50
を使用します。よろしいですか？[00]
???
*/

// To-Do

.orga 0x32BF38
	.string "・Yes", 0x00

.orga 0x32BF40
	.string "・No", 0x00, 0x00, 0x00

// To-Do


/*
Casting Menu

Location: 0x32BF70
を発動待機中[00]
Waiting to activate[00] (GL5: Waiting to activate)
Y-Position was changed - see 00000566.asm

Location: 0x32BF80 (Pointer 0x205C90 changed: [00BFA524] -> [05BFA524])
を詠唱中[00]
Casting[00] (GL5: Casting)
Y-Position was changed - see 00000566.asm
*/

.orga 0x32BF70
	.string "Waiting to activate", 0x00


.orga 0x205C90
	.byte 0x05, 0xBF, 0xA5, 0x24

.orga 0x32BF85 // Original: 0x32BF80
	.string "Casting", 0x00


/*
Spell Menu descriptions

Location: 0x32BF90
消費MP[00]
MP Cost[00]

Location: 0x32BF98
所持金[00]
Money[00]

Location: 0x32BFA0
%6d[00]
%6d[00]

Location: 0x32BFB0
詠唱レベルの設定[00]
Select Magic Level[00]
*/

.orga 0x32BF90
	.string "MP Cost"

.orga 0x32BF98
	.string "Money"

.orga 0x32BFB0
	.string "Select Magic Level"


/*
Equipment Menu text

Location: 0x32C0E8
現在の装備[00]
Equipped[00]

Location: 0x32C0F8
ジェム[00]
Gems[00]

Location: 0x32C100
武器[00]
Weapons[00]

Location: 0x32C108
防具[00]
Armor[00]

Location: 0x32C110
所持/装備[00]
  # / EQ[00]

Location: 0x32C120
装備時間[00]
EQ Time [00]
*/

.orga 0x32C0E8
	.string "Equipped", 0x00

.orga 0x32C0F8
	.string "Gems"

.orga 0x32C100
	.string "Weapons"

.orga 0x32C108
	.string "Armor"

.orga 0x32C110
	.string "  # / EQ"

.orga 0x32C120
	.string "EQ Time "


/*
Money title text?

Location: 0x32C1D8
%c%03d[00]
%c%03d[00]

Location: 0x32C1E0
所持金[00]
Money[00]

Location: 0x32C1E8
%06d[00]
%06d[00]
*/

.orga 0x32C1E0
	.string "Money"


/*
Item Shop descriptions

Location: 0x32C1F0
アイテム名[00]
Item Name[00]

Location: 0x32C200
価格[00]
Price[00]

Location: 0x32C208
%2d[00]
%2d[00]

Location: 0x32C210
%6d[00]
%6d[00]

Location: 0x32C218
このアイテムは[00]
of this item.[00] (Original: "Can't hold any" - affected by the changes in 00000573.asm))

Location: 0x32C230
これ以上持てません[00]
Can't hold any more[00] (Original: "more of this item." - affected by the changes in 00000573.asm)

Location: 0x32C248
%s[00]
%s[00]

Location: 0x32C250
は装備できません[00]
can't be equipped.[00]

Location: 0x32C268
購入しますか？[00]
Buy it?[00]

Location: 0x32C278
・購入する[00]
・Buy[00]

Location: 0x32C288
・やめる[00]
・Cancel[00]
*/

.orga 0x32C1F0
	.string "Item Name"

.orga 0x32C200
	.string "Price"

.orga 0x32C218
	.string "of this item."

.orga 0x32C230
	.string "Can't hold any more"

.orga 0x32C250
	.string "can't be equipped."

.orga 0x32C268
	.string "Buy it?", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32C278
	.string "・Buy", 0x00, 0x00, 0x00, 0x00

.orga 0x32C288
	.string "・Cancel"


/*
Buying and selling window

Location: 0x32C298
を売却します[00]
Selling[00]
Y-Position was changed - see 00000573.asm

Location: 0x32C2A8
を購入します[00]
Buying[00]
Y-Position was changed - see 00000573.asm

Location: 0x32C2B8
・売却する[00]
・Sell[00]

Location: 0x32C2C8
所持  / 最大数[00]
  #   /   MAX[00]

Location: 0x32C2D8
所持  / 装備数[00]
  #   /   EQ[00]

Location: 0x32C2F0
所持数[00]
   #[00]

Location: 0x32C300
・購入後装備を行う[00]
・Buy & equip[00]

Location: 0x32C318
・購入のみ[00]
・Buy[00]
*/

.orga 0x32C298
	.string "Selling", 0x00, 0x00, 0x00, 0x00

.orga 0x32C2A8
	.string "Buying", 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32C2B8
	.string "・Sell", 0x00, 0x00, 0x00

.orga 0x32C2C8
	.string "  #   /    MAX"

.orga 0x32C2D8
	.string "  #   /    EQ", 0x00, 0x00

.orga 0x32C2F0
	.string "   #"

.orga 0x32C300
	.string "・Buy & equip", 0x00, 0x00, 0x00, 0x00

.orga 0x32C318
	.string "・Buy", 0x00, 0x00, 0x00, 0x00


/*
Status screen titles

Location: 0x32C3C8
　　魔　法[00]
   Spell[00]

Location: 0x32C3D8
　　特　技[00]
   Knack[00]

Location: 0x32C3E8
 ス キ ル[00]
   Skill[00]

Location: 0x32C3F8
ジェム効果[00]
Gem Effects[00]

Location: 0x32C408
%s Lv%d[00]
%s Lv%d[00]

Location: 0x32C410
NextExp[00]
NextExp[00]
*/

.orga 0x32C3C8
	.string "   Spell"

.orga 0x32C3D8
	.string "   Knack"

.orga 0x32C3E8
	.string "   Skill"

.orga 0x32C3F8
	.string "Gem Effects"


/*
Money title text?

Location: 0x32C418
所持金[00]
Money[00]

Location: 0x32C420
%5d[00]
%5d[00]

Location: 0x32C428
%6d[00]
%6d[00]

Location: 0x32C430
%s[00]
%s[00]
*/

.orga 0x32C418
	.string "Money"


/*
AI Settings text

Location: 0x32C518
攻撃行動[00]
Attack[00]

Location: 0x32C528
魔法頻度[00]
Magic Use[00]

Location: 0x32C540
ＡＵＴＯの魔法発動[00]
Auto Activate[00]

Location: 0x32C558
魔法傾向[00]
Spell Use[00]

Location: 0x32C568
グッズ制限[00]
Item Use[00]

Location: 0x32C578
主人公に連携[00]
Cooperate[00]

Location: 0x32C588
通常[00]
Normal[00]

Location: 0x32C590
弱い敵を攻撃[00]
Attack Weak[00]

Location: 0x32C5A0
味方を援護[00]
Support Allies[00]

Location: 0x32C5B0 (Pointer 0x30F440 changed: [30C54200] -> [2FC54200])
全力[00]
No Limit[00]

Location: 0x32C5B8
普通[00]
Normal[00]

Location: 0x32C5C0 (Pointer 0x30F448 changed: [40C54200] -> [3FC54200])
控えめ[00]
Reserved[00]

Location: 0x32C5C8
禁止[00]
Never[00]

Location: 0x32C5D0
手動[00]
Manual[00]

Location: 0x32C5D8
半自動[00]
Half-Auto[00]

Location: 0x32C5E0 (Pointer 0x30F458 changed: [60C54200] -> [95C54200])
自動[00]
Automatic[00]

Location: 0x32C5E8
設定[00]
Set[00]

Location: 0x32C5F0
%4d[00]
%4d[00]

Location: 0x32C5F8 (Pointer 0x22E7B4 changed: [78C58424] -> [75C58424])
魔法名[00]
Spell Name[00]

Location: 0x32C600
アイテム名[00]
Item Name[00]

Location: 0x32C610
許可[00]
 FRQ[00]
*/

.orga 0x32C518
	.string "Attack", 0x00

.orga 0x32C528
	.string "Magic Use"

.orga 0x32C540
	.string "Auto Activate", 0x00, 0x00, 0x00, 0x00

.orga 0x32C558
	.string "Spell Use"

.orga 0x32C568
	.string "Item Use", 0x00, 0x00

.orga 0x32C578
	.string "Cooperate", 0x00, 0x00

.orga 0x32C588
	.string "Normal"

.orga 0x32C590
	.string "Attack Weak"

.orga 0x32C5A0
	.string "Support Allies"


.orga 0x30F440
	.byte 0x2F, 0xC5, 0x42, 0x00

.orga 0x32C5AF // Original: 0x32C5B0
	.string "No Limit"


.orga 0x32C5B8
	.string "Normal"


.orga 0x30F440
	.byte 0x3F, 0xC5, 0x42, 0x00

.orga 0x32C5BF // Original: 0x32C5C0
	.string "Reserved"


.orga 0x32C5C8
	.string "Never"

.orga 0x32C5D0
	.string "Manual"

.orga 0x32C5D8
	.string "Half-Auto", 0x00, 0x00


.orga 0x30F440
	.byte 0x95, 0xC5, 0x42, 0x00

.orga 0x32C615 // Original: 0x32C5E0
	.string "Automatic"


.orga 0x32C5E8
	.string "Set"


.orga 0x22E7B4
	.byte 0x75, 0xC5, 0x84, 0x24

.orga 0x32C5F5 // Original: 0x32C5F8
	.string "Spell Name"


.orga 0x32C600
	.string "Item Name"

.orga 0x32C610
	.string " FRQ"


/*
Location: 0x32C960
%%0%dd[00]
%%0%dd[00]

Location: 0x32C968
%s[00]
%s[00]

Location: 0x32C970
Lv%d[00]
Lv%d[00]

Location: 0x32C978
%s を外して[00]
???

Location: 0x32C990
%s を装備します[00]
Equipping %s .[00]

Location: 0x32C9A0
よろしいですか？[00]
Is this OK?[00]

Location: 0x32C9B8
・はい[00]
・Yes[00]

Location: 0x32C9C0
・いいえ[00]
・No[00]
*/

// To-Do

.orga 0x32C990
	.string "Equipping %s ."

.orga 0x32C9A0
	.string "Is this OK?", 0x00, 0x00, 0x00, 0x00

.orga 0x32C9B8
	.string "・Yes", 0x00, 0x00

.orga 0x32C9C0
	.string "・No", 0x00, 0x00, 0x00


/*
Equipment change screen

Location: 0x32C9D0
%s を外します[00]
Removing %s[00]

Location: 0x32C9E0
を装備します[00]
Equipping[00]
Y-Position was changed - see 00000594.asm

Location: 0x32C9F0
を外します[00]
Removing[00]
Y-Position was changed - see 00000594.asm

Location: 0x32CA00
現在の装備[00]
Equipped[00]

Location: 0x32CA10
変更後[00]
After[00]

Location: 0x32CA18
%d%s[00]
%d%s[00]

Location: 0x32CA20
枚目のプレートを決定してください[00]
Plate needs to be chosen[00]
*/

.orga 0x32C9D0
	.string "Removing %s", 0x00

.orga 0x32C9E0
	.string "Equipping", 0x00, 0x00

.orga 0x32C9F0
	.string "Removing", 0x00

.orga 0x32CA00
	.string "Equipped", 0x00

.orga 0x32CA10
	.string "After", 0x00

.orga 0x32CA20
	.string "Plate needs to be chosen", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


/*
Item description screen, titles

Location: 0x32CA48
現在の装備[00]
Equipped[00]

Location: 0x32CA58
武器[00]
Weapons[00]

Location: 0x32CA60
防具[00]
Armor[00]

Location: 0x32CA68
ジェム[00]
Gems[00]
*/

.orga 0x32CA48
	.string "Equipped"

.orga 0x32CA58
	.string "Weapons", 0x00

.orga 0x32CA60
	.string "Armor", 0x00

.orga 0x32CA68
	.string "Gems", 0x00


/*
Yurii Ability Screen

Location: 0x32CA90
%3d[00]
%3d[00]

Location: 0x32CA98
PLM[00]
PLM[00]

Location: 0x32CAA0
物理攻撃防御[00]
Guard Physical[00]

Location: 0x32CAB0
友好度判定[00]
Friend Rating[00]

Location: 0x32CAC0
魔法攻撃防御[00]
Guard Magic[00]

Location: 0x32CAD0
性格判定[00]
Psyche Eval[00]

Location: 0x32CAE0
仕返し[00]
Revenge[00]

Location: 0x32CAE8
宝サーチ[00]
Treasure Scout[00]

Location: 0x32CAF8
独り言[00]
Gabbing[00]

Location: 0x32CB00
値引き交渉[00]
Bargaining[00]

Location: 0x32CB10
イベントメモ[00]
Event Menu[00]

Location: 0x32CB20
Lv%d(MAX)[00]
Lv%d(MAX)[00]

Location: 0x32CB30
Lv%d[00]
Lv%d[00]
*/

.orga 0x32CAA0
	.string "Guard Physical"

.orga 0x32CAB0
	.string "Friend Rating"

.orga 0x32CAC0
	.string "Guard Magic"

.orga 0x32CAD0
	.string "Psyche Eval"

.orga 0x32CAE0
	.string "Revenge"

.orga 0x32CAE8
	.string "Treasure Scout"

.orga 0x32CAF8
	.string "Gabbing"

.orga 0x32CB00
	.string "Bargaining"

.orga 0x32CB10
	.string "Event Menu"


/*
Location: 0x32CB70
のプレートを生成しました[00]
???

Location: 0x32CB90
の技能を修得しました[00]
???

Location: 0x32CBB0
のレベルがアップしました[00]
???

Location: 0x32CBD0
%02d[00]
%02d[00]

Location: 0x32CBD8
%03d[00]
%03d[00]

Location: 0x32CBE0
%d[00]
%d[00]
*/

// To-Do

// To-Do

// To-Do


/*
Winning/Losing condition screen

Location: 0x32CC10
T_M[00]
T_M[00]

Location: 0x32CC18
%s[00]
%s[00]

Location: 0x32CC20
MP %3d/%3d[00]
MP %3d/%3d[00]

Location: 0x32CC30
HP %3d/%3d[00]
HP %3d/%3d[00]

Location: 0x32CC30
HP %3d/%3d[00]
HP %3d/%3d[00]

Location: 0x32CC40
     LV %2d[00]
     LV %2d[00]

Location: 0x32CC50
MP ???/???[00]
MP ???/???[00]

Location: 0x32CC60
HP ???/???[00]
HP ???/???[00]

Location: 0x32CC70
     LV ??[00]
     LV ??[00]

Location: 0x32CC80
クリアー条件[00]
Victory Condition[00]

Location: 0x32CC90 (Pointer 0x24E8DC changed: [10CC8424] -> [18CC8424])
ゲームオーバー条件[00]
Defeat Condition[00]
*/

.orga 0x32CC80
	.string "Victory Condition", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


.orga 0x24E8DC
	.byte 0x18, 0xCC, 0x84, 0x24

.orga 0x32CC98 // Original: 0x32CC90
	.string "Defeat Condition"


/*
Memory Card text

Location: 0x32CCB0
セーブするファイルを選んで下さい[00]
Select file to save over.[00]

Location: 0x32CCE0
ロードするファイルを選んで下さい[00]
Select file to load.[00]

Location: 0x32CD10
空き容量がたりないのでセーブできません[00]
Not enough space to save.[00]

Location: 0x32CD40
データがこわれています[00]
Data is corrupted.[00]

Location: 0x32CD60
スロット１のメモリーカード（ＰＳ２）の[00]
The Memory Card (PS2) in MEMORY CARD slot 1[00]

Location: 0x32CD90
空き容量が１１２ＫＢに満たないためセーブできません。[00]
does not have enough space. Make sure there is 112KB free.[00]
*/

.orga 0x32CCB0
	.string "Select file to save over.", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32CCE0
	.string "Select file to load.", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32CD10
	.string "Not enough space to save.", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32CD40
	.string "Data is corrupted.", 0x00, 0x00, 0x00

.orga 0x32CD60
	.string "The Memory Card (PS2) in MEMORY CARD slot 1"

.orga 0x32CD90
	.string "does not have enough space. Make sure there is 112KB free.", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00


/*
Location: 0x32CDD8
%2d %s[00]
%2d %s[00]

Location: 0x32CDE0
・はい[00]
・Yes[00]

Location: 0x32CDE8
・いいえ[00]
・No[00]

Location: 0x32CDF8
%2d[00]
%2d[00]

Location: 0x32CE00
%3d/%3d[00]
%3d/%3d[00]

Location: 0x32CE08
%s[00]
%s[00]

Location: 0x32CE10
%02d/%2d/%2d %2d:%02d:%02d[00]
%02d/%2d/%2d %2d:%02d:%02d[00]
*/

.orga 0x32CDE0
	.string "・Yes"

.orga 0x32CDE8
	.string "・No", 0x00, 0x00, 0x00


/*
Character creation naming screen text

Location: 0x32D080
ひらがな[00]
Hiragana[00]

Location: 0x32D090
カタカナ[00]
Katakana[00]

Location: 0x32D0A0
英数記号[00]
Alphabet[00]

Location: 0x32D0B0
 漢  字 [00]
Kanji[00]

Location: 0x32D0C0
 削  除 [00]
Delete[00]

Location: 0x32D0D0
 決  定 [00]
Confirm[00]

Location: 0x32D0E0
これでよろしいですか？[00]
Is this OK?[00]

Location: 0x32D0F8
・はい[00]
・Yes[00]

Location: 0x32D100
・いいえ[00]
・No[00]

Location: 0x32D110
この名前は使えません[00]
You can't use this name[00] (GL5: You can't use this name)
*/

.orga 0x32D080
	.string "Hiragana"

.orga 0x32D090
	.string "Katakana"

.orga 0x32D0A0
	.string "Alphabet"

.orga 0x32D0B0
	.string "Kanji"

.orga 0x32D0C0
	.string "Delete"

.orga 0x32D0D0
	.string "Confirm"

.orga 0x32D0E0
	.string "Is this OK?", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32D0F8
	.string "・Yes"

.orga 0x32D100
	.string "・No", 0x00, 0x00, 0x00

.orga 0x32D110
	.string "You can't use this name"


/*
Location: 0x32D160
これでよろしいですか？[00]
Is this OK?[00]

Location: 0x32D178
・はい[00]
・Yes[00]

Location: 0x32D180
・いいえ[00]
・No[00]
*/

.orga 0x32D160
	.string "Is this OK?", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32D178
	.string "・Yes"

.orga 0x32D180
	.string "・No", 0x00, 0x00, 0x00


/*
Location: 0x32D228
・はい[00]
・Yes[00]

Location: 0x32D230
・いいえ[00]
・No[00]
*/

.orga 0x32D228
	.string "・Yes"

.orga 0x32D230
	.string "・No", 0x00, 0x00, 0x00


/*
More memory card text

Location: 0x32D5E0
メモリカードチェック中

Location: 0x32d600
ＰＳ２専用メモリーカード（８ＭＢ）が[0A]ＭＥＭＯＲＹＣＡＲＤ差込口１に[0A]差さっていません。

Location: 0x32d660
ＰＳ２専用メモリーカード（８ＭＢ）が[0A]ＭＥＭＯＲＹＣＡＲＤ差込口２に[0A]差さっていません。

Location: 0x32d6c0
フォーマットされていません[0A]フォーマットしてもよろしいです？　Ｙ／Ｎ

Location: 0x32d710
フォーマット中・・・

Location: 0x32d730
フォーマットに失敗しました。

Location: 0x32d750
新しいファイルを[0A]作成してよろしいですか？　Ｙ／Ｎ

Location: 0x32d788
セーブ中・・・

Location: 0x32d7a0
セーブに失敗しました。

Location: 0x32d7c0
上書きしてよろしいですか？　Ｙ／Ｎ

Location: 0x32d7f0
セーブかんりょう

Location: 0x32d810
ロードしていいか？　Ｙ／Ｎ

Location: 0x32d830
ロード中・・・

Location: 0x32d840
ロードに失敗しました。

Location: 0x32d860
ロードかんりょう

Location: 0x32d880
空き容量が不足しています。[0A]このゲームのデータをセーブするには[0A]ＸＸＫＢ以上必要です。

Location: 0x32d8e0
データはないが、容量が足りてない。

Location: 0x32d910
データはないが、容量は足りている。

Location: 0x32d940
データが壊れていて、容量も足りてない。

Location: 0x32d970
データが壊れているが、容量は足りている。

Location: 0x32d9a0
データがある。

Location: 0x32d9b0
スロットに刺さってない

Location: 0x32d9c8
チェック終了

Location: 0x32d9e0
メモリカード変更されてない

Location: 0x32da00
００

Location: 0x32da08
０１

Location: 0x32da10
０２

Location: 0x32da18
０３

Location: 0x32da20
０４

Location: 0x32da28
０５

Location: 0x32da30
０６

Location: 0x32da38
０７

Location: 0x32da40
０８

Location: 0x32da48
０９

Location: 0x32da50
１０

Location: 0x32da58
１１

Location: 0x32da60
１２

Location: 0x32da68
１３

Location: 0x32da70
１４

Location: 0x32da78
１５

Location: 0x32da80
１６

Location: 0x32da88
１７

Location: 0x32da90
１８

Location: 0x32da98
１９

Location: 0x32daa0
２０

Location: 0x32e2d0
グローランサー６

Location: 0x32e2f0
グローランサー５

Location: 0x32e330
グローランサー６体験版

Location: 0x32e490
グローランサー[8759]のＤＩＳＣをいれてください。
*/

// To-Do


/*
Location: 0x32E768
EFF[00]
EFF[00]

Location: 0x32E770
MAG[00]
MAG[00]

Location: 0x32E778
を撃破 [00]
 defeated[00] (GL5: Defeated X)

Location: 0x32E780
%dEXP %d%c%c %d技%c%cP[00]
%dEXP %d%c%c %d技%c%cKP[00]

Location: 0x32E798
を攻撃開始[00]
 attacked[00] (GL5: Attacking X)

Location: 0x32E7A8
 Lv%d[00]
 Lv%d[00]
*/

.orga 0x32E778
	.string " Defeat"

.orga 0x32E798
	.string " attacked"


/*
Gem creation screen

Location: 0x32E848
とりはずし[00]
Remove[00]

Location: 0x32E858
いれかえ[00]
Replace[00]

Location: 0x32E868
%d%s[00]
%d%s[00]

Location: 0x32E870
個[00] (個 = Pieces)
x[00]

Location: 0x32E878
%s[00]
%s[00]

Location: 0x32E880
個数[00]
  #[00]

Location: 0x32E888
%d[00]
%d[00]

Location: 0x32E890
%2d[00]
%2d[00]

Location: 0x32E898
%s%d[00]
%s%d[00]

Location: 0x32E8A0
Lv[00]
Lv[00]

Location: 0x32E8A8
・はい[00]
・Yes[00]

Location: 0x32E8B0
・いいえ[00]
・No[00]

Location: 0x32E8C0
インパクトを起こします。[00]
Creates an Impact.[00] (Needs to be checked at a later time)

Location: 0x32E8E0
よろしいですか？[00]
Is this okay?[00]

Location: 0x32E900
ジェムを分解します。[00]
Dismantling the gem.[00]
*/

.orga 0x32E848
	.string "Remove", 0x00, 0x00, 0x00

.orga 0x32E858
	.string "Replace"

.orga 0x32E870
	.string "x"

.orga 0x32E880
	.string "  #"

.orga 0x32E8A8
	.string "・Yes"

.orga 0x32E8B0
	.string "・No", 0x00, 0x00, 0x00

.orga 0x32E8C0
	.string "Creates an Impact.", 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32E8E0
	.string "Is this okay?", 0x00, 0x00

.orga 0x32E900
	.string "Dismantling the gem.", 0x00, 0x00, 0x00


/*
Using a Transgate

++++ The game only Supports 2 character of the font that is used here!		++++
++++ FULL WIDTH "M" and "P", see here: https://i.imgur.com/ffdAurg.png		++++
++++ Possible solution: Modify the font file that is used here and			++++
++++ then overwrite some japanese font and use the hex code to write		++++
++++ in normal characters													++++
++++ Other possible solution would be to find the code that points to		++++
++++ the font file and just change it to the one that already has the		++++
++++ right font characters													++++
++++ !RIGHT NOW ITS NOT POSSIBLE TO TRANSLATE THOSE STRINGS!				++++
----																		----
++++ Update: The font file is 00000175.tm2. This font is also used in		++++
++++ the message over the party members icon when you tell a character		++++
++++ to wait to cast a spell												++++
----																		----
++++ Update2: the file that stores the text bubbles texture is 00000602.tm2	++++

Examples:
鉱山街ダスティス に飛びます
よろしいですか？

キャンセルしますが
よろしいですか？


Location: 0x32E920
鉱山街ダスティス[00]
Dastis[00]

Location: 0x32E938
都市マキナス[00]
Makinus[00]

Location: 0x32E950
フォメロス国ロイフェロン[00]
Royferon[00]

Location: 0x32E970
都市レイスタン[00]
Leystan[00]

Location: 0x32E980
ポトラドの里[00]
Pothrad Village[00]

Location: 0x32E990
漁村シザーズ[00]
Schizarz[00]

Location: 0x32E9A0
王都エル・ヒンギス[00]
El Hingis[00]

Location: 0x32E9C0
よろしいですか？[00]
Is this OK?[00]

Location: 0x32E9D8
%s[00]
%s[00]

Location: 0x32E9E0
キャンセルしますが[00]
Canceling.[00]

Location: 0x32E9F8
%s%s[00]
%s%s[00]

Swap parameter of printf %s%s ("[CITY] [TELEPORTING]" -> "[TELEPORTING] [CITY]")
Location: 0x2C7928 (ingame 0x3C78A8)
[0000468C][4300073C][80E9E724][E6A5040C][00000000] (lw  a3,(v0))
[0000478C][4300063C][80E9C624][E6A5040C][00000000] (li  a2,0x0042E980)

Location: 0x32EA00
に飛びます[00]
Teleporting to [00]

Location: 0x32EA10
・はい[00]
・Yes[00]

Location: 0x32EA18
・いいえ[00]
・No[00]
*/

.orga 0x32E920
	.string "Dastis", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32E938
	.string "Makinus", 0x00, 0x00, 0x00, 0x00

.orga 0x32E950
	.string "Royferon", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32E970
	.string "Leystan", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32E980
	.string "Pothrad Village"

.orga 0x32E990
	.string "Schizarz", 0x00, 0x00, 0x00

.orga 0x32E9A0
	.string "El Hingis", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x32E9C0
	.string "Is this OK?", 0x00, 0x00, 0x00, 0x00

.orga 0x32E9E0
	.string "Canceling.", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

.orga 0x2C7928
	.byte 0x00, 0x00, 0x47, 0x8C, 0x43, 0x00, 0x06, 0x3C, 0x80, 0xE9, 0xC6, 0x24, 0xE6, 0xA5, 0x04, 0x0C

.orga 0x32EA00
	.string "Teleporting to "

.orga 0x32EA10
	.string "・Yes"

.orga 0x32EA18
	.string "・No", 0x00, 0x00, 0x00


/*
Throw away a gem to obtain the gem you found (full inventory)

Location: 0x32EA90
捨てるジェムを選んでください[00]
Choose a gem to throw away[00]

Location: 0x32EAB0
%s%s[00]
%s%s[00]

Location: 0x32EAB8
を捨てます[00]
 will be[00]

Location: 0x32EAC8
%s[00]
%s[00]

Location: 0x32EAD0
よろしいですか？[00]
discarded. Is this OK?[00]

Location: 0x32EAE8
・はい[00]
・Yes[00]

Location: 0x32EAF0
・いいえ[00]
・No[00]
*/

.orga 0x32EA90
	.string "Choose a gem to throw away", 0x00

.orga 0x32EAB8
	.string " will be", 0x00

.orga 0x32EAD0
	.string "discarded. Is this OK?"

.orga 0x32EAE8
	.string "・Yes"

.orga 0x32EAF0
	.string "・No", 0x00, 0x00, 0x00


/*
Text ingame that i couldn't find: 赤狼隊隊員
*/

.close