We found various ways to access the debug map of Growlanser 5 and 6. In order to easily access it Ethanol created PCSX2 cheats for almost all Growlanser 5 and 6 versions (excluding the GL5 Demo and GL5 EU).

<details> <summary><i>Growlanser 5/6: How to access the debug map using the PCSX2 debugger</i></summary>

GL5 JPN:
1. Set a breakpoint on `0x00200900`
2. Select `new game`
3. change register `a0` from `2` to `0`

GL5 ENG:
1. Set a breakpoint on `0x0021CA70`
2. Select `new game`
3. change register `a0` from `2` to `0`

GL6:
1. Set a breakpoint on `0x00230938`
2. Select `New Game`
3. The breakpoint will fire, then ctrl+g to `v0-15C8` and change the `05` to a `00`

Press `SELECT` to access the debug menu.
Disable the breakpoint after going to the debug map!

Another way:
Change `0x00431220` to `01` and the new game button loads the map select by itself

How to talk with the debug save map guy:

1. Go to the debug save room
2. Go to `0xEE213C` and change the `0xF014` to `0x0800`

</details>