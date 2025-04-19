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
Ram             equ 0x003D79A0          ; Scratch memory for storing values (previously defined as 'ram')

; ===========================================================================
; Patches
; ===========================================================================

; Fix for the full-width numbers that are displayed when you kill more than 1 enemy at the same time.
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

; Swap 〇 to Ｘ, code borrowed from PS2 Controller Remapper
.org 0x00121C64
    j         Switcheroo
.org 0x00121CCC
    j         Switcheroo + 0xC

; Gatetext render
.org 0x003C72AC
    jal       RenderSelected

.org 0x003C72E8
    jal       RenderNormal

; Casting and waiting speech bubble
.org 0x003C72E8
    jal       RenderNormal

.org 0x002F5AF0
    jal       RenderNormal

; Make scrolling text use variable width
.org 0x002A36CC
    j         RolloverFix               ; Currently a dummy
    addiu     v1, 0x1

.org 0x002A3648
    j         ScrollingFix

.org 0x002A3658
    j         ScrollingFix

.org 0x0031BA9C
    addiu     a2, v0, 0x2               ; Render two characters in advance to account for VWF

; Text centering fix
.org 0x0027E310
    j         CalculateSpace
    nop

; Redirect game's font width function to ours
.org 0x00151DA8
    j         VWFfunct
    nop

.org 0x00152384
    nop

; VWF fixes
.org 0x002792BC
    j         Detoured

.org 0x002792D4
    cvt.w.s   f26, f26                  ; Convert the value in f26 to an integer of the same value
    mfc1      s1, f26                   ; Move to our X value variable (s1)
    addiu     s2, 0x1                   ; Add 1 to s1 like in the original
    b         0x00279058                ; Branch from the original
    nop                                 ; NOP from the original

; Adjust text box width in GL_InitializeTextEntry
.org 0x00277978
    j         AdjustTextBoxWidth
    nop

; Patch for Mode 1 in GL_703_SetTextElementPosition to center choice menu text
.org 0x001CCD30                         ; Mode 1 branch in GL_703_SetTextElementPosition
    j         CenterChoiceText          ; Jump to centering function
    nop                                 ; Delay slot

; ===========================================================================
; Functions
; ===========================================================================

; Center choice menu text in Mode 1
.func CenterChoiceText
    ; Load text box width (in characters) from s0+0x6c
    lw        t0, 0x6c(s0)              ; t0 = text_box_width (characters, e.g., 31)
    li        t1, 9                     ; 9 pixels per character (10 * 0.9 scaling)
    mul       t0, t0, t1                ; t0 = text_box_width in pixels (31 * 9 = 279)

    ; Get text width (in pixels) from f26
    cvt.w.s   f26, f26                  ; Convert text width to integer
    mfc1      t1, f26                   ; t1 = text_width (pixels, e.g., 234)

    ; Center the text: x = (text_box_width - text_width) / 2
    subu      t0, t0, t1                ; t0 = text_box_width - text_width (279 - 234 = 45)
    sra       t0, t0, 1                 ; t0 = (text_box_width - text_width) / 2 (45 / 2 = 22)

    ; Store the new x-coordinate
    sw        t0, 0x50(s0)              ; Update x-coordinate in structure (e.g., 38)

    ; Add debug prints to inspect values
    jal       DebugPrintValues          ; Call debug print function
    nop                                 ; Delay slot

    ; Return to original code
    j         0x1CCD38                  ; Jump back to the next instruction after Mode 1 check
    nop
.endfunc

; Debug print function to inspect values
.func DebugPrintValues
    ; Save registers to preserve the state
    li        t0, Ram                   ; t0 = address of Ram (scratch memory)
    sw        ra, 0x8(t0)               ; Save return address (ra) at Ram + 0x8
    sw        a0, 0x4(t0)               ; Save a0 at Ram + 0x4 (since printf uses a0)

    ; Print text box width (s0+0x6c)
    li        a0, 0x42C0C0              ; a0 = address of "%d" string
    lw        a1, 0x6c(s0)              ; a1 = text_box_width (in characters, e.g., 31)
    jal       printf                    ; Call printf to print the value
    nop                                 ; Delay slot (no operation)

    ; Print text width (f26)
    li        a0, 0x42C0C0              ; a0 = address of "%d" string
    cvt.w.s   f26, f26                  ; Convert text width (f26, float) to integer
    mfc1      a1, f26                   ; a1 = text_width (in pixels, e.g., 234)
    jal       printf                    ; Call printf to print the value
    nop                                 ; Delay slot (no operation)

    ; Print calculated x-coordinate (s0+0x50)
    li        a0, 0x42C0C0              ; a0 = address of "%d" string
    lw        a1, 0x50(s0)              ; a1 = x-coordinate (in pixels, e.g., 38 after centering)
    jal       printf                    ; Call printf to print the value
    nop                                 ; Delay slot (no operation)

    ; Restore registers
    li        t0, Ram                   ; t0 = address of Ram
    lw        ra, 0x8(t0)               ; Restore return address (ra)
    lw        a0, 0x4(t0)               ; Restore a0

    ; Return to the caller
    jr        ra                        ; Jump back to the return address
    nop                                 ; Delay slot (no operation)
.endfunc

; VWF function
.org VWFfunct
    li        s0, Ram
    sw        s1, (s0)                  ; We store s1 in the address we set-up on s0
    li        s0, 0x1                   ; This needs to be inputted as 'addiu s0, zero, 0x1' in PCSX2 for it to work
    beql      s0, a3, @@VWFcode         ; If a3 is 1 we jump directly to our VWF code
    nop
    andi      s0, t0, 0xFF00
    bnez      s0, @@Original            ; If the result of the AND is not zero we jump to the original
    nop                                 ; function as that means this is a SHIFT-JIS char

    @@VWFcode:
    li        s0, VWFtable
    lbu       s1, -0x1(s3)             ; We use s3 to get the correct space character (0x20)
    addu      s0, s1
    lbu       s0, (s0)
    addiu     s0, 0x2                  ; Add two pixels to each character
    mtc1      s0, f23
    nop                                ; Wait for move operation
    cvt.s.w   f23, f23
    mul.s     f23, f23, f21            ; Scale text widths

    @@Original:
    li        s0, Ram
    lw        s1, (s0)                 ; We load back original s1 from the address we set-up at the start
    or        s0, zero, zero           ; Reset s0 back to zero
    add.s     f26, f26, f23
    addiu     s6, 0x1
    j         0x00151DB0               ; Back to original function
    nop

.func Detoured
    cvt.w.s   f26, f26
    mfc1      s1, f26
    j         0x2792C0
    nop
.endfunc

.func ScrollingFix
    cvt.w.s   f26, f26
    mfc1      s3, f26
    j         0x002A3660
    nop
.endfunc

.func RolloverFix
    j         0x002A36D4
    nop
.endfunc

.func CalculateSpace
    dmove     s1, v1                    ; Save v1 (original s1)
    lbu       s2, 0x1A8(s0)             ; Line counter
    lw        s4, 0x18C(s0)             ; Load line address into s4
    li        s5, VWFtable              ; Load VWFtable
    dmove     s7, zero                  ; Current line width
    dmove     s6, zero                  ; Maximum line width
    dmove     s3, zero                  ; Current line number

    @@LineLoop:
    lbu       s2, (s4)
    beq       s2, 0xFF, @@EndOfBox      ; End of box
    nop

    @@CharLoop:
    lbu       s2, (s4)
    beq       s2, 0xFF, @@ControlCodes  ; GOTO Control chars
    nop
    sltiu     t0, s2, 0x0080
    bnez      t0, @@Adder               ; GOTO Add ASCII widths
    nop
    addiu     s4, 0x2
    addiu     t0, zero, 0x14            ; Japanese char width
    addu      s7, t0                    ; Add to current line width
    b         @@CharLoop
    nop

    @@ControlCodes:
    lbu       s2, 0x01(s4)
    beql      s2, 0xDF, @@CharLoop      ; Color tag
    addiu     s4, 0x3
    beql      s2, 0xCE, @@CharLoop      ; Sound Bank tag
    addiu     s4, 0x4
    beql      s2, 0xCF, @@CharLoop      ; Sound Index tag
    addiu     s4, 0x4
    beql      s2, 0xEA, @@CalculateName ; Main Character tag
    addiu     s4, 0x4
    beql      s2, 0xFC, @@NewLine       ; New line
    addiu     s4, 0x2
    b         @@EndOfBox                ; Exit early on unknown tag
    nop

    @@NewLine:
    slt       t0, s7, s6                ; Compare current line width with max
    bnez      t0, @@SkipUpdateMax       ; If current < max, skip update
    nop
    dmove     s6, s7                    ; Update max line width
    @@SkipUpdateMax:
    dmove     s7, zero                  ; Reset current line width
    addiu     s3, 0x1                   ; Increment line number
    b         @@LineLoop
    nop

    @@CalculateName:
    lhu       s2, -0x2(s4)
    bne       s2, 0x1, @@CharLoop       ; Not MC's name, skip
    nop
    sw        s4, -0x4(sp)              ; Save s4
    li        s4, 0x50E8B2              ; MC's name (0xFF terminated)

    @@NameLoop:
    lbu       s2, (s4)
    beql      s2, 0xFF, @@CharLoop
    lw        s4, -0x4(sp)
    addu      s2, s5, s2
    lbu       s2, (s2)
    addu      s7, s2
    addiu     s7, 0x2                   ; Add the 2 pixels to each letter
    addiu     s4, 0x1
    b         @@NameLoop
    nop

    @@Adder:
    addu      s2, s5, s2
    lbu       s2, (s2)
    addu      s7, s2
    addiu     s7, 0x2                   ; Add the 2 pixels to each letter
    addiu     s4, 0x1
    b         @@CharLoop
    nop

    @@EndOfBox:
    slt       t0, s7, s6                ; Compare last line width with max
    bnez      t0, @@SkipLastUpdateMax   ; If current < max, skip update
    nop
    dmove     s6, s7                    ; Update max line width
    @@SkipLastUpdateMax:

    ; Store max line width in ram for later use
    li        t0, Ram
    sw        s6, 0xC(t0)               ; Store max line width at Ram + 0xC

    ; Center the first line (same as before)
    dmove     s2, a1                    ; a1 = window width (in characters)
    sll       s2, s2, 0x02
    addu      s2, s2, s2
    sll       s2, s2, 0x1               ; s2 = window_width * 10 (in pixels)
    subu      s6, s7, s2                ; s6 = (line_width - window_width)
    addiu     s6, 0x1                   ; s6 += 1
    sra       s1, s6, 0x01              ; s1 = s6 / 2
    addiu     s1, 0x4                   ; s1 += 4
    sra       s1, 0x3                   ; s1 /= 8

    dmove     s2, zero
    dmove     s4, zero
    dmove     s5, zero
    dmove     s6, zero
    dmove     s7, zero
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

; Font table
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

; Scratch memory (previously 'ram')
.func Ram
    nop
    nop
    nop
    nop
.endfunc

.func AdjustTextBoxWidth
    li        t0, Ram
    lw        t1, 0xC(t0)               ; Load max line width (in pixels)
    addiu     t2, t1, 8                 ; t2 = max_line_width + 8 (for rounding up)
    li        t3, 9                     ; 9 pixels per character (10 * 0.9)
    divu      t2, t3                    ; t2 /= 9
    mflo      t2                        ; Get quotient
    sw        t2, 0x6c(s2)              ; Update window width in structure
    lw        v0, 0x68(sp)              ; Original instruction (was lw v0, local_28(sp))
    sw        v0, 0x28(s2)              ; Original instruction
    j         0x00277980                ; Jump back to the next instruction
    nop
.endfunc

.close