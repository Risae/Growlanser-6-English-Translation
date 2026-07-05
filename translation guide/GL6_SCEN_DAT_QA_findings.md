# GL6_SCEN.DAT translation QA findings

High-confidence typo, phrasing, and mistranslation findings in `source/GL6_SCEN.DAT`.

## High-confidence fixes

### `source/GL6_SCEN.DAT/00000157.STXT Menu Help [TRANSLATED]`

#### Pointer #3

Current English omits this Japanese rule:

```text
個別の目標をとる攻撃魔法は、射程内に目標がいないと発動できない
```

Current:

```text
If Magic selection is dark, the character is still casting.   Press [L1] and [R1] to switch to other characters.[END-FF]
```

Suggested:

```text
If Magic selection is dark, the character is still casting.   Press [L1] and [R1] to switch to other characters.   Single-target attack spells cannot be cast unless a target is within range.[END-FF]
```

#### Pointer #8

Current English incorrectly mentions MP for knacks:

```text
Press [L2] or [R2] to scroll through knacks.  Press [L1] or [R1] to choose knacks of other Characters.   Knacks that are grayed out can't be cast due to insufficient MP.[END-FF]
```

Suggested:

```text
Press [L2] or [R2] to scroll through knacks.   Press [L1] or [R1] to choose knacks for other characters.   Grayed-out knacks cannot be used.[END-FF]
```

#### Pointer #24

Current:

```text
Press [CROSS] to bring up the options screen.   Press [L1] or [R1] to switch characters.   Press [CIRCLE] to return to the settings menu.[END-FF]
```

Suggested:

```text
Use Up/Down to select an AI setting.   Press [L1] or [R1] to switch characters.   Press [CIRCLE] to return to the settings menu.[END-FF]
```

#### Pointer #29

Current English says left/right confirm the setting, but Japanese says left/right changes the setting.

Suggested:

```text
Use Up/Down to select a setting, and Left/Right to change it.   Press [CIRCLE] to return.[END-FF]
```

#### Pointer #31

English omits `[SQUARE]` help for displaying a plate's learned skills/abilities.

Suggested addition:

```text
Press [SQUARE] to view the plate's learned skills and abilities.
```

#### Pointer #41

English omits `[L2]/[R2]` help for changing the input character type.

Suggested addition:

```text
Press [L2] or [R2] to change the character type.
```

## Scenario mistranslations / phrasing fixes

### `source/GL6_SCEN.DAT/00000047.SCEN CHAPTER 14.1 (Monopolis HQ 2) [TRANSLATED]`

#### Pointer #21

Japanese means drawing the Screapers' attention to the giant, not the giant focusing on the Screaper.

Current:

```text
So the giant will concentrate[NLINE]
on the Screaper.[END-FE]
```

Suggested:

```text
So we'll draw the Screapers'[NLINE]
attention to the giant?[END-FE]
```

#### Pointer #71

Japanese says Shuweizer forced/drove out his father. Current English changes this to following in his father's footsteps.

Suggested:

```text
I heard Lord Shuweizer, who forced[NLINE]
his father out, has collapsed from illness.[NLINE]
His younger sister is acting as[NLINE]
company leader in his place.[END-FE]
```

#### Pointer #73

`会社の上部` refers to upper management/top brass, not the literal top floor.

Suggested:

```text
Management seems to be in a[NLINE]
state of confusion. Is everything[NLINE]
really all right...?[END-FE]
```

### `source/GL6_SCEN.DAT/00000014.SCEN CHAPTER 7.3 [TRANSLATED]`

#### Pointer #20

`少なくとも` means "at least". Current English turns it into "Though there are few of them".

Suggested:

```text
At least the people of the PMB[NLINE]
have been using it to protect peace.[NLINE]
That's why returning it to them[NLINE]
would be best.[END-FE]
```

#### Pointer #28

Japanese says there is someone Rukias wants `[MainCharName]` to meet, not someone Rukias wants to meet first.

Suggested:

```text
Before I explain that, there's[NLINE]
someone I want you to meet after[NLINE]
we've returned to Esgrentz.[NWIN]
```

### `source/GL6_SCEN.DAT/00000006.SCEN CHAPTER 2.3 [TRANSLATED]`

#### Pointer #57

Current English says behavior can be "set to Auto" in the AI Setting menu, but Japanese says behavior while using Auto can be configured there.

Suggested:

```text
You can configure how party members[NLINE]
behave while set to Auto in the[NLINE]
[COL01]"AI Setting"[COL00] menu opened with [START].[END-FE]
```

### `source/GL6_SCEN.DAT/00000050.SCEN CHAPTER 5.2 [TRANSLATED]`

#### Pointer #21

Japanese says a giant Screaper was sighted. Current English makes it plural.

Suggested:

```text
Apparently, a giant Screaper[NLINE]
was sighted there.[END-FE]
```

#### Pointer #45

Japanese says `サウネイル遺跡`, but English says Elphan ruins.

Suggested:

```text
These are the Saunail Ruins.[NLINE]
There's nothing of significance[NLINE]
to be found inside, but it's still[NLINE]
off-limits to the general public.[END-FE]
```

### `source/GL6_SCEN.DAT/00000015.SCEN CHAPTER 16.2 [TRANSLATED]`

#### Pointer #37

Current English is understandable but unnatural.

Suggested:

```text
It looks like preparations[NLINE]
for the assault are finally[NLINE]
complete.[END-FE]
```

#### Pointer #38

Japanese says Screapers have been appearing in the area. Current English makes it sound like a single past appearance.

Suggested:

```text
Screapers have been showing up[NLINE]
around here for a while now. We[NLINE]
should have some people stay outside[NLINE]
and provide backup, right?[END-FE]
```

## Item-name entries worth reviewing

These may be intentional localizations, so review before changing.

### `source/GL6_SCEN.DAT/00000142.STXT Item Names [TRANSLATED]`

| Pointer | Japanese | Current English | Suggested direction |
|---:|---|---|---|
| #1 | 鋼の双刀 | Steel Sword | Steel Twin Blades / Steel Dual Blades |
| #5 | 剣闘士の双剣 | Gladiators | Gladiator Blades |
| #17 | 覇王の剣 | Overlords | Overlord's Sword / Conqueror's Blade |
| #45 | ポールアックス | War Hammer | Poleaxe |
| #51 | 破魔の槍 | Haunting Mourning | Exorcist Spear / Demonbane Spear |

## Smaller style fixes

| File | Current | Suggested |
|---|---|---|
| `00000047.SCEN CHAPTER 14.1`, pointer #43 | `This card key has become suspended.` | `This card key has been suspended.` |
| `00000047.SCEN CHAPTER 14.1`, pointer #43 | `Please swipe a correct card through the scanner.` | `Please swipe the correct card through the scanner.` |
| `00000006.SCEN CHAPTER 2.3`, pointer #58 | `Equipment must be equipped for each party member.` | `Each party member must equip their own gear.` |
| `00000050.SCEN CHAPTER 5.2`, pointer #20 | `Monsters have penetrated into the tunnel.` | `Monsters have gotten into the tunnel.` |
| `00000050.SCEN CHAPTER 5.2`, pointer #16/#54 | `It was destroyed in the war from twenty years ago and became ruins.` | `It was destroyed in the war about twenty years ago and has been in ruins ever since.` |
