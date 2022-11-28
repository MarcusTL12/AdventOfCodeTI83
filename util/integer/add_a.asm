#ifndef integer_add_a_inc
#define integer_add_a_inc

#include "inc.asm"

; Carry will carry on until no carry. Do not use for overflow
; hl: pointer to destination integer
; a: number to add
; destroys: hl, a
integer_add_a:
    add a, (hl)
    ld (hl), a
    ret nc
    inc hl
    jp integer_inc ; tail call

#endif
