#ifndef integer_neg_inc
#define integer_neg_inc

#include "../mem/invert.asm"
#include "inc.asm"

; Negates integer
; input:
;   hl: pointer to integer
;   b: number of bytes
integer_neg:
    push hl
    push bc
    call mem_invert
    pop bc
    pop hl

    jp integer_inc ; tail call

#endif
