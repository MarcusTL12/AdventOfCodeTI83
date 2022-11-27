#ifndef lshft_mem_inc
#define lshft_mem_inc

; hl: pointer to memory
; b: number of bytes
; new first bit will be set to carry flag at input
; carry flag will be set to old last bit at output
; destroys: hl, points to byte after mem
;           b = 0
lshft_mem:
    rl (hl)
    inc hl
    djnz lshft_mem
    ret

#endif
