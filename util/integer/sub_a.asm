#ifndef integer_sub_a_inc
#define integer_sub_a_inc

#include "dec.asm"

; Carry will carry on until no carry.
; hl: pointer to destination integer
; a: number to sub
; b: number of bytes
; destroys: hl, a, b
integer_sub_a:
    neg
    add a, (hl)
    ld (hl), a
    ret c
    inc hl
    dec b
    jp integer_dec ; tail call

#endif
