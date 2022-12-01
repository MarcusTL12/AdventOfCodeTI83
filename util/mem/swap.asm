#ifndef mem_swap_inc
#define mem_swap_inc

; x, y = y, x
; input:
; hl: pointer to x memory
; de: pointer to y memory
; b: number of bytes to swap
; output:
; destroys:
; de, hl, bc
; a
mem_swap:
    ld c, (hl)
    ld a, (de)
    ex de, hl
    ld (hl), c
    ld (de), a
    inc hl
    inc de
    djnz mem_swap
    ret

#endif
