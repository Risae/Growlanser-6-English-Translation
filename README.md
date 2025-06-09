Growlanser 6 is the sequel to Growlanser 5 / Growlanser: Heritage of War. This repository provides a Work-In-Progress English Translation.

In order to patch your original Growlanser 6 Game you can use the latest xDelta patch from the[Releases](https://github.com/Risae/Growlanser-6-English-Translation/releases) page. In order to build the patch by yourself you can reference the [buildrelease.yml](https://github.com/Risae/Growlanser-6-English-Translation/blob/main/.github/workflows/buildrelease.yml).

Directory structure:

```
📂.github
└── 📂workflows         GitHub Actions for xDelta patches
📂build                 Tools for patching game files
📂source                Translated files
├── 📂GL6_CHAR.DAT      Placeholder
├── 📂GL6_FACE.DAT      Translated TM2 image files
├── 📂GL6_FILE.DAT      Translated/modified data files
├── 📂GL6_MAP.DAT       Placeholder
├── 📂GL6_MOV.DAT       Translated in-game movie files
├── 📂GL6_SCEN.DAT      Translated script files
└── 📂SLPM_667.16       Translated/modified ELF file
📂tools                 Tools and scripts for translation
📂translation guide     Japanese/English guides and manuals
```

## Tools

- [quickBMS](http://aluigi.altervista.org/quickbms.htm)
- [abcde](https://www.romhacking.net/utilities/1392/)
- [armips](https://github.com/Kingcom/armips)
- [Strawberry Perl](https://github.com/StrawberryPerl/Perl-Dist-Strawberry)
- [xdelta](https://github.com/jmacd/xdelta-gpl)
- [PCSX2](https://github.com/PCSX2/pcsx2)
- [Ghidra](https://github.com/NationalSecurityAgency/ghidra)
- [Ghidra Emotion Engine Processor Reloaded](https://github.com/chaoticgd/ghidra-emotionengine-reloaded)
- [FFmpeg](https://ffmpeg.org/)
- [ps2str](https://archive.org/details/ps2str_v1.08_2001)
- [isotool](https://github.com/lifebottle/PythonLib/blob/main/isotool.py)

## Special Thanks

- Mako for helping translate a lot of the game's image files
- Haruka for translating almost the whole game's japanese script!
- Ethanol with his never-ending reverse engineering knowledge. You are awesome!
- Aluigi for developing quickBMS and creating the initial quickBMS Growlanser Script, which allowed us to dump the game's files
- adw for helping me get the Atlas and Cartographer Script to work, and for developing abcde
- Naldrag for showing that its possible to add subtitles to the movie files
- Klarth for helping figure out the .fnt files and developing the tool TileShop
- The NSA for making Ghidra Open Source and giving me a better tool to reverse engineer the ELF of the game
- Shokoniraya for creating a quickBMS script that lets me forget all about the worries of having script size restrictions
- A kind soul who provided us with the GL5 demo
- ChatGPT and SuperGrok for being a good little bots

And all of the Growlanser fans around the world.

## Links

Growlanser 6 English Translation Blog: https://growlanser6english.blogspot.com/ <br/>
Growlanser 6 English Translation Discord: https://discord.gg/59Nw2U2 <br/>
Growlanser 5/6 Toolkit: https://github.com/Risae/Growlanser-5-6-Toolkit <br/>
Growlanserver Discord: https://discord.gg/uVh3XxRGtG