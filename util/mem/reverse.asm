#ifndef mem_reverse_inc
#define mem_reverse_inc

#include "../add_hl_a.asm"

; reverses byte order of memory
; input:
;   hl: pointer to start of memory
;   b: length of memory
; destroys:
;   hl, de, bc, af
mem_reverse:
    ex de, hl
    push de
    pop hl
    ld a, b
    add_hl_a
    dec hl
    ex de, hl ; now de points to last element

    sra b ; b = b / 2
    ret z ; return early if no elements to swap
    mem_reverse_loop:
        ld a, (de)
        ld c, (hl)
        ex de, hl
        ld (de), a
        ld (hl), c
        ex de, hl
        inc hl
        dec de
        djnz mem_reverse_loop

    ret

#endif
