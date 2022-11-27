#ifndef zero_mem_inc
#define zero_mem_inc

; hl: pointer to memory
; b: number of bytes
; destroys: hl = points to first byte after zerod memory
;           a = 0
zero_mem:
    xor a
    zero_mem_loop:
        ld (hl), a
        inc hl
        djnz zero_mem_loop
    ret

#endif
