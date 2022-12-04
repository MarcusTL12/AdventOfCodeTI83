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
    ld c, (hl)    ; 7, 1
    ld a, (de)    ; 7, 1
    ex de, hl     ; 4, 1
    ld (hl), c    ; 7, 1
    ld (de), a    ; 7, 1
    inc hl        ; 6, 1
    inc de        ; 6, 1
    djnz mem_swap
    ret


#endif
