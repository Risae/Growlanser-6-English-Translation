.ps2
.open "SLPM_667.16", 0x00100000
.headersize 0x000FFF80

VWFfunct equ 0x003D7980
SetTextColor equ 0x00151670
SetTextScale equ 0x00151890
DrawLetter equ 0x001522BC
DrawTextAt equ 0x00151840
printf equ 0x129798 ; Part of the full width numbers in enemies defeated string


// Fix for the full width numbers that are displayed when you kill more than 1 enemy at the same time.

.org 0x2C7684
move a0, v0
li   a1, 0x42C0C0 ; address to "%d" string
move a2, s3
jal  printf
nop
b    0x2C7708
nop


/*
Window width set part, is given in characters
so the game multiplies the value by 10d every
time it uses it, "simplest" solution is to
divide by 10 the largest line width and round
up
But I need to create the "get line pixel width"
function first
.org 0x002760B0
*/


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
    j         RolloverFix     ;Currently a dummy
    addiu     v1,0x1

.org 0x002A3648
    j         ScrollingFix

.org 0x002A3658
    j         ScrollingFix

.org 0x0031BA9C
    addiu     a2,v0,0x2       ;Render two characters in advance to account for VWF


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
    cvt.w.s   f26,f26         ;Convert the value in f26 to an integer of the same value
    mfc1      s1,f26          ;Move to our X value variable (s1)
    addiu     s2,0x1          ;Add 1 to s1 like in the original
    b         0x00279058      ;Branch from the original
    nop                       ;NOP from the original

//VWF function
.org VWFfunct
    li       s0,ram
    sw       s1,(s0)          ;we store s1 in the address we set-up on s0
    li       s0,0x1           ;This needs to inputted as 'addiu s0,zero,0x1' in PCSX2 for it to work
    beql     s0,a3,@@VWFcode  ;if a3 is 1 we jump directly to our VWF code
    nop                                                    
    andi     s0,t0,0xFF00
    bnez     s0,@@Original    ;if the result of the AND is not zero we jump to the original
    nop                       ;function as that means this is a SHIFT-JIS char

    @@VWFcode:
    li        s0,VWFtable                                    
    lbu       s1,-0x1(s3)     ;We use s3 to get the correct space character (0x20)
    addu      s0,s1
    lbu       s0,(s0)
    addiu     s0,0x2          ;Add two pixels to each character
    mtc1      s0,f23
    nop                       ;Wait for move operation
    cvt.s.w   f23,f23    
    mul.s     f23,f23,f21     ;Scale text widths

    @@Original:
    li        s0,ram
    lw        s1,(s0)         ;We load back original s1 from the address we set-up at the start
    or        s0,zero,zero    ;reset s0 back to zero
    add.s     f26,f26,f23    
    addiu     s6,0x1    
    j         0x00151DB0      ;back to original function
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

//TO-DO fix first-line text centering
//and make character width calculation
//its own thing, to fix textbox width
//calculation with the VWF (inside 0x275520)
//that'd need investigation, too many branches
.func CalculateSpace
    dmove     s1,v1
    lbu       s2,0x1A8(s0)    ;line counter
    lw        s4,0x18C(s0)    ;Load line address into s4
    li        s5,VWFtable     ;Load VWFtable
    lbu       s2,(s4)
    bne       s2,0xFF,@@loop
    nop
    lbu       s2,0x1(s4)
    bne       s2,0xFC,@@Loop   ;If first tag is a new line, skip 2 bytes
    nop
    addiu     s4,0x2

    @@Loop:
    lbu       s6,(s4)
    beq       s6,0xFF,@@ControlCodes  ;GOTO Control chars...
    nop        
    sltiu     s2,s6,0x0080
    bnez      s2,@@Adder      ;GOTO Add ASCII widths
    nop
    addiu     s4,0x2
    addiu     s7,0x14         ;Japanese char width
    b         @@Loop          
    nop

    @@ControlCodes:
    lbu       s6,0x01(s4)
    beql      s6,0xDF,@@Loop  ;Color tag
    addiu     s4,0x3
    beql      s6,0xCE,@@Loop  ;Sound Bank tag
    addiu     s4,0x4
    beql      s6,0xCF,@@Loop  ;Sound Index tag
    addiu     s4,0x4
    beql      s6,0xEA,@@CalculateName  ;Main Character tag
    addiu     s4,0x4
    b         @@End   ;Exit early on unknown tag
    nop

    @@CalculateName:
    lhu       s6,-0x2(S4)
    bne       s6,0x1,@@Loop   ;Not MC's name, skip
    nop
    sw        s4,-0x4(sp)
    li        s4,0x50E8B2     ;MC's name (0xFF terminated)
    @@NameLoop:
    lbu       s6,(s4)
    beql      s6,0xFF,@@Loop
    lw        s4,-0x4(sp)
    ;Duplicated efforts for now
    addu      s6,s5,s6
    lbu       s6,(s6)
    addu      s7,s6
    addiu     s7,0x2          ;Add the 2 pixels to each letter
    addiu     s4,0x1
    b         @@NameLoop
    nop


    @@Adder:
    addu      s6,s5,s6
    lbu       s6,(s6)
    addu      s7,s6
    addiu     s7,0x2          ;Add the 2 pixels to each letter
    addiu     s4,0x1
    b         @@Loop
    nop

    //Basically: ((((line_width - window_width) + 1) / 2) + 4) / 8 (math rounded)
    //A more precise solution would be using an special (invisible) char followed 
    //by a number that equals (line_width - window_width) / 2, so we avoid the hard
    //character limit
    @@End:
    dmove     s2,a1           ;a1 = window width
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
    j         0x0027E318      ;Go back to original function
    nop

.endfunc

.func RenderNormal
    li        v0,Ram
    sw        a0,0x4(v0)
    sw        ra,0x8(v0)
    li        a0,0x7           ;0x7 == black
    jal       SetTextColor
    nop 
    li.s      f12,0.9
    jal       SetTextScale
    nop 
    li        v0,Ram
    lw        a0,0x4(v0)
    mtc1      a0,f12
    cvt.s.w   f12,f12
    mtc1      a1,f13
    cvt.s.w   f13,f13
    dmove     a0,a2
    jal       DrawTextAt
    nop       
    li        v0,Ram
    lw        ra,0x8(v0)
    jr        ra
    nop

.endfunc

.func RenderSelected
    li        v0,Ram
    sw        a0,0x4(v0)
    sw        ra,0x8(v0)
    li        a0,0x3           ;0x3 == Red
    jal       SetTextColor
    nop 
    li.s      f12,0.9
    jal       SetTextScale
    nop 
    li        v0,Ram
    lw        a0,0x4(v0)
    mtc1      a0,f12
    cvt.s.w   f12,f12
    mtc1      a1,f13
    cvt.s.w   f13,f13
    dmove     a0,a2
    jal       DrawTextAt
    nop       
    li        v0,Ram
    lw        ra,0x8(v0)
    jr        ra
    nop

.endfunc


.func Switcheroo
    move      t9,a2
    j         0x00121C6C
    li        v1,0x70
    lh        a0,0x2(t9)
    andi      a1,a0,0x9FFF
    lbu       a2,0xE(t9)
    lbu       a3,0xD(t9)
    andi      at,a0,0x4000
    ori       v1,a1,0x2000
    movn      a1,v1,at
    sb        a2,0xD(t9)
    andi      at,a0,0x2000
    ori       v1,a1,0x4000
    movn      a1,v1,at
    sb        a3,0xE(t9)
    jr        ra
    sh        a1,0x2(t9)
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


// Kill / EXP / attack / casting / ability top text alignment fix
// Breaks the VWF and other stuff
/*
.org 0x02C80DC
    li      at,0x92(s3)
    addiu   at,s3,at
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