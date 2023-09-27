#ifndef integer_cmp_inc
#define integer_cmp_inc

#include "../add_hl_a.asm"

; Compares two arbitray (same) length integers
; input:
; hl: pointer to integer x
; de: pointer to integer y
; b: length of integers
; output:
; z flag set if they are equal
; c set if y > x
; destroys: bc, a
integer_cmp:
    ld a, b ; point both pointers to byte after last byte
    add_hl_a
    ld a, b
    ex de, hl
    add_hl_a

    integer_cmp_loop:
        dec hl
        dec de
        ld c, (hl)
        ld a, (de)
        cp c
        jp nz, integer_cmp_loop_break
        djnz integer_cmp_loop
    integer_cmp_loop_break:

    ex de, hl

    ret

#endif
