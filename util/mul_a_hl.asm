#ifndef mul_a_hl_inc
#define mul_a_hl_inc

#include "mul_h_l.asm"
#include "add_hl_a.asm"

; output: 24-bit integer in ahl
; destroys:
;   de
mul_a_hl:
    push hl
    push af
    ld l, a
    call mul_h_l
    ex de, hl
    pop af
    pop hl

    push de
    ld h, a
    call mul_h_l
    pop de

    ex de, hl
    ld a, d
    add_hl_a

    ld a, h
    ld h, l
    ld l, e

    ret

#endif
