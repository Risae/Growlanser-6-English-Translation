// Updated VWF detour and VWF function — small, targeted fixes to instruction encodings and pointer addition.

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

//VWF function
.org VWFfunct
    li       s0,ram
    sw       s1,(s0)                     ; we store s1 in the address we set-up on s0

    # Use explicit addiu instead of li for correct encoding on PCSX2/armips
    addiu    s0,zero,0x1
    beql     s0,a3,@@VWFcode             ; if a3 is 1 we jump directly to our VWF code
    nop
    andi     s0,t0,0xFF00
    bnez     s0,@@Original               ; if the result of the AND is not zero we jump to the original
    nop                                  ; function as that means this is a SHIFT-JIS char

    @@VWFcode:
    li        s0,VWFtable
    lbu       s1,-0x1(s3)                ; We use s3 to get the correct space character (0x20)

    # Fix invalid addu usage: add table base (s0) and index (s1)
    addu      s0,s0,s1

    # Use explicit zero offset for clarity/assembler compatibility
    lbu       s0,0(s0)
    addiu     s0,s0,0x2                  ; Add two pixels to each character
    mtc1      s0,f23
    nop                                  ; Wait for move operation
    cvt.s.w   f23,f23
    mul.s     f23,f23,f21                ; Scale text widths

    @@Original:
    li        s0,ram
    lw        s1,(s0)                    ; We load back original s1 from the address we set-up at the start
    or        s0,zero,zero               ; reset s0 back to zero
    add.s     f26,f26,f23
