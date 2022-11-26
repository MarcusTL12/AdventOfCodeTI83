#ifndef parse_u8_inc
#define parse_u8_inc

#include "mul_a_10.asm"

; hl: pointer to string stops at first non-numerical digit, max 3 digits.
; a: set to number
; if hl points to non-numerical string, a will be set to 0
; destroys:
;   bc
;   hl (will be set to adress of first non-numeric character)
parse_u8:
    ld b, 0
    ld a, (hl)
    sub 48
    cp 10
    jp c, parse_u8_done

    ld b, a
    inc hl
    ld a, (hl)
    sub 48
    cp 10
    jp c, parse_u8_done

    ld a, c
    ld b, a
    call mul_a_10
    add a, c
    ld b, a

    inc hl
    ld a, (hl)
    sub 48
    cp 10
    jp c, parse_u8_done

    ld a, c
    ld b, a
    call mul_a_10
    add a, c
    ld b, a

    parse_u8_done:

    ld a, b
    ret

#endif
