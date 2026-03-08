.ps2
.open "SLPM_667.16", 0x00100000
.headersize 0x000FFF80

; ===========================================================================
; Equates / fixed addresses
; ===========================================================================
VWFfunct               equ 0x003D7980   ; Custom VWF function
SetTextColor           equ 0x00151670   ; Sets text color
SetTextScale           equ 0x00151890   ; Sets text scaling
DrawLetter             equ 0x001522BC   ; Draws a single letter
DrawTextAt             equ 0x00151840   ; Draws text at specified coordinates
printf                 equ 0x129798     ; Formats strings (used for enemy defeat count)
TextboxWidthAdjustAddr equ 0x003D7D00   ; Post-processing helper for textbox windowWidth
VWFtableLabelAddr      equ 0x003D81F0   ; ASCII marker placed immediately before the width table
VWFtableAddr           equ 0x003D8200   ; Width table begins on a clean ...x0 boundary
RamAddr                equ 0x003D8280   ; Small scratch area used by the injected helpers

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

// Swap 〇 to Ｘ, code borrowed from PS2 Controller Remapper
.org 0x00121C64
    j         Switcheroo
.org 0x00121CCC
    j         Switcheroo + 0xC

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
    jal       TextboxWidthAdjustAddr
    lq        fp, 0x80(sp)               ; original epilogue instruction in delay slot

; ---------------------------------------------------------------------------
; Injected custom code
; ---------------------------------------------------------------------------

// VWF width function
.org VWFfunct
    li       s0,ram
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
    li        s0,ram
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


.org TextboxWidthAdjustAddr
.func TextboxWidthAdjust
    lw        t0, 0x18C(s5)              ; text pointer
    move      t1, zero                   ; current line width in pixels
    move      t2, zero                   ; max line width in pixels

    @@Loop:
    lbu       t3, (t0)
    beq       t3, 0xFF, @@Control
    nop
    sltiu     t4, t3, 0x80
    beqz      t4, @@SJIS
    nop
    li        t4, VWFtable
    addu      t4, t3
    lbu       t4, (t4)
    addiu     t4, 0x2
    addu      t1, t4
    addiu     t0, 0x1
    b         @@Loop
    nop

    @@SJIS:
    addiu     t1, 0x14                   ; keep Japanese chars close to CalculateSpace
    addiu     t0, 0x2
    b         @@Loop
    nop

    @@Control:
    lbu       t3, 0x1(t0)
    beq       t3, 0xFE, @@Finish
    nop
    beq       t3, 0xFF, @@Finish
    nop
    beq       t3, 0xFC, @@NewLine
    nop
    beq       t3, 0xFD, @@NewLine
    nop
    beq       t3, 0xFB, @@Skip2
    nop
    beq       t3, 0xEA, @@MainCharTag
    nop

    ; 0x80-0x83
    addiu     t4, t3, -0x80
    sltiu     t4, t4, 0x4
    bnez      t4, @@Skip2
    nop

    ; 0xAA-0xB5
    addiu     t4, t3, -0xAA
    sltiu     t4, t4, 0x0C
    bnez      t4, @@Skip3
    nop

    ; 0xB6-0xB7
    addiu     t4, t3, -0xB6
    sltiu     t4, t4, 0x2
    bnez      t4, @@Skip4
    nop

    ; 0xB8-0xB9
    addiu     t4, t3, -0xB8
    sltiu     t4, t4, 0x2
    bnez      t4, @@Skip3
    nop

    ; 0xBA-0xBB
    addiu     t4, t3, -0xBA
    sltiu     t4, t4, 0x2
    bnez      t4, @@Skip5
    nop

    ; 0xBC-0xBF
    addiu     t4, t3, -0xBC
    sltiu     t4, t4, 0x4
    bnez      t4, @@Skip4
    nop

    beq       t3, 0x90, @@Skip2
    nop
    beq       t3, 0x9C, @@Skip4
    nop
    beq       t3, 0x9D, @@Skip7
    nop
    beq       t3, 0xC8, @@Skip3
    nop
    beq       t3, 0xCB, @@Skip2
    nop
    beq       t3, 0xCC, @@Skip4
    nop
    beq       t3, 0xCD, @@Skip2
    nop
    beq       t3, 0xCE, @@Skip4
    nop
    beq       t3, 0xCF, @@Skip4
    nop

    ; 0xD4-0xD8
    addiu     t4, t3, -0xD4
    sltiu     t4, t4, 0x5
    bnez      t4, @@Skip3
    nop

    beq       t3, 0xDE, @@Skip3
    nop
    beq       t3, 0xDF, @@Skip3
    nop
    beq       t3, 0xE1, @@Skip3
    nop
    beq       t3, 0xE5, @@Skip3
    nop
    beq       t3, 0xE6, @@Skip3
    nop
    beq       t3, 0xEF, @@Skip3
    nop

    ; Unknown control code: stop rather than walking off into bad data.
    b         @@Finish
    nop

    @@MainCharTag:
    lbu       t4, 0x2(t0)                ; tag argument used by the original width routine
    bne       t4, 0x1, @@Skip4
    nop
    li        t5, 0x50E8B2               ; MC name, 0xFF terminated

    @@NameLoop:
    lbu       t6, (t5)
    beq       t6, 0xFF, @@NameDone
    nop
    sltiu     t4, t6, 0x80
    beqz      t4, @@NameSJIS
    nop
    li        t4, VWFtable
    addu      t4, t6
    lbu       t4, (t4)
    addiu     t4, 0x2
    addu      t1, t4
    addiu     t5, 0x1
    b         @@NameLoop
    nop

    @@NameSJIS:
    addiu     t1, 0x14
    addiu     t5, 0x2
    b         @@NameLoop
    nop

    @@NameDone:
    addiu     t0, 0x4
    b         @@Loop
    nop

    @@Skip2:
    addiu     t0, 0x2
    b         @@Loop
    nop

    @@Skip3:
    addiu     t0, 0x3
    b         @@Loop
    nop

    @@Skip4:
    addiu     t0, 0x4
    b         @@Loop
    nop

    @@Skip5:
    addiu     t0, 0x5
    b         @@Loop
    nop

    @@Skip7:
    addiu     t0, 0x7
    b         @@Loop
    nop

    @@NewLine:
    slt       t4, t2, t1
    beqz      t4, @@NewLineNoMax
    nop
    move      t2, t1

    @@NewLineNoMax:
    move      t1, zero
    addiu     t0, 0x2
    b         @@Loop
    nop

    @@Finish:
    slt       t4, t2, t1
    beqz      t4, @@Convert
    nop
    move      t2, t1

    @@Convert:
    addiu     t2, 0x9                    ; ceil(px / 10)
    li        t4, 0xA
    divu      t2, t4
    mflo      t3
    lw        t4, 0x70(s5)               ; original char-unit width
    slt       t5, t4, t3
    beqz      t5, @@Restore
    nop
    sw        t3, 0x70(s5)

    @@Restore:
    ld        ra, 0x90(sp)
    lq        s7, 0x70(sp)
    lq        s6, 0x60(sp)
    lq        s5, 0x50(sp)
    lq        s4, 0x40(sp)
    lq        s3, 0x30(sp)
    lq        s2, 0x20(sp)
    lq        s1, 0x10(sp)
    lq        s0, 0x0(sp)
    addiu     sp, 0xC0
    jr        ra
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

// Tiny scratch area used by the injected helpers.
.org RamAddr
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