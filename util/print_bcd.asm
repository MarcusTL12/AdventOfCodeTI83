#ifndef print_bcd_inc
#define print_bcd_inc

#include "add_a2hl.asm"

; hl: pointer to bcd (least significant first)
; b: number of bytes (half number of digits)
; destroyed: d
print_bcd:
    ld a, b
    call add_a2hl

    ld c, 0

    print_bcd_loop:
        dec hl
        ld d, (hl)  ; d = *hl

        ld a, d     ; print((d >> 4) & 0x0f + 48)
        rrca
        rrca
        rrca
        rrca
        and 0fh
        call print_bcd_print_char

        ld a, d     ; print(d & 0x0f + 48)
        and 0fh
        call print_bcd_print_char

        djnz print_bcd_loop

    bit 0, c
    ret nz

    ld a, 48 ; print zero if nothing printed yet
    bcall(_putc)

    ret

; To print the character, but not leading zeros
; a: integer digit to print
; c: non-zero been printed?
print_bcd_print_char:
    ld e, a
    jp nz, print_bcd_print
    bit 0, c
    ret z
    print_bcd_print:
    ld c, 1
    add a, 48
    bcall(_putc)
    ret

#endif
