#ifndef parse_u8_inc
#define parse_u8_inc

#include "mul_a_10.asm"

; input:
; hl: pointer to string stops at first non-numerical digit, max 3 digits.
; output:
; a: set to number
; if hl points to non-numerical string, a will be set to 0
; destroys:
;   bc
;   de
;   hl (will be set to adress of first non-numeric character)
parse_u8:
    ld b, 0
    ld a, (hl)
    sub 48
    cp 10
    jp nc, parse_u8_done ; Check hl[0] is numeric

    ld b, a ; if so, save to b

    inc hl
    ld a, (hl)
    sub 48
    cp 10
    jp nc, parse_u8_done ; Check hl[1] is numeric

    ld c, a ; If so, b = 10 * b + a
    ld a, b
    call mul_a_10
    add a, c
    ld b, a

    inc hl
    ld a, (hl)
    sub 48
    cp 10
    jp nc, parse_u8_done ; Check hl[2] is numeric

    ld c, a ; If so, b = 10 * b + a
    ld a, b
    call mul_a_10
    add a, c
    ld b, a

    parse_u8_done:
    ld a, b
    ret

#endif
