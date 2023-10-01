#ifndef integer_dec_inc
#define integer_dec_inc

; Decrements integer in memory.
; hl: pointer to integer
; b: number of bytes
; destroys:
;   hl, b, a
integer_dec:
    ld c, -1
    integer_dec_loop:
        ld a, c
        add a, (hl)
        ld (hl), a
        inc hl
        ret c
        djnz integer_dec_loop
    ret

#endif
