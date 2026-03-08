.ps2
.open "SLPM_667.16", 0x00100000
.headersize 0x000FFF80

; ==========================================================================
; X <-> O button swap extracted
; ==========================================================================
;
; Notes:
; - Hook 0x00121C64 jumps to the start of Switcheroo.
; - Hook 0x00121CCC jumps to Switcheroo + 0xC, matching the original split hook.
; - movn = move if register is NOT zero.

SwitcherooAddr equ 0x003D82A0

; --------------------------------------------------------------------------
; Hook patches into the original ELF
; --------------------------------------------------------------------------

.org 0x00121C64
    j         SwitcherooAddr

.org 0x00121CCC
    j         SwitcherooAddr + 0xC

; --------------------------------------------------------------------------
; Injected code
; --------------------------------------------------------------------------

.org SwitcherooAddr
.func Switcheroo
    move      t9, a2                    ; Save controller struct pointer
    j         0x00121C6C                ; Return to the original flow after hook 1
    li        v1, 0x70                  ; Delay slot preserved from the original code
    lh        a0, 0x2(t9)
    andi      a1, a0, 0x9FFF
    lbu       a2, 0xE(t9)
    lbu       a3, 0xD(t9)
    andi      at, a0, 0x4000
    ori       v1, a1, 0x2000
    movn      a1, v1, at                ; If at != 0, copy the X bit into the O slot
    sb        a2, 0xD(t9)
    andi      at, a0, 0x2000
    ori       v1, a1, 0x4000
    movn      a1, v1, at                ; If at != 0, copy the O bit into the X slot
    sb        a3, 0xE(t9)
    jr        ra
    sh        a1, 0x2(t9)               ; Delay slot
.endfunc

.close
