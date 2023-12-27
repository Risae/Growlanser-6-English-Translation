<details> <summary><i>GL5 and 6 TileShop template</i></summary>

`TileShop .FNT Template.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<gdf version="0.8">
	<project name="Growlanser">
		<arranger name="XXXXXX" elementsx="1" elementsy="1" width=">>0x1A<< DEC" height=">>0x1C<< DEC" layout="single" color="indexed" defaultcodec="PSX 4bpp" defaultdatafile="/Growlanser/XXXXXX.fnt">
			<element fileoffset=">>0xC<< HEX" posx="0" posy="0" palette="/Growlanser/XXXXXX.CLUT.0" />
		</arranger>
		<palette name="XXXXXX.CLUT.0" fileoffset=">>0x8<< HEX" datafile="/Growlanser/XXXXXX.fnt" color="RGBA32" entries="16" zeroindextransparent="false" />
		<datafile name="XXXXXX.fnt" location="XXXXXX.fnt" />
	</project>
</gdf>
```

</details>

<details> <summary><i>GL5 and 6 Notepad++ language</i></summary>

`Notepad++ UDL Growlanser (Dracula).xml`

```xml
<NotepadPlus>
    <UserLang name="Growlanser Dracula" ext="" udlVersion="2.1">
        <Settings>
            <Global caseIgnored="yes" allowFoldOfComments="no" foldCompact="no" forcePureLC="0" decimalSeparator="0" />
            <Prefix Keywords1="no" Keywords2="no" Keywords3="no" Keywords4="no" Keywords5="no" Keywords6="no" Keywords7="no" Keywords8="no" />
        </Settings>
        <KeywordLists>
            <Keywords name="Comments"></Keywords>
            <Keywords name="Numbers, prefix1"></Keywords>
            <Keywords name="Numbers, prefix2"></Keywords>
            <Keywords name="Numbers, extras1"></Keywords>
            <Keywords name="Numbers, extras2"></Keywords>
            <Keywords name="Numbers, suffix1"></Keywords>
            <Keywords name="Numbers, suffix2"></Keywords>
            <Keywords name="Numbers, range"></Keywords>
            <Keywords name="Operators1">[ ]</Keywords>
            <Keywords name="Operators2"></Keywords>
            <Keywords name="Folders in code1, open"></Keywords>
            <Keywords name="Folders in code1, middle"></Keywords>
            <Keywords name="Folders in code1, close"></Keywords>
            <Keywords name="Folders in code2, open"></Keywords>
            <Keywords name="Folders in code2, middle"></Keywords>
            <Keywords name="Folders in code2, close"></Keywords>
            <Keywords name="Folders in comment, open"></Keywords>
            <Keywords name="Folders in comment, middle"></Keywords>
            <Keywords name="Folders in comment, close"></Keywords>
            <Keywords name="Keywords1">END-FE END-FF</Keywords>
            <Keywords name="Keywords2">NLINE</Keywords>
            <Keywords name="Keywords3">NWIN</Keywords>
            <Keywords name="Keywords4"></Keywords>
            <Keywords name="Keywords5"></Keywords>
            <Keywords name="Keywords6"></Keywords>
            <Keywords name="Keywords7"></Keywords>
            <Keywords name="Keywords8"></Keywords>
            <Keywords name="Delimiters"></Keywords>
        </KeywordLists>
        <Styles>
            <WordsStyle name="DEFAULT" fgColor="FFFFFF" bgColor="282A36" fontStyle="0" nesting="0" />
            <WordsStyle name="COMMENTS" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="LINE COMMENTS" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="NUMBERS" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="KEYWORDS1" fgColor="FF0000" bgColor="282A36" fontStyle="0" nesting="0" />
            <WordsStyle name="KEYWORDS2" fgColor="00FFFF" bgColor="282A36" fontStyle="0" nesting="0" />
            <WordsStyle name="KEYWORDS3" fgColor="00FF40" bgColor="282A36" fontStyle="0" nesting="0" />
            <WordsStyle name="KEYWORDS4" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="KEYWORDS5" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="KEYWORDS6" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="KEYWORDS7" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="KEYWORDS8" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="OPERATORS" fgColor="FFFFFF" bgColor="282A36" fontStyle="0" nesting="0" />
            <WordsStyle name="FOLDER IN CODE1" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="FOLDER IN CODE2" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="FOLDER IN COMMENT" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="DELIMITERS1" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="DELIMITERS2" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="DELIMITERS3" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="DELIMITERS4" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="DELIMITERS5" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="DELIMITERS6" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="DELIMITERS7" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
            <WordsStyle name="DELIMITERS8" fgColor="000000" bgColor="FFFFFF" fontStyle="0" nesting="0" />
        </Styles>
    </UserLang>
</NotepadPlus>
```

</details>

<details> <summary><i>GL5 and 6 Regular Expressions</i></summary>

These regex patterns can be used to quickly find any issues in the script (missing characters and such). `Notepad++` were used for these. Most of them are also part of the GitHub Actions Pipeline.

## Normal search

#### Find dublicates

```plaintext
[NLINE][NLINE]
[NWIN][NWIN]
[END-FE][END-FE]
[END-FF][END-FF]
..
!!
??
,,
・・
SPACESPACE
SPACEFWSPACE
\r\n \r\n
\r\n  \r\n
]\r\n\r\n//
]\r\n\r\n\r\n//
]\r\n\r\n\r\n\r\n//
]\r\n\r\n\r\n\r\n\r\n//
]\r\n\r\n\r\n\r\n\r\n\r\n\r\n//
```

#### Find space before or after `NLINE`, `NWIN`, `END` and `?`, `!`, `.`, `,`, `・`

```plaintext
 [NLINE]
　[NLINE]
[NLINE] 
[NLINE]　
 [NWIN]
　[NWIN]
[NWIN] 
[NWIN]　
 [END-FF]
　[END-FF]
[END-FF] 
[END-FF]　
 [END-FE]
　[END-FE]
[END-FE] 
[END-FE]　
? 
 ?
! 
 !
. 
 .
, 
 ,
・ 
 ・
```

#### Find unnecessary default (`[COL00]`) color code at the end of a string

```plaintext
[COL00][END-FE]
```

## Regular expression search

#### Find string that is missing `[` inside `[NLINE]`, `[NWIN]` etc

```plaintext
[^[](NLINE])
[^[](NWIN])
[^[](END-FE])
[^[](END-FF])
[^[](COL00])
[^[](COL01])
[^[](COL02])
[^[](COL03])
[^[](COL04])
[^[](COL05])
[^[](COL06])
[^[](COL07])
[^[](COL08])
```

#### Find controls codes that is missing the `]`

```plaintext
\[NLINE[^\]]
\[NWIN[^\]]
\[END-FE[^\]]
\[END-FF[^\]]
\[COL00[^\]]
\[COL01[^\]]
\[COL02[^\]]
\[COL03[^\]]
\[COL04[^\]]
```

#### Finds lines that are missing a `]` at the end

```plaintext
^([^\/#\r\n])+[a-zA-Z][^]]$
```

#### Finds `[` missing in `[CC.XXXX]`

```plaintext
[a-zA-Z0-9\!\?\.\,\(\)](CC\.)
```

#### Find string that is missing `.`, `,`, `!`, `?` before `[NLINE]`, `[NWIN]` etc

```plaintext
^([^\/・\r\n])+[a-zA-Z](\[NLINE\])
^([^\/・\r\n])+[a-zA-Z](\[NWIN\])
^([^\/・\r\n])+[a-zA-Z](\[END-FE\])
^([^\/・\r\n])+[a-zA-Z](\[END-FF\])
```

#### Find string that is missing `[` at the end of the line

```plaintext
^([^\/#\r\n])+[a-zA-Z0-9\"\!\£\$\%\^\&\*\(\)\-\_\=\+]$
```

#### Find `・` that has alphabet characters after it

```plaintext
^([^\/\r\n])+・
・[a-zA-Z0-9\!\?\.\,\(\)]
```

#### Find full width space before and after alphabet characters

```plaintext
^([^\/\r\n])+[　]
[a-zA-Z0-9\!\?\.\,\(\)]　
　[a-zA-Z0-9\!\?\.\,\(\)]
```

#### Find lines longer than `<number>` characters

```plaintext
.{34,}
^([^\/\r\n]){45,}
```

#### Find japanese `？`, `！`, `。`, `、`, `… ` before and after alphabet characters

```plaintext
^([^\/\r\n])+[？]
^([^\/\r\n])+[！]
^([^\/\r\n])+[。]
^([^\/\r\n])+[、]
^([^\/\r\n])+[…]


[a-zA-Z0-9\!\?\.\,\(\)]？
[a-zA-Z0-9\!\?\.\,\(\)]！
[a-zA-Z0-9\!\?\.\,\(\)]。
[a-zA-Z0-9\!\?\.\,\(\)]、
[a-zA-Z0-9\!\?\.\,\(\)]…


？[a-zA-Z0-9\!\?\.\,\(\)]
！[a-zA-Z0-9\!\?\.\,\(\)]
。[a-zA-Z0-9\!\?\.\,\(\)]
、[a-zA-Z0-9\!\?\.\,\(\)]
…[a-zA-Z0-9\!\?\.\,\(\)]
```

#### Finds `（`, `）`, `【`, `】`, `『`, `』`, `《`,` 》` that has alphabet characters after and before it

```plaintext
^([^\/\r\n])+[（]
^([^\/\r\n])+[）]
^([^\/\r\n])+[【]
^([^\/\r\n])+[】]
^([^\/\r\n])+[『]
^([^\/\r\n])+[』]
^([^\/\r\n])+[《]
^([^\/\r\n])+[》]

（[a-zA-Z0-9\!\?\.\,\(\)]
）[a-zA-Z0-9\!\?\.\,\(\)]
【[a-zA-Z0-9\!\?\.\,\(\)]
】[a-zA-Z0-9\!\?\.\,\(\)]
『[a-zA-Z0-9\!\?\.\,\(\)]
』[a-zA-Z0-9\!\?\.\,\(\)]
《[a-zA-Z0-9\!\?\.\,\(\)]
》[a-zA-Z0-9\!\?\.\,\(\)]

[a-zA-Z0-9\!\?\.\,\(\)]（
[a-zA-Z0-9\!\?\.\,\(\)]）
[a-zA-Z0-9\!\?\.\,\(\)]【
[a-zA-Z0-9\!\?\.\,\(\)]】
[a-zA-Z0-9\!\?\.\,\(\)]『
[a-zA-Z0-9\!\?\.\,\(\)]』
[a-zA-Z0-9\!\?\.\,\(\)]《
[a-zA-Z0-9\!\?\.\,\(\)]》
```

#### This one excludes everything that has alphabet characters

```plaintext
(?![a-zA-Z0-9\!\?\.\,\(\)])[？]
(?![a-zA-Z0-9!?])[？！。、]
```

</details>