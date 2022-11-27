#ifndef print_bcd_inc
#define print_bcd_inc

#include "add_a2hl.asm"

; hl: pointer to bcd (least significant first)
; b: number of bytes (halv number of digits)
; destroyed: d
print_bcd:
    ld a, b
    dec a
    call add_a2hl

    print_bcd_loop:
        ld d, (hl)  ; d = *hl

        ld a, d     ; print((d >> 4) & 0x0f + 48)
        rrca
        rrca
        rrca
        rrca
        and 0fh
        add a, 48
        bcall(_putc)

        ld a, d     ; print(d & 0x0f + 48)
        and 0fh
        add a, 48
        bcall(_putc)

        dec hl
        djnz print_bcd_loop

    ret

#endif
