#ifndef integer_cmp_signed_inc
#define integer_cmp_signed_inc

#include "cmp.asm"
#include "is_neg.asm"

; Compares two arbitray (same) length signed integers
; input:
; hl: pointer to integer x
; de: pointer to integer y
; b: length of integers
; output:
; z flag set if they are equal
; c set if y > x
; destroys: bc, a
integer_cmp_signed:
    push hl
    call integer_is_neg
    pop hl

    ex af, af'
    ex de, hl
    push hl
    call integer_is_neg
    pop hl
    ex de, hl

    ; f:  de negative
    ; f': hl negative

    ; flip f' if f
    jr nc, integer_cmp_signed_not_flip
    ex af, af'
    ccf
    ex af, af'
    integer_cmp_signed_not_flip:

    ex af, af'
    jp nc, integer_cmp ; tail call if same sign

    ex af, af'
    ret

#endif
