#ifndef mem_set_inc
#define mem_set_inc

; hl: pointer to memory
; a: byte value to set memory to
; b: number of bytes
; destroys:
; hl = points to first byte after zerod memory
; b
; time:
;   7 + 6 + 13 = 26 per byte
mem_set:
    ld (hl), a
    inc hl
    djnz mem_set
    ret

#endif
