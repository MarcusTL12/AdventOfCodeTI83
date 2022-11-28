#ifndef mem_lshft_inc
#define mem_lshft_inc

; hl: pointer to memory
; b: number of bytes
; new first bit will be set to carry flag at input
; carry flag will be set to old last bit at output
; destroys: hl, points to byte after mem
;           b = 0
mem_lshft:
    rl (hl)
    inc hl
    djnz mem_lshft
    ret

#endif
