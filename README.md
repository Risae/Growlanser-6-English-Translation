Growlanser 6 is the sequel to Growlanser 5 / Growlanser: Heritage of War. This repository provides a Work-In-Progress English Translation.

To build the English Translation Patch you need:
- The original Growlanser 6 game
- A tool like [Xpert2](https://gbatemp.net/download/xpert2-xpert-tool.37071/) or [Apache2](https://www.psx-place.com/resources/apache-by-sonix-2004.697/) to dump the contents of the ISO

To build the English Translation Patch from source by yourself, create a folder called `04-Original files` inside the `build` folder and put all of the games `*.DAT` files inside it. Use [`build.bat`](/build/build.bat) to patch the original files. Once patched, use tools like Xpert2 to create a patched ISO. Occasionally xDelta patches will be provided on the [Releases](https://github.com/Risae/Growlanser-6-English-Translation/releases) page, which can be used to directly patch the ISO.

Directory structure:

    /source               project files of all native libraries and executables
    /source/GL6_CHAR.DAT  currently just a placeholder
    /source/GL6_FACE.DAT  translated tm2 image files
    /source/GL6_FILE.DAT  translated and modified data files 
    /source/GL6_MAP.DAT   currently just a placeholder
    /source/GL6_MOV.DAT   translated ingame movie files
    /source/GL6_SCEN.DAT  translated script files
    /source/SLPM_667.16   translated and modified ELF
    /build                script and tools needed to patch the original game files
    /tools                tools, scripts and various other things used in the translation of the game
    /translation guide    translation guides and game manuals for the english translation

Growlanser 6 English Translation Blog: https://growlanser6english.blogspot.com/ <br />
Growlanser 6 English Translation Discord: https://discord.gg/59Nw2U2 <br />
Growlanser 5/6 Toolkit: https://github.com/Risae/Growlanser-5-6-Toolkit <br />
Growlanserver Discord: https://discord.gg/uVh3XxRGtG