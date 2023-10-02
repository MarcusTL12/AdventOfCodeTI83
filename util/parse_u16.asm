#ifndef parse_u16_inc
#define parse_u16_inc

#include "add_hl_a.asm"

; input:
; hl: pointer to string. Stops at first non-numerical digit, max 5 digits.
; output:
; de: set to number (zero if non numerical)
; hl: first character not in number
; destroys:
; b
parse_u16:
    ex de, hl
    ld hl, 0

    ld b, 5
    parse_u16_loop:
        ld a, (de)
        sub 48
        cp 10
        jp nc, parse_u16_loop_break ; check char is numeric

        ; if numeric hl = 10 * hl + a
        push de ; hl = 10 * hl, 73 clc
        add hl, hl ; hl *= 2
        ld d, h ; de = hl
        ld e, l
        add hl, hl ; hl *= 4
        add hl, hl
        add hl, de ; hl += de
        pop de

        add_hl_a                    ; if so, add to hl
        inc de
        djnz parse_u16_loop
    parse_u16_loop_break:

    ex de, hl
    ret

#endif
