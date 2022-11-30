#ifndef bcd_print_inc
#define bcd_print_inc

#include "../add_a_hl.asm"

; hl: pointer to bcd (least significant first)
; b: number of bytes (half number of digits)
; destroyed: d
bcd_print:
    ld a, b
    add_a_hl

    ld c, 0

    bcd_print_loop:
        dec hl
        ld d, (hl)  ; d = *hl

        ld a, d     ; print((d >> 4) & 0x0f + 48)
        rrca
        rrca
        rrca
        rrca
        and 0fh
        call bcd_print_print_char

        ld a, d     ; print(d & 0x0f + 48)
        and 0fh
        call bcd_print_print_char

        djnz bcd_print_loop

    bit 0, c
    ret nz

    ld a, 48 ; print zero if nothing printed yet
    bcall(_putc)

    ret

; To print the character, but not leading zeros
; a: integer digit to print
; c: non-zero been printed?
bcd_print_print_char:
    ld e, a
    jp nz, bcd_print_print
    bit 0, c
    ret z
    bcd_print_print:
    ld c, 1
    add a, 48
    bcall(_putc)
    ret

#endif
