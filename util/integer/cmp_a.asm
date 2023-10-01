#ifndef integer_cmp_a_inc
#define integer_cmp_a_inc

#include "../add_hl_a.asm"

; Compares arbitray length integer with 8 bit integer in a
; input:
;   hl: pointer to integer x
;   a: integer y
;   b: length of integer
; output:
; z flag set if they are equal
; c set if y > x
; destroys: bc, a
integer_cmp_a:
    ld c, a

    ld a, b ; point pointer to byte after last byte
    add_hl_a

    dec b ; loop over all but first byte
    xor a
    integer_cmp_a_loop:
        dec hl
        cp (hl)
        ccf
        jp nz, integer_cmp_a_loop_break
        djnz integer_cmp_a_loop
    integer_cmp_a_loop_break:

    dec hl
    ld a, c
    cp (hl)
    ccf

    ret

#endif
