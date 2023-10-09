#ifndef integer_cmp_signed_inc
#define integer_cmp_signed_inc

#include "../ld_cf_sf.asm"

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

    call ld_cf_sf

    ex af, af'
    ex de, hl
    push hl
    call integer_is_neg
    pop hl
    ex de, hl

    call ld_cf_sf

    ; f:  de negative
    ; f': hl negative

    ; flip f' if f
    jr nc, integer_cmp_signed_de_neg
    ex af, af'
    ccf
    ex af, af'
    integer_cmp_signed_de_neg:

    ; f': true if different signs

    ex af, af'
    jp nc, integer_cmp ; tail call if same sign


    ; Return f (de negative) if different sign.
    ex af, af'

    ; Clear zero flag
    ld a, 1
    bit 0, a

    ret

#endif
