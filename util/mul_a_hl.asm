#ifndef mul_a_hl_inc
#define mul_a_hl_inc

#include "add_hl_a.asm"

; output: 24-bit integer in ahl
; destroys:
;   de
mul_a_hl:
    push hl
    push af
    ld l, a
    bcall(_htimesl)
    ex de, hl
    pop af
    pop hl

    push de
    ld h, a
    bcall(_htimesl)
    pop de

    ex de, hl
    ld a, d
    add_hl_a

    ld a, h
    ld h, l
    ld l, e

    ret

#endif
