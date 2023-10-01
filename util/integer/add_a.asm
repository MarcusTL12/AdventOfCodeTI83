#ifndef integer_add_a_inc
#define integer_add_a_inc

#include "inc.asm"

; hl: pointer to destination integer
; a: number to add
; b: number of bytes
; destroys: hl, a, b
integer_add_a:
    add a, (hl)
    ld (hl), a
    ret nc
    inc hl
    jp integer_inc ; tail call

#endif
