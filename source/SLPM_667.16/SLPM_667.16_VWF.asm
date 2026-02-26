.ps2
.open "SLPM_667.16", 0x00100000
.headersize 0x000FFF80

; ===========================================================================
; Equates
; ===========================================================================
VWFfunct        equ 0x003D7980          ; Custom VWF function
SetTextColor    equ 0x00151670          ; Sets text color
SetTextScale    equ 0x00151890          ; Sets text scaling
DrawLetter      equ 0x001522BC          ; Draws a single letter
DrawTextAt      equ 0x00151840          ; Draws text at specified coordinates
printf          equ 0x129798            ; Formats strings (used for enemy defeat count)

// Fix for the full-width numbers that are displayed when you kill more than 1 enemy at the same time.
.org 0x2C7684                           ; Patching code at address 0x2C7684
    move        a0, v0                  ; Copy the value in register v0 to a0 (presumably holding the number of killed enemies)
    li          a1, 0x42C0C0            ; Address to "%d" string in memory
    move        a2, s3                  ; Copy the value in register s3 to a2 (assuming it's another argument for printf)
    jal         printf                  ; Jump and link to the printf function
    nop                                 ; No operation (delay slot)
    b           0x2C7708                ; Unconditional branch to address 0x2C7708 (skip the next instruction)
    nop                                 ; No operation (delay slot)

.org 0x2C7BC0                           ; Patching code at address 0x2C7BC0
    move        a0, v0                  ; Copy the value in register v0 to a0 (presumably holding the number of killed enemies)
    li          a1, 0x42C0C0            ; Address to "%d" string in memory
    move        a2, s1                  ; Copy the value in register s1 to a2 (assuming it's another argument for printf)
    jal         printf                  ; Jump and link to the printf function
    nop                                 ; No operation (delay slot)
    b           0x02C7C44               ; Unconditional branch to address 0x02C7C44 (skip the next instruction)
    nop                                 ; No operation (delay slot)

/*
Window width set part, is given in characters so the game multiplies the value
by 10d every time it uses it, "simplest" solution is to divide by 10 the largest
line width and round up But I need to create the "get line pixel width" function first
.org 0x002760B0
*/


// Textbox auto-width fix for VWF (safe: only shrinks, never expands)
// Hooks the epilogue of func_00275520 (Calculate_textbox_width) right before it restores registers.
.org 0x0027691C
    j         FixTextboxWidthPreEpilogue
    ld        ra, 0x90(sp)              ; original instruction (delay slot)



//Swap 〇 to Ｘ, code borrowed from PS2 Controller Remapper
.org 0x00121C64
    j         Switcheroo
.org 0x00121CCC
    j         Switcheroo + 0xC

//Gatetext render
.org 0x003C72AC
    jal       RenderSelected

.org 0x003C72E8
    jal       RenderNormal

//Casting and waiting speech bubble
.org 0x003C72E8
    jal       RenderNormal

.org 0x002F5AF0
    jal       RenderNormal

//Make scrolling text use variable width
.org 0x002A36CC
    j         RolloverFix                ; Currently a dummy
    addiu     v1,0x1

.org 0x002A3648
    j         ScrollingFix

.org 0x002A3658
    j         ScrollingFix

.org 0x0031BA9C
    addiu     a2,v0,0x2                  ; Render two characters in advance to account for VWF

//Text centering fix
.org 0x0027E310
    j         CalculateSpace
    nop

//Redirect game's font width function to ours
.org 0x00151DA8
    j         VWFfunct
    nop

.org 0x00152384
    nop

//VWF fixes
.org 0x002792BC
    j         Detoured

.org 0x002792D4
    cvt.w.s   f26,f26                    ; Convert the value in f26 to an integer of the same value
    mfc1      s1,f26                     ; Move to our X value variable (s1)
    addiu     s2,0x1                     ; Add 1 to s1 like in the original
    b         0x00279058                 ; Branch from the original
    nop                                  ; NOP from the original

//VWF function (fixed: detect ASCII using s1, never rely on a3/t0 or -1(s3))
.org VWFfunct
    li        s0, ram
    sw        s1, (s0)                    ; save original s1 (char code)

    andi      s0, s1, 0xFF00              ; high byte set => Shift-JIS / non-ASCII
    bnez      s0, @@Original
    nop

    andi      s1, s1, 0x00FF              ; ASCII index
    li        s0, VWFtable
    addu      s0, s0, s1
    lbu       s0, (s0)
    addiu     s0, 0x2                     ; +2 px padding (match your render VWF)

    mtc1      s0, f23
    nop
    cvt.s.w   f23, f23
    mul.s     f23, f23, f21               ; scale widths

@@Original:
    li        s0, ram
    lw        s1, (s0)                    ; restore s1
    or        s0, zero, zero              ; reset s0

    add.s     f26, f26, f23               ; original overwritten instruction
    addiu     s6, 0x1                     ; original overwritten instruction
    j         0x00151DB0
    nop

; ---------------------------------------------------------------------------
; VWF-aware textbox width shrink (fixes centering / autosize mismatch)
; ---------------------------------------------------------------------------
; At this point (func_00275520 epilogue), $s5 still points to the textbox.
; We compute a VWF-based max line width (in the game's "units") and only shrink
; textbox->windowWidth if it is larger than the VWF result.
;
; Safety: also respects the initial designer width byte at textbox+0x1AA
; (spB0->LineRenderArray[1] in the decomp), so we never shrink below it.
.func FixTextboxWidthPreEpilogue
    daddu     a0, s5, zero
    jal       CalcMaxLineUnitsVWF
    nop

    ; v0 = vwf_units
    lbu       t2, 0x1AA(s5)               ; initial/min width in units (0 => none)
    beqz      t2, @@minOk
    nop
    sltu      t1, v0, t2
    beqz      t1, @@minOk
    nop
    daddu     v0, t2, zero
@@minOk:

    lw        t0, 0x70(s5)                ; current windowWidth (units)
    sltu      t1, v0, t0
    beqz      t1, @@skipStore
    nop
    sw        v0, 0x70(s5)
@@skipStore:

    ld        ra, 0x90(sp)                ; ensure correct return address
    j         0x00276924                  ; continue original epilogue (lq fp, ...)
    nop
.endfunc

; v0 = max line width in "units", computed using VWFtable (ASCII) and 0x14px (SJIS)
; Units conversion: units = ceil(px/10). Then clamped to 0x2C or 0x3C like the original.
;
; Also handles common control codes based on the decomp of func_00275520.
.func CalcMaxLineUnitsVWF
    addiu     sp, sp, -0x20
    sd        ra, 0x00(sp)

    daddu     s6, a0, zero                ; s6 = textbox*
    lw        s0, 0x18C(s6)               ; s0 = text pointer
    beqz      s0, @@ret0
    nop

    daddu     s1, zero, zero              ; curPx
    daddu     s2, zero, zero              ; maxPx
    daddu     s4, zero, zero              ; wideFlag (set by 0xFF 0x90)

    ; capUnits = (flags & 2) ? 0x2C : 0x3C
    lhu       t0, 0x0(s6)
    andi      t0, t0, 0x2
    beqz      t0, @@cap3C
    nop
    li        s7, 0x2C
    b         @@capDone
    nop
@@cap3C:
    li        s7, 0x3C
@@capDone:
    ; s3 = capPx = capUnits * 10
    sll       t1, s7, 3                   ; *8
    sll       t2, s7, 1                   ; *2
    addu      s3, t1, t2                  ; *10

@@loop:
    lbu       t0, 0x0(s0)
    li        t1, 0xFF
    beq       t0, t1, @@ctrl
    nop

    sltiu     t1, t0, 0x80
    beqz      t1, @@sjis
    nop

    ; ASCII -> VWFtable[t0] + 2
    li        t2, VWFtable
    addu      t2, t2, t0
    lbu       t3, 0x0(t2)
    addiu     t3, t3, 0x2
    addu      s1, s1, t3
    addiu     s0, s0, 0x1
    b         @@loop
    nop

@@sjis:
    addiu     s1, s1, 0x14                ; base SJIS width (20px)
    beqz      s4, @@sjis2
    nop
    addiu     s1, s1, 0x14                ; extra +20px when wideFlag set (matches var_s4 behavior)
@@sjis2:
    addiu     s0, s0, 0x2
    b         @@loop
    nop

@@ctrl:
    lbu       t0, 0x1(s0)                 ; control code
    li        t1, 0xFF
    beq       t0, t1, @@end               ; 0xFF 0xFF = end
    nop
    li        t1, 0xFE
    beq       t0, t1, @@end               ; 0xFF 0xFE = end
    nop

    li        t1, 0xFC
    beq       t0, t1, @@newline
    nop
    li        t1, 0xFD
    beq       t0, t1, @@newline
    nop

    li        t1, 0x90
    beq       t0, t1, @@setWide
    nop

    li        t1, 0xFB
    beq       t0, t1, @@skip2
    nop

    ; Width-affecting control codes (use original helper funcs, convert units->px by *10)
    li        t1, 0xEF
    beq       t0, t1, @@ccEF
    nop
    li        t1, 0xEA
    beq       t0, t1, @@ccEA
    nop
    li        t1, 0xE1
    beq       t0, t1, @@ccE1
    nop
    li        t1, 0xE6
    beq       t0, t1, @@ccE6
    nop

    li        t1, 0x81
    beq       t0, t1, @@cc81
    nop

    li        t1, 0x80
    beq       t0, t1, @@cc80_82_83
    nop
    li        t1, 0x82
    beq       t0, t1, @@cc80_82_83
    nop
    li        t1, 0x83
    beq       t0, t1, @@cc80_82_83
    nop

    ; Skip-only control codes (lengths based on the decomp)
    ; 3-byte: E5, DF, DE, D8..D4, C8, B9,B8, B5..AA, AF..AA
    li        t1, 0xE5
    beq       t0, t1, @@skip3
    nop
    li        t1, 0xDF
    beq       t0, t1, @@skip3
    nop
    li        t1, 0xDE
    beq       t0, t1, @@skip3
    nop
    sltiu     t2, t0, 0xD9               ; t0 <= 0xD8 ?
    beqz      t2, @@afterD
    nop
    sltiu     t2, t0, 0xD4               ; t0 < 0xD4 ?
    bnez      t2, @@afterD
    nop
    b         @@skip3                     ; D4..D8
    nop
@@afterD:

    li        t1, 0xC8
    beq       t0, t1, @@skip3
    nop

    li        t1, 0xB8
    beq       t0, t1, @@skip3
    nop
    li        t1, 0xB9
    beq       t0, t1, @@skip3
    nop

    ; AA..B5 and also AB..AF etc are 3-byte
    sltiu     t2, t0, 0xB6
    beqz      t2, @@afterB5
    nop
    sltiu     t2, t0, 0xAA
    bnez      t2, @@afterB5
    nop
    b         @@skip3
    nop
@@afterB5:

    ; 4-byte: CF,CE,CC,BF..BC,B7,B6,9C
    li        t1, 0xCE
    beq       t0, t1, @@skip4
    nop
    li        t1, 0xCF
    beq       t0, t1, @@skip4
    nop
    li        t1, 0xCC
    beq       t0, t1, @@skip4
    nop
    li        t1, 0x9C
    beq       t0, t1, @@skip4
    nop
    sltiu     t2, t0, 0xC0               ; t0 <= BF ?
    beqz      t2, @@afterBF
    nop
    sltiu     t2, t0, 0xBC               ; t0 < BC ?
    bnez      t2, @@afterBF
    nop
    b         @@skip4                     ; BC..BF
    nop
@@afterBF:
    li        t1, 0xB6
    beq       t0, t1, @@skip4
    nop
    li        t1, 0xB7
    beq       t0, t1, @@skip4
    nop

    ; 5-byte: BA,BB
    li        t1, 0xBA
    beq       t0, t1, @@skip5
    nop
    li        t1, 0xBB
    beq       t0, t1, @@skip5
    nop

    ; 2-byte: CD, CB, 80..83,90,FB,FC,FD handled, but CD/CB here
    li        t1, 0xCD
    beq       t0, t1, @@skip2
    nop
    li        t1, 0xCB
    beq       t0, t1, @@skip2
    nop

    ; 7-byte: 9D
    li        t1, 0x9D
    beq       t0, t1, @@skip7
    nop

    ; Unknown => treat as end (matches original default)
    b         @@end
    nop

@@setWide:
    li        s4, 0x1
    addiu     s0, s0, 0x2
    b         @@loop
    nop

@@skip2:
    addiu     s0, s0, 0x2
    b         @@loop
    nop
@@skip3:
    addiu     s0, s0, 0x3
    b         @@loop
    nop
@@skip4:
    addiu     s0, s0, 0x4
    b         @@loop
    nop
@@skip5:
    addiu     s0, s0, 0x5
    b         @@loop
    nop
@@skip7:
    addiu     s0, s0, 0x7
    b         @@loop
    nop

@@ccEF:
    lbu       t2, 0x2(s0)
    sll       a1, t2, 24
    sra       a1, a1, 24
    andi      a1, a1, 0xFFFF
    daddu     a0, s6, zero
    daddu     a2, zero, zero
    daddu     a3, zero, zero
    jal       0x0027FB70
    nop
    sll       t3, v0, 3
    sll       t4, v0, 1
    addu      t3, t3, t4
    addu      s1, s1, t3
    addiu     s0, s0, 0x3
    b         @@loop
    nop

@@ccEA:
    lbu       t2, 0x2(s0)
    sll       a1, t2, 24
    sra       a1, a1, 24
    andi      a1, a1, 0xFFFF
    daddu     a0, s6, zero
    daddu     a2, zero, zero
    daddu     a3, zero, zero
    jal       0x0027F380
    nop
    sll       t3, v0, 3
    sll       t4, v0, 1
    addu      t3, t3, t4
    addu      s1, s1, t3
    addiu     s0, s0, 0x4
    b         @@loop
    nop

@@ccE1:
    lbu       a1, 0x2(s0)
    andi      a1, a1, 0xFFFF
    daddu     a0, s6, zero
    daddu     a2, zero, zero
    daddu     a3, zero, zero
    jal       0x0027ECA0
    nop
    sll       t3, v0, 3
    sll       t4, v0, 1
    addu      t3, t3, t4
    addu      s1, s1, t3
    addiu     s0, s0, 0x3
    b         @@loop
    nop

@@ccE6:
    daddu     a0, s6, zero
    daddu     a1, zero, zero
    daddu     a2, zero, zero
    daddu     a3, zero, zero
    jal       0x0027F760
    nop
    sll       t3, v0, 3
    sll       t4, v0, 1
    addu      t3, t3, t4
    addu      s1, s1, t3
    addiu     s0, s0, 0x3
    b         @@loop
    nop

@@cc80_82_83:
    daddu     a0, s6, zero
    daddu     a1, t0, zero              ; a1 = control code (0x80/0x82/0x83)
    daddu     a2, zero, zero
    daddu     a3, zero, zero
    jal       0x0027E7A0
    nop
    sll       t3, v0, 3
    sll       t4, v0, 1
    addu      t3, t3, t4
    addu      s1, s1, t3
    addiu     s0, s0, 0x2
    b         @@loop
    nop

@@cc81:
    daddu     a0, s6, zero
    daddu     a1, t0, zero              ; a1 = 0x81
    daddu     a2, zero, zero
    daddu     a3, zero, zero
    jal       0x0027E510
    nop
    sll       t3, v0, 3
    sll       t4, v0, 1
    addu      t3, t3, t4
    addu      s1, s1, t3
    addiu     s0, s0, 0x2
    b         @@loop
    nop

@@newline:
    ; clamp curPx to capPx
    sltu      t0, s3, s1
    beqz      t0, @@nlMax
    nop
    daddu     s1, s3, zero
@@nlMax:
    sltu      t0, s2, s1
    beqz      t0, @@nlReset
    nop
    daddu     s2, s1, zero
@@nlReset:
    daddu     s1, zero, zero
    addiu     s0, s0, 0x2
    b         @@loop
    nop

@@end:
    ; update max with final curPx
    sltu      t0, s2, s1
    beqz      t0, @@calc
    nop
    daddu     s2, s1, zero

@@calc:
    addiu     t0, s2, 0x9
    li        t1, 10
    divu      t0, t1
    mflo      v0                        ; units = ceil(px/10)

    ; clamp to capUnits (s7)
    sltu      t2, s7, v0
    beqz      t2, @@ret
    nop
    daddu     v0, s7, zero

@@ret:
    ld        ra, 0x00(sp)
    addiu     sp, sp, 0x20
    jr        ra
    nop

@@ret0:
    daddu     v0, zero, zero
    ld        ra, 0x00(sp)
    addiu     sp, sp, 0x20
    jr        ra
    nop
.endfunc


.func Detoured
    cvt.w.s   f26,f26
    mfc1      s1,f26
    j         0x2792C0
    nop
.endfunc

.func ScrollingFix
    cvt.w.s   f26,f26
    mfc1      s3,f26
    j         0x002A3660
    nop
.endfunc

.func RolloverFix
    j         0x002A36D4
    nop
.endfunc

//TO-DO fix first-line text centering
//and make character width calculation
//its own thing, to fix textbox width
//calculation with the VWF (inside 0x275520)
//that'd need investigation, too many branches
.func CalculateSpace
    dmove     s1,v1
    lbu       s2,0x1A8(s0)               ; line counter
    lw        s4,0x18C(s0)               ; Load line address into s4
    li        s5,VWFtable                ; Load VWFtable
    lbu       s2,(s4)
    bne       s2,0xFF,@@loop
    nop
    lbu       s2,0x1(s4)
    bne       s2,0xFC,@@Loop             ; If first tag is a new line, skip 2 bytes
    nop
    addiu     s4,0x2

    @@Loop:
    lbu       s6,(s4)
    beq       s6,0xFF,@@ControlCodes     ; GOTO Control chars...
    nop
    sltiu     s2,s6,0x0080
    bnez      s2,@@Adder                 ; GOTO Add ASCII widths
    nop
    addiu     s4,0x2
    addiu     s7,0x14                    ; Japanese char width
    b         @@Loop
    nop

    @@ControlCodes:
    lbu       s6,0x01(s4)
    beql      s6,0xDF,@@Loop             ; Color tag
    addiu     s4,0x3
    beql      s6,0xCE,@@Loop             ; Sound Bank tag
    addiu     s4,0x4
    beql      s6,0xCF,@@Loop             ; Sound Index tag
    addiu     s4,0x4
    beql      s6,0xEA,@@CalculateName    ; Main Character tag
    addiu     s4,0x4
    b         @@End                      ; Exit early on unknown tag
    nop

    @@CalculateName:
    lhu       s6,-0x2(S4)
    bne       s6,0x1,@@Loop              ; Not MC's name, skip
    nop
    sw        s4,-0x4(sp)
    li        s4,0x50E8B2                ; MC's name (0xFF terminated)

    @@NameLoop:
    lbu       s6,(s4)
    beql      s6,0xFF,@@Loop
    lw        s4,-0x4(sp)
    ;Duplicated efforts for now
    addu      s6,s5,s6
    lbu       s6,(s6)
    addu      s7,s6
    addiu     s7,0x2                     ; Add the 2 pixels to each letter
    addiu     s4,0x1
    b         @@NameLoop
    nop

    @@Adder:
    addu      s6,s5,s6
    lbu       s6,(s6)
    addu      s7,s6
    addiu     s7,0x2                     ; Add the 2 pixels to each letter
    addiu     s4,0x1
    b         @@Loop
    nop

    // Basically: ((((line_width - window_width) + 1) / 2) + 4) / 8 (math rounded)
    // A more precise solution would be using an special (invisible) char followed
    // by a number that equals (line_width - window_width) / 2, so we avoid the hard
    // character limit
    @@End:
    dmove     s2,a1                     ; a1 = window width
    sll       s6,s2,0x02
    addu      s6,s6,s2
    sll       s6,s6,0x1
    subu      s6,s7
    addiu     s6,0x1
    sra       s1,s6,0x01
    addiu     s1,0x4
    sra       s1,0x3
    dmove     s2,zero
    dmove     s4,zero
    dmove     s5,zero
    dmove     s6,zero
    dmove     s7,zero
    j         0x0027E318                ; Go back to original function
    nop
.endfunc

.func RenderNormal
    li        v0, Ram                   ; Load immediate: v0 = Ram
    sw        a0, 0x4(v0)               ; Store word: *(Ram + 4) = a0
    sw        ra, 0x8(v0)               ; Store word: *(Ram + 8) = ra
    li        a0, 0x7                   ; Load immediate: a0 = 0x7 (black)
    jal       SetTextColor              ; Jump and link: Call SetTextColor function
    nop                                 ; No operation (delay slot)

    li.s      f12, 0.9                  ; Load immediate single: f12 = 0.9
    jal       SetTextScale              ; Jump and link: Call SetTextScale function
    nop                                 ; No operation (delay slot)

    li        v0, Ram                   ; Load immediate: v0 = Ram
    lw        a0, 0x4(v0)               ; Load word: a0 = *(Ram + 4)
    mtc1      a0, f12                   ; Move to coprocessor 1: f12 = a0
    cvt.s.w   f12, f12                  ; Convert to single (float): f12 = (float)a0
    mtc1      a1, f13                   ; Move to coprocessor 1: f13 = a1
    cvt.s.w   f13, f13                  ; Convert to single (float): f13 = (float)a1
    dmove     a0, a2                    ; Double move: a0 = a2 (destination coordinates for text)
    jal       DrawTextAt                ; Jump and link: Call DrawTextAt function
    nop                                 ; No operation (delay slot)

    li        v0, Ram                   ; Load immediate: v0 = Ram
    lw        ra, 0x8(v0)               ; Load word: ra = *(Ram + 8)
    jr        ra                        ; Jump to return address in ra
    nop                                 ; No operation (delay slot)
.endfunc

.func RenderSelected
    li        v0, Ram                   ; Load immediate: v0 = Ram
    sw        a0, 0x4(v0)               ; Store word: *(Ram + 4) = a0
    sw        ra, 0x8(v0)               ; Store word: *(Ram + 8) = ra
    li        a0, 0x3                   ; Load immediate: a0 = 0x3 (red)
    jal       SetTextColor              ; Jump and link: Call SetTextColor function
    nop                                 ; No operation (delay slot)

    li.s      f12, 0.9                  ; Load immediate single: f12 = 0.9
    jal       SetTextScale              ; Jump and link: Call SetTextScale function
    nop                                 ; No operation (delay slot)

    li        v0, Ram                   ; Load immediate: v0 = Ram
    lw        a0, 0x4(v0)               ; Load word: a0 = *(Ram + 4)
    mtc1      a0, f12                   ; Move to coprocessor 1: f12 = a0
    cvt.s.w   f12, f12                  ; Convert to single (float): f12 = (float)a0
    mtc1      a1, f13                   ; Move to coprocessor 1: f13 = a1
    cvt.s.w   f13, f13                  ; Convert to single (float): f13 = (float)a1
    dmove     a0, a2                    ; Double move: a0 = a2 (destination coordinates for text)
    jal       DrawTextAt                ; Jump and link: Call DrawTextAt function
    nop                                 ; No operation (delay slot)

    li        v0, Ram                   ; Load immediate: v0 = Ram
    lw        ra, 0x8(v0)               ; Load word: ra = *(Ram + 8)
    jr        ra                        ; Jump to return address in ra
    nop                                 ; No operation (delay slot)
.endfunc

.func Switcheroo
    move      t9, a2                    ; Copy the value in register a2 to t9
    j         0x00121C6C                ; Jump to the address 0x00121C6C (unconditional jump)
    li        v1, 0x70                  ; Load immediate: v1 = 0x70
    lh        a0, 0x2(t9)               ; Load half-word from memory at address (t9 + 0x2) into a0
    andi      a1, a0, 0x9FFF            ; Perform bitwise AND: a1 = a0 & 0x9FFF
    lbu       a2, 0xE(t9)               ; Load byte unsigned from memory at address (t9 + 0xE) into a2
    lbu       a3, 0xD(t9)               ; Load byte unsigned from memory at address (t9 + 0xD) into a3
    andi      at, a0, 0x4000            ; Perform bitwise AND: at = a0 & 0x4000
    ori       v1, a1, 0x2000            ; Perform bitwise OR with immediate: v1 = a1 | 0x2000
    movn      a1, v1, at                ; Conditional move: If at == 0, a1 = v1
    sb        a2, 0xD(t9)               ; Store byte: *(t9 + 0xD) = a2
    andi      at, a0, 0x2000            ; Perform bitwise AND: at = a0 & 0x2000
    ori       v1, a1, 0x4000            ; Perform bitwise OR with immediate: v1 = a1 | 0x4000
    movn      a1, v1, at                ; Conditional move: If at == 0, a1 = v1
    sb        a3, 0xE(t9)               ; Store byte: *(t9 + 0xE) = a3
    jr        ra                        ; Jump to the return address in register ra
    sh        a1, 0x2(t9)               ; Store half-word: *(t9 + 0x2) = a1 (delay slot)
.endfunc

//Control codes (0xFF is always first byte):
//--------------
//  2-bytes
//--------------
// 0x80, 0x81, 0x82, 0x83
// 0x90,
// 0xCB, 0xCD
// 0xFB, 0xFC, 0xFD
//
//--------------
//  3-bytes
//--------------
// 0xAAXX, 0xABXX, 0xACXX, 0xADXX, 0xAEXX, 0xAFXX
// 0xB0XX, 0xB1XX, 0xB2XX, 0xB3XX, 0xB4XX, 0xB5XX, 0xB8XX, 0xB9XX
// 0xC8XX
// 0xD4XX, 0xD5XX, 0xD6XX, 0xD7XX, 0xD8XX, 0xDEXX, 0xDFXX,
// 0xE5XX, 0xE6XX, 0xE1XX, 0xEFXX
//
//--------------
//  4-bytes
//--------------
// 0x9CXXXX
// 0xB6XXXX, 0xB7XXXX, 0xBCXXXX, 0xBDXXXX, 0xBEXXXX, 0xBFXXXX
// 0xCCXXXX, 0xCEXXXX, 0xCFXXXX
// 0xEAXXXX
//
//--------------
//  5-bytes
//--------------
// 0xBAXXXXXX, 0xBBXXXXXX
//
//--------------
//  7-bytes!
//--------------
// 0x9DXXXXXXXXXX
//
//--------------
//  End of box
//--------------
// 0xFF, 0xFE, 0x(Any other combination not present above)

//Font table
.func VWFtable
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .byte 0x06, 0x05, 0x06, 0x0A, 0x09, 0x0F, 0x0E, 0x03, 0x05, 0x05, 0x07, 0x0A, 0x05, 0x09, 0x04, 0x09
    .byte 0x09, 0x09, 0x09, 0x08, 0x09, 0x08, 0x09, 0x0A, 0x09, 0x09, 0x04, 0x05, 0x0A, 0x0A, 0x0A, 0x07
    .byte 0x0D, 0x0E, 0x0B, 0x0D, 0x0E, 0x0A, 0x0A, 0x0F, 0x0E, 0x06, 0x07, 0x0E, 0x0A, 0x10, 0x0E, 0x0F
    .byte 0x0B, 0x0E, 0x0C, 0x0B, 0x0D, 0x0D, 0x0F, 0x10, 0x0C, 0x0C, 0x0B, 0x06, 0x09, 0x05, 0x09, 0x0A
    .byte 0x04, 0x08, 0x0A, 0x07, 0x0A, 0x08, 0x08, 0x0A, 0x0A, 0x05, 0x05, 0x0A, 0x05, 0x0F, 0x0A, 0x0A
    .byte 0x0A, 0x0A, 0x07, 0x07, 0x07, 0x0A, 0x0A, 0x10, 0x08, 0x0B, 0x08, 0x04, 0x03, 0x04, 0x0A, 0x04
.endfunc

.func ram
    nop
    nop
    nop
    nop
.endfunc

// Kill / EXP / attack / casting / using a knack top text alignment fix
// Breaks some text
/*
.org 0x02C80DC
    lbu     at,0x92(s3)
    addu    at,s3,at
    sb      zero,(at)
    lb      at,0x10(s3)
    bnez    at,@@draw
    nop
    addiu   s3,s3,0x1
@@draw:
    li      a0,0x0
    jal     0x00151670
    nop
    li      a0,0x80
    jal     0x001517a0
    nop
    mtc1    s2,f00
    nop
    cvt.s.w f12,f00
    mtc1    s1,f00
    nop
    cvt.s.w f13,f00
    addiu   a0,s3,0x10
    jal     0x00151840
    nop
    b       0x002C81A0
    nop
*/

.close