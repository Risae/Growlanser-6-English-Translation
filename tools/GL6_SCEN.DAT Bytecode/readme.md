The game uses [`Bytecode`](https://en.wikipedia.org/wiki/Bytecode) to script the ingame events, such as npc conversations. Here is a simple example of a reverse-engineered bytecode:

```
[42000018-Portrait Textbox ??? ][4000-CHAR: Yurii][FA-IMAGE: Yurii??][53-FACE: ???][82-TEXTBOX: Bottom (Pointer up)][00-NAME: STXT][SCRIPTLINE-0022+X]<$49><$7F><$52><$80> [FFFF]
```

We are currently trying to reverse-engineer the bytecode using abcde's multi-table-files feature, but its very slow and clunky.

<details> <summary><i>Old Information</i></summary>

Currently known possible combinations, a complete list can be found in the table file.

### Portrait Textbox ###
42 00 + 0018 + [NPC ID 2 bytes] + [PORTRAIT/IMAGE ID 1 byte] + [FACE EXPRESSION ID 1 byte] + [TEXT BOX + POINTER ID 1 byte] + [NAME SCEN LINE ID 1 byte] + [LINE INDEX 2 Byte (+X)]
Example: 4200 0018 0100 65 F0 82 00 1600

### World Textbox ###
42 00 + 0008 + [NPC ID] + [UNK] + [LINE index (+X)]:
Example: 4200 0008 1501 8000 2200


### Multiple choice? ###
43 00 + [UNK] + [UNK] + [UNK] + [LINE index (+X)]:
Example: 4300 0120 7F80 90FF 2C00


### System Text ###
44 00 + 4200 + 0020 + [UNK] + [UNK] + [LINE index (+X)]:
Example: 4400 4200 0020 7F80 98FF 2A00
		 4400 4200 0020 7F80 98FF 2B00



So, the commands for audio are two 0xD0 and 0xD1
0xD0 selects a "character" and 0xD1 selects a line
These directly correlate with the control codes 0xFFCEXXXX and 0xFFCFXXXX

0x42 + [ 3 bytes of UNK] + [ 2 bytes for NPC ID] + [ 2 bytes of UNK ] + [ 2 bytes of LINE index ]
0x43


- The upper part just before the text is an scripting language of sorts, 0x42 is the command for spawning normal textboxes and 0x43 is for choice text boxes, the bytes after them are parameters from the aggregate the internal representation is derived
- when 0x42 has byte 3 as 0x18 the 8th and 9th bytes become the name's index in the SCEN file, and the 10th byte becomes the line index for the text
- Second byte is the amount of other textboxes that should be on screen, like when you get asked wheter you want to buy or sell
- But just those two seem to spawn a textbox
- the 4th and 5th bytes are the NPC's name ID (so the little arrow knows where to go)
- There are much more than just 0x42 and 0x43 bytes of course (in fact, every number from 0x00 to 0xEE is an opcode)
- Yay! 8th byte from a 0x4200080C pattern is the line number
- There's an index that says which lines belong to which name
- Third byte is window type? All NPC's use 0x08
- The third byte seems to be mode as I guessed before, and the opcode is 16bytes


The currently executing opcode address is always in a0 from 0x23D4F4
You can go to any place, make a savestate
Talk to somebody, go to the address in a0 that just got breakpoint'd
Load the savestate and do your changes before talking to the npc again

</details>