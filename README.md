Growlanser 6 is the sequel to Growlanser 5 / Growlanser: Heritage of War. This repository provides a Work-In-Progress English Translation.

In order to patch your original Growlanser 6 Game you can use the xDelta patches which you can find on the [Releases](https://github.com/Risae/Growlanser-6-English-Translation/releases). In order to build the patch by yourself you can reference the [buildrelease.yml](https://github.com/Risae/Growlanser-6-English-Translation/blob/main/.github/workflows/buildrelease.yml).

Directory structure:

    /.github/workflows      GitHub Actions script to create xDelta patches
    /build                  tools needed to patch the original game files
    /source                 directory which contains all translated files
    /source/GL6_CHAR.DAT    currently just a placeholder
    /source/GL6_FACE.DAT    translated tm2 image files
    /source/GL6_FILE.DAT    translated and modified data files 
    /source/GL6_MAP.DAT     currently just a placeholder
    /source/GL6_MOV.DAT     translated ingame movie files
    /source/GL6_SCEN.DAT    translated script files
    /source/SLPM_667.16     translated and modified ELF
    /tools                  tools, scripts and various other things used in the translation of the game
    /translation guide      translation guides and game manuals for the english translation

## Tools

- [quickBMS](http://aluigi.altervista.org/quickbms.htm)
- [abcde](https://www.romhacking.net/utilities/1392/)
- [armips](https://github.com/Kingcom/armips)
- [Strawberry Perl](https://github.com/StrawberryPerl/Perl-Dist-Strawberry)
- [xdelta](https://github.com/jmacd/xdelta-gpl)
- [PCSX2](https://github.com/PCSX2/pcsx2)
- [Ghidra](https://github.com/NationalSecurityAgency/ghidra)
- [Ghidra Emotion Engine Processor Reloaded](https://github.com/chaoticgd/ghidra-emotionengine-reloaded)

## Special Thanks

- Mako for helping translate a lot of the game's image files
- Ethanol with his never-ending reverse engineering knowledge. You are awesome!
- Aluigi for developing quickBMS and creating the initial quickBMS Growlanser Script, which allowed us to dump the game's files
- adw for helping me get the Atlas and Cartographer Script to work, and for developing abcde
- Naldrag for showing that its possible to add subtitles to the movie files
- Klarth for helping figure out the .fnt files and developing the tool TileShop
- The NSA for making Ghidra Open Source and giving me a better tool to reverse engineer the ELF of the game
- Shokoniraya for creating a quickBMS script that lets me forget all about the worries of having script size restrictions
- A kind soul who provided us with the GL5 demo

And all of the Growlanser fans around the world.

## Links

Growlanser 6 English Translation Blog: https://growlanser6english.blogspot.com/ <br/>
Growlanser 6 English Translation Discord: https://discord.gg/59Nw2U2 <br/>
Growlanser 5/6 Toolkit: https://github.com/Risae/Growlanser-5-6-Toolkit <br/>
Growlanserver Discord: https://discord.gg/uVh3XxRGtG