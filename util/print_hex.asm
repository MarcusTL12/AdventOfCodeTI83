#ifndef print_hex_inc
#define print_hex_inc

#include "add_hl_a.asm"

; Print memory location as hexadecimal
; hl: pointer to memory
; b: number of bytes
; destroys:
; af
; bc
print_hex:
    ld a, b ; make hl point to byte after last byte (most significant)
    add_hl_a

    print_hex_loop:
        dec hl
        ld a, (hl) ; load next byte into a and save in c
        ld c, a

        ex de, hl ; store away hl in de

        rrca ; print(hex_char(a >> 4))
        rrca
        rrca
        rrca
        and 0fh
        ld hl, print_hex_data
        add_hl_a
        ld a, (hl)
        bcall(_putc)

        ld a, c ; print(hex_char(a & 0xf))
        and 0fh
        ld hl, print_hex_data
        add_hl_a
        ld a, (hl)
        bcall(_putc)

        ex de, hl ; get back hl

        djnz print_hex_loop

    ret

print_hex_data:
    .db "0123456789ABCDEF"

#endif
