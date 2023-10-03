#ifndef integer_sub_de_inc
#define integer_sub_de_inc

#include "sub_a.asm"

; hl: pointer to destination integer
; de: number to subtract
; b: number of bytes
; destroys: bc, hl, a, b
integer_sub_de:
    push hl
    push de
    push bc
    ld a, e
    call integer_sub_a
    pop bc
    pop de
    pop hl

    inc hl
    dec b
    ld a, d
    jp integer_sub_a

#endif
