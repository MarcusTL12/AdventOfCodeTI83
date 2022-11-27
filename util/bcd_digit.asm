#ifndef bcd_digit_inc
#define bcd_digit_inc

; input a = ah,al
; output ax = ax + (ax >= 5 ? 3 : 0)
; destroys: de
bcd_digit:
    ld d, a

    and 0fh
    cp 5
    jp c, bcd_digit_skip_al
    add a, 3
    bcd_digit_skip_al:
    ld e, a
    ld a, d
    and f0h
    cp 80
    jp c, bcd_digit_skip_ah
    add a, 48
    bcd_digit_skip_ah:
    add a, e

    ret

#endif
