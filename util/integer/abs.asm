#ifndef integer_abs_inc
#define integer_abs_inc

#include "is_neg.asm"
#include "neg.asm"

; Takes absolute value of integer
; input:
;   hl: pointer to integer
;   b: number of bytes
integer_abs:
    push hl
    push bc
    call integer_is_neg
    pop bc
    pop hl

    ret p

    jp integer_neg ; tail call

#endif
