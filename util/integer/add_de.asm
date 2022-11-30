#ifndef integer_add_de_inc
#define integer_add_de_inc

#include "inc.asm"

; Carry will carry on until no carry. Do not use for overflow
; hl: pointer to destination integer
; de: number to add
; destroys: bc, hl
integer_add_de:
    ld c, (hl)
    inc hl
    ld b, (hl)
    ex de, hl
    add hl, bc
    ex de, hl
    ld (hl), d
    dec hl
    ld (hl), e

    inc hl
    inc hl
    ret nc ; return if 16 bit addition did not carry
    jp integer_inc ; tail call

#endif
