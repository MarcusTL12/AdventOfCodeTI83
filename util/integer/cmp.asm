#ifndef integer_cmp_inc
#define integer_cmp_inc

#include "../add_a_hl.asm"

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
    add_a_hl
    ld a, b
    ex de, hl
    add_a_hl

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
