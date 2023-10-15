#ifndef integer_adc_a_inc
#define integer_adc_a_inc

#include "inc.asm"

; hl: pointer to destination integer
; a: number to add
; b: number of bytes
; destroys: hl, a, b
integer_adc_a:
    adc a, (hl)
    ld (hl), a
    ret nc
    inc hl
    dec b
    jp nz, integer_inc ; tail call

#endif
