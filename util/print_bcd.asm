#ifndef print_bcd_inc
#define print_bcd_inc

TODO

#include "add_a2hl.asm"

; hl: pointer to bcd (least significant first)
; b: number of bytes (halv number of digits)
print_bcd:
    ld a, b
    dec a
    call add_a2hl

    print_bcd_loop:
        ld a, (hl)

        dec hl
        djnz print_bcd_loop

    ret

#endif
