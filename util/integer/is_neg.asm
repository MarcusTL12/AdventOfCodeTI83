#ifndef integer_is_neg_inc
#define integer_is_neg_inc

#include "../add_hl_a.asm"

; Checks if an integer is negative
; Inputs:
;   hl: pointer to integer
;   b: number of bytes in integer
; Returns
;   Sign flag set if negative
; Destroys
;   hl, a
integer_is_neg:
    ld a, b
    dec a
    add_hl_a
    xor a
    or (hl)
    ret

#endif
