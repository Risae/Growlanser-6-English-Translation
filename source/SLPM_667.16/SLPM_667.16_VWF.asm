.ps2
.open "SLPM_667.16", 0x00100000
.headersize 0x000FFF80

; ===========================================================================
; Equates / fixed addresses
; ===========================================================================
printf                     equ 0x00129798 ; Formats strings (used for enemy defeat count)
SetTextColor               equ 0x00151670 ; Sets text color
SetTextScale               equ 0x00151890 ; Sets text scaling
DrawLetter                 equ 0x001522BC ; Draws a single letter
DrawTextAt                 equ 0x00151840 ; Draws text at specified coordinates
z_un_00275520              equ 0x00275520 ; Text draw function
z_un_002c74f0              equ 0x002C74F0 ; Unknown patched function for full-width numbers when you kill more than 1 enemy
z_un_002c7840              equ 0x002C7840 ; Unknown patched function for full-width numbers when you kill more than 1 enemy
z_un_003c6ff0              equ 0x003C6FF0 ; Unknown patched function for Gate text render + Speech bubble
VWFfunct                   equ 0x003D7980 ; Custom VWF function
VWFtextboxWidthAdjustAddr  equ 0x003D7D00 ; Post-processing helper for textbox windowWidth
VWFtableLabelAddr          equ 0x003D9000 ; ASCII marker placed immediately before the width table
VWFtableAddr               equ 0x003D9020 ; Width table begins on a clean ...x0 boundary
VWFramAddr                 equ 0x003D90A0 ; Scratch area used by the injected helpers
VWF_SHRINK_TEXTBOXES       equ 0          ; 0 = only enlarge windows if VWF needs it. 1 = replace original width with measured VWF width.

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

; ---------------------------------------------------------------------------
; Hook patches into the original ELF
; ---------------------------------------------------------------------------

// Gate text render
.org 0x003C72AC
    jal       RenderSelected

// Shared RenderNormal hook used by gate text and at least one speech-bubble path.
.org 0x003C72E8
    jal       RenderNormal

// Casting / waiting speech bubble
.org 0x002F5AF0
    jal       RenderNormal

// Make scrolling text use variable width
.org 0x002A36CC
    j         RolloverFix                ; Currently a dummy
    addiu     v1,0x1

.org 0x002A3648
    j         ScrollingFix

.org 0x002A3658
    j         ScrollingFix

.org 0x0031BA9C
    addiu     a2,v0,0x2                  ; Render two characters in advance to account for VWF

// Text centering fix
.org 0x0027E310
    j         CalculateSpace
    nop

// Redirect game's font width function to ours
.org 0x00151DA8
    j         VWFfunct
    nop

.org 0x00152384
    nop

// VWF fixes
.org 0x002792BC
    j         Detoured
    nop                                  ; do not leave original branch at 0x2792C0 in the delay slot

.org 0x002792D4
    cvt.w.s   f26,f26                    ; Convert the value in f26 to an integer of the same value
    mfc1      s1,f26                     ; Move to our X value variable (s1)
    addiu     s2,0x1                     ; Add 1 to s2 like in the original
    b         0x00279058                 ; Branch from the original
    nop                                  ; NOP from the original


// Post-process textbox width after func_00275520 finishes.
// This keeps the original line-count / wrapping logic, but upgrades windowWidth
// to at least ceil(max_rendered_line_pixels / 10) using the VWF table.
.org 0x00276920
    jal       VWFtextboxWidthAdjustAddr
    lq        fp, 0x80(sp)               ; original epilogue instruction in delay slot

; ---------------------------------------------------------------------------
; Injected custom code
; ---------------------------------------------------------------------------

// VWF width function
.org VWFfunct
    li       s0,VWFramAddr
    sw       s1,(s0)                     ; we store s1 in the address we set-up on s0
    li       s0,0x1                      ; Same result as addiu s0,zero,0x1 (handy when checking in PCSX2)
    beql     s0,a3,@@VWFcode             ; if a3 is 1 we jump directly to our VWF code
    nop
    andi     s0,t0,0xFF00
    bnez     s0,@@Original               ; if the result of the AND is not zero we jump to the original
    nop                                  ; SHIFT-JIS path falls back to the original code

    @@VWFcode:
    li        s0,VWFtable
    lbu       s1,-0x1(s3)                ; We use s3 to get the correct space character (0x20)
    addu      s0,s1
    lbu       s0,(s0)
    addiu     s0,0x2                     ; Add two pixels to each character
    mtc1      s0,f23
    nop                                  ; Wait for move operation
    cvt.s.w   f23,f23
    mul.s     f23,f23,f21                ; Scale text widths

    @@Original:
    li        s0,VWFramAddr
    lw        s1,(s0)                    ; We load back original s1 from the address we set-up at the start
    or        s0,zero,zero               ; reset s0 back to zero
    add.s     f26,f26,f23
    addiu     s6,0x1
    j         0x00151DB0                 ; back to original function
    nop

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

/*
/ TO-DO fix first-line text centering and make character width calculation
/ its own thing, to fix textbox width calculation with the VWF (inside 0x275520)
/ that'd need investigation, too many branches
*/
.func CalculateSpace
    dmove     s1,v1
    lbu       s2,0x1A8(s0)               ; line counter
    lw        s4,0x18C(s0)               ; Load line address into s4
    li        s5,VWFtable                ; Load VWFtable
    lbu       s2,(s4)
    bne       s2,0xFF,@@loop
    nop
    lbu       s2,0x1(s4)
    beq       s2,0xFC,@@InitialSkip2     ; [NLINE]
    nop
    beq       s2,0xFD,@@InitialSkip2     ; [NWIN]
    nop
    b         @@Loop
    nop
    @@InitialSkip2:
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

    /*
    / Basically: ((((line_width - window_width) + 1) / 2) + 4) / 8 (math rounded)
    / A more precise solution would be using an special (invisible) char followed
    / by a number that equals (line_width - window_width) / 2, so we avoid the hard
    / character limit
    */
    @@End:
    dmove     s2,a1                     ; a1 = window width
    sll       s6,s2,0x02
    addu      s6,s6,s2
    sll       s6,s6,0x1
    slt       t0,s6,s7                  ; if line is already wider than the box,
    bnez      t0,@@NoIndent             ; do not add centering indent
    nop
    subu      s6,s7
    addiu     s6,0x1
    sra       s1,s6,0x01
    addiu     s1,0x4
    sra       s1,0x3
    b         @@Restore
    nop
    @@NoIndent:
    dmove     s1,zero
    @@Restore:
    dmove     s2,zero
    dmove     s4,zero
    dmove     s5,zero
    dmove     s6,zero
    dmove     s7,zero
    j         0x0027E318                ; Go back to original function
    nop
.endfunc


.org VWFtextboxWidthAdjustAddr
.func TextboxWidthAdjust
    ; Called from the original epilogue of GL_3701_CalcTextboxWidth at 0x00276920.
    ; Important: this routine finishes the original function itself, so it restores
    ; the original saved registers/stack and returns to the original caller.
    ;
    ; Compared with the previous version, this parser:
    ;   - uses the original CharsPerLine[] byte array at textbox+0x11D as a soft
    ;     line-boundary guide, so automatic wraps from the vanilla parser are not
    ;     treated as one huge pixel line;
    ;   - keeps explicit FF FC / FF FD line boundaries;
    ;   - accounts for FF 90 tall/double-count mode for SJIS char-unit tracking;
    ;   - still handles MC-name FF EA 01 xx by measuring the actual name string.
    ;
    ; Remaining limitation: non-MC dynamic width tags (FF 80/81/82/83/E1/E6/EF)
    ; are skipped for pixel measurement. With VWF_SHRINK_TEXTBOXES=0 this is safe
    ; because the original fixed-width window is retained unless VWF text is wider.

    lw        s0, 0x18C(s5)              ; raw text pointer
    move      s1, zero                   ; current rendered line width in pixels
    move      s2, zero                   ; max rendered line width in pixels
    move      s3, zero                   ; current line width in vanilla char-units
    move      s4, zero                   ; current CharsPerLine[] index
    move      s7, zero                   ; FF90 mode flag
    lbu       s6, 0x11D(s5)              ; CharsPerLine[0]

    @@Loop:
    lbu       t0, 0x0(s0)
    beq       t0, 0xFF, @@Control
    nop
    sltiu     t1, t0, 0x80
    beqz      t1, @@SJIS
    nop

    ; ASCII byte: VWF table width + 2px tracking, 1 vanilla char-unit.
    li        t1, VWFtable
    addu      t1, t1, t0
    lbu       t1, 0x0(t1)
    addiu     t1, 0x2
    addu      s1, s1, t1
    addiu     s3, s3, 0x1
    addiu     s0, s0, 0x1
    b         @@CheckSoftLine
    nop

    @@SJIS:
    ; SJIS/full-width char: keep the same 20px assumption used elsewhere.
    addiu     s1, s1, 0x14
    addiu     s3, s3, 0x2
    beq       s7, zero, @@SJIS_NoTallExtra
    nop
    addiu     s3, s3, 0x2               ; matches var_s4 behavior in the decomp for char-units
    @@SJIS_NoTallExtra:
    addiu     s0, s0, 0x2
    b         @@CheckSoftLine
    nop

    @@Control:
    lbu       t0, 0x1(s0)
    beq       t0, 0xFE, @@Finish
    nop
    beq       t0, 0xFF, @@Finish
    nop
    beq       t0, 0xFC, @@ExplicitNewLine
    nop
    beq       t0, 0xFD, @@ExplicitNewLine
    nop
    beq       t0, 0xFB, @@Skip2
    nop
    beq       t0, 0x90, @@SetTallMode
    nop
    beq       t0, 0xEA, @@MainCharTag
    nop

    ; Dynamic width controls. Keep original window width unless shrink mode is enabled.
    ; FF80/82/83 -> func_0027E7A0, FF81 -> func_0027E510 in the decomp.
    addiu     t1, t0, -0x80
    sltiu     t1, t1, 0x4
    bnez      t1, @@Skip2
    nop

    ; 0xAA-0xB5
    addiu     t1, t0, -0xAA
    sltiu     t1, t1, 0x0C
    bnez      t1, @@Skip3
    nop

    ; 0xB6-0xB7
    addiu     t1, t0, -0xB6
    sltiu     t1, t1, 0x2
    bnez      t1, @@Skip4
    nop

    ; 0xB8-0xB9
    addiu     t1, t0, -0xB8
    sltiu     t1, t1, 0x2
    bnez      t1, @@Skip3
    nop

    ; 0xBA-0xBB
    addiu     t1, t0, -0xBA
    sltiu     t1, t1, 0x2
    bnez      t1, @@Skip5
    nop

    ; 0xBC-0xBF
    addiu     t1, t0, -0xBC
    sltiu     t1, t1, 0x4
    bnez      t1, @@Skip4
    nop

    beq       t0, 0x9C, @@Skip4
    nop
    beq       t0, 0x9D, @@Skip7
    nop
    beq       t0, 0xC8, @@Skip3
    nop
    beq       t0, 0xCB, @@Skip2
    nop
    beq       t0, 0xCC, @@Skip4
    nop
    beq       t0, 0xCD, @@Skip2
    nop
    beq       t0, 0xCE, @@Skip4
    nop
    beq       t0, 0xCF, @@Skip4
    nop

    ; 0xD4-0xD8
    addiu     t1, t0, -0xD4
    sltiu     t1, t1, 0x5
    bnez      t1, @@Skip3
    nop

    beq       t0, 0xDE, @@Skip3
    nop
    beq       t0, 0xDF, @@Skip3
    nop
    beq       t0, 0xE1, @@Skip3
    nop
    beq       t0, 0xE5, @@Skip3
    nop
    beq       t0, 0xE6, @@Skip3
    nop
    beq       t0, 0xEF, @@Skip3
    nop

    ; Unknown control code: stop rather than walking off into bad data.
    b         @@Finish
    nop

    @@SetTallMode:
    li        s7, 0x1
    addiu     s0, s0, 0x2
    b         @@Loop
    nop

    @@MainCharTag:
    lbu       t1, 0x2(s0)                ; original uses this argument for name lookup
    bne       t1, 0x1, @@Skip4           ; only hardcode MC-name case for now
    nop
    li        t2, 0x50E8B2               ; MC name, 0xFF-terminated

    @@NameLoop:
    lbu       t3, 0x0(t2)
    beq       t3, 0xFF, @@NameDone
    nop
    sltiu     t4, t3, 0x80
    beqz      t4, @@NameSJIS
    nop
    li        t4, VWFtable
    addu      t4, t4, t3
    lbu       t4, 0x0(t4)
    addiu     t4, 0x2
    addu      s1, s1, t4
    addiu     s3, s3, 0x1
    addiu     t2, t2, 0x1
    b         @@NameLoop
    nop

    @@NameSJIS:
    addiu     s1, s1, 0x14
    addiu     s3, s3, 0x2
    beq       s7, zero, @@NameSJIS_NoTallExtra
    nop
    addiu     s3, s3, 0x2
    @@NameSJIS_NoTallExtra:
    addiu     t2, t2, 0x2
    b         @@NameLoop
    nop

    @@NameDone:
    addiu     s0, s0, 0x4
    b         @@CheckSoftLine
    nop

    @@Skip2:
    addiu     s0, s0, 0x2
    b         @@Loop
    nop

    @@Skip3:
    addiu     s0, s0, 0x3
    b         @@Loop
    nop

    @@Skip4:
    addiu     s0, s0, 0x4
    b         @@Loop
    nop

    @@Skip5:
    addiu     s0, s0, 0x5
    b         @@Loop
    nop

    @@Skip7:
    addiu     s0, s0, 0x7
    b         @@Loop
    nop

    @@ExplicitNewLine:
    slt       t0, s2, s1
    beqz      t0, @@ExplicitNoMax
    nop
    move      s2, s1
    @@ExplicitNoMax:
    move      s1, zero
    move      s3, zero
    addiu     s4, s4, 0x1
    addu      t1, s5, s4
    lbu       s6, 0x11D(t1)
    addiu     s0, s0, 0x2
    b         @@Loop
    nop

    @@CheckSoftLine:
    beq       s6, zero, @@Loop           ; no original line limit for this index
    nop
    slt       t0, s3, s6                 ; if current units < original units, keep going
    bnez      t0, @@Loop
    nop

    ; If the next token is an explicit newline or terminator, let that handler close the line.
    lbu       t0, 0x0(s0)
    bne       t0, 0xFF, @@SoftLineBreak
    nop
    lbu       t1, 0x1(s0)
    beq       t1, 0xFC, @@Loop
    nop
    beq       t1, 0xFD, @@Loop
    nop
    beq       t1, 0xFE, @@Loop
    nop
    beq       t1, 0xFF, @@Loop
    nop

    @@SoftLineBreak:
    slt       t0, s2, s1
    beqz      t0, @@SoftNoMax
    nop
    move      s2, s1
    @@SoftNoMax:
    move      s1, zero
    move      s3, zero
    addiu     s4, s4, 0x1
    addu      t1, s5, s4
    lbu       s6, 0x11D(t1)
    b         @@Loop
    nop

    @@Finish:
    slt       t0, s2, s1
    beqz      t0, @@Convert
    nop
    move      s2, s1

    @@Convert:
    addiu     s2, s2, 0x9                ; ceil(px / 10)
    li        t0, 0xA
    divu      s2, t0
    mflo      t1

.if VWF_SHRINK_TEXTBOXES
    beq       t1, zero, @@Restore        ; avoid writing 0 width on empty/error cases
    nop
    sw        t1, 0x70(s5)
.else
    lw        t0, 0x70(s5)               ; original char-unit width
    slt       t2, t0, t1
    beqz      t2, @@Restore
    nop
    sw        t1, 0x70(s5)
.endif

    @@Restore:
    ld        ra, 0x90(sp)
    lq        fp, 0x80(sp)
    lq        s7, 0x70(sp)
    lq        s6, 0x60(sp)
    lq        s5, 0x50(sp)
    lq        s4, 0x40(sp)
    lq        s3, 0x30(sp)
    lq        s2, 0x20(sp)
    lq        s1, 0x10(sp)
    lq        s0, 0x0(sp)
    addiu     sp, sp, 0xC0
    jr        ra
    nop
.endfunc

.func RenderNormal
    li        v0, VWFramAddr
    sw        a0, 0x04(v0)
    sw        a1, 0x08(v0)
    sw        a2, 0x0C(v0)
    sw        ra, 0x10(v0)

    li        a0, 0x7                    ; black
    jal       SetTextColor
    nop

    li.s      f12, 0.9
    jal       SetTextScale
    nop

    li        v0, VWFramAddr
    lw        a0, 0x04(v0)
    lw        a1, 0x08(v0)
    lw        a2, 0x0C(v0)
    mtc1      a0, f12
    cvt.s.w   f12, f12
    mtc1      a1, f13
    cvt.s.w   f13, f13
    dmove     a0, a2
    jal       DrawTextAt
    nop

    li        v0, VWFramAddr
    lw        ra, 0x10(v0)
    jr        ra
    nop
.endfunc

.func RenderSelected
    li        v0, VWFramAddr
    sw        a0, 0x04(v0)
    sw        a1, 0x08(v0)
    sw        a2, 0x0C(v0)
    sw        ra, 0x10(v0)

    li        a0, 0x3                    ; red
    jal       SetTextColor
    nop

    li.s      f12, 0.9
    jal       SetTextScale
    nop

    li        v0, VWFramAddr
    lw        a0, 0x04(v0)
    lw        a1, 0x08(v0)
    lw        a2, 0x0C(v0)
    mtc1      a0, f12
    cvt.s.w   f12, f12
    mtc1      a1, f13
    cvt.s.w   f13, f13
    dmove     a0, a2
    jal       DrawTextAt
    nop

    li        v0, VWFramAddr
    lw        ra, 0x10(v0)
    jr        ra
    nop
.endfunc

; ---------------------------------------------------------------------------
; Reference notes
; ---------------------------------------------------------------------------

/*
/ Control codes (0xFF is always first byte):
/--------------
/  2-bytes
/--------------
/ 0x80, 0x81, 0x82, 0x83
/ 0x90,
/ 0xCB, 0xCD
/ 0xFB, 0xFC, 0xFD
/
/--------------
/  3-bytes
/--------------
/ 0xAAXX, 0xABXX, 0xACXX, 0xADXX, 0xAEXX, 0xAFXX
/ 0xB0XX, 0xB1XX, 0xB2XX, 0xB3XX, 0xB4XX, 0xB5XX, 0xB8XX, 0xB9XX
/ 0xC8XX
/ 0xD4XX, 0xD5XX, 0xD6XX, 0xD7XX, 0xD8XX, 0xDEXX, 0xDFXX,
/ 0xE5XX, 0xE6XX, 0xE1XX, 0xEFXX
/
/--------------
/  4-bytes
/--------------
/ 0x9CXXXX
/ 0xB6XXXX, 0xB7XXXX, 0xBCXXXX, 0xBDXXXX, 0xBEXXXX, 0xBFXXXX
/ 0xCCXXXX, 0xCEXXXX, 0xCFXXXX
/ 0xEAXXXX
/
/--------------
/  5-bytes
/--------------
/ 0xBAXXXXXX, 0xBBXXXXXX
/
/--------------
/  7-bytes!
/--------------
/ 0x9DXXXXXXXXXX
/
/--------------
/  End of box
/--------------
/ 0xFF, 0xFE, 0x(Any other combination not present above)
*/

; ---------------------------------------------------------------------------
; Data blocks
; ---------------------------------------------------------------------------

// Helpful marker in the ELF immediately above the width table.
.org VWFtableLabelAddr
    .asciiz "VWF Width table"

// Font width table.
// Placed at a fixed ...x0 address so the bytes are easier to inspect in memory.
.org VWFtableAddr
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

// Scratch area used by injected helpers.
// 0x00: VWFfunct saved s1
// 0x04..0x10: RenderNormal/RenderSelected saved a0/a1/a2/ra
.org VWFramAddr
.func VWFscratch
    .word 0, 0, 0, 0, 0, 0, 0, 0
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