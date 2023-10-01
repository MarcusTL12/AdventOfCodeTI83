#ifndef integer_inc_inc
#define integer_inc_inc

; Increments integer in memory.
; hl: pointer to integer
; b: number of bytes
; destroys:
;   hl: points to first byte to not be incremented
integer_inc:
    inc (hl)
    inc hl
    ret nz
    djnz integer_inc
    ret

#endif
