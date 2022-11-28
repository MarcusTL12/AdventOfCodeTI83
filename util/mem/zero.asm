#ifndef mem_zero_inc
#define mem_zero_inc

; hl: pointer to memory
; b: number of bytes
; destroys: hl = points to first byte after zerod memory
;           a = 0
mem_zero:
    xor a
    mem_zero_loop:
        ld (hl), a
        inc hl
        djnz mem_zero_loop
    ret

#endif
