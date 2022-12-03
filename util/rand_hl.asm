#ifndef rand_hl_inc
#define rand_hl_inc

#include "div_hl_de.asm"

; input:
;   de: upper limit
; output:
;   hl: random number in range [0, de)
rand_hl:
    ld b, 0
    call ionRandom
    ld l, a
    ld b, 0
    call ionRandom
    ld h, a

    call div_hl_de
    ex de, hl
    ret

#endif
