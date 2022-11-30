#ifndef integer_inc_inc
#define integer_inc_inc

; Increments integer in memory. Goes on until non-carry,
; so do not use for wrap-around.
; hl: pointer to integer
; destroys:
;   hl: points to first byte to not be incremented
integer_inc:
    inc (hl)
    inc hl
    jp z, integer_inc
    ret

#endif
