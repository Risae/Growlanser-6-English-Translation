These regex patterns can be used to quickly find any issues in the script (missing characters and such). `Notepad++` were used for these.

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