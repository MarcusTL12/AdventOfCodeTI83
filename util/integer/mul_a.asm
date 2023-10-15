#ifndef integer_mul_a_inc
#define integer_mul_a_inc

#include "../mul_h_l.asm"

; Multiplies integer with a
; Input:
;   hl: pointer to integer
;   a: other factor
;   b: number of bytes in integer
; Output:
;   Integer is multiplied in place
;   a: overflow byte
; Destroys:
;   hl, de, bc
integer_mul_a:
    ex de, hl
    ld h, 0
    or a ; clear carry flag
    integer_mul_a_loop:
        ex de, hl
        ld e, (hl)
        ld (hl), d
        ex de, hl
        ld h, a
        push af
        push de
        call mul_h_l
        pop de
        pop af

        ld c, a
        ld a, l
        ex de, hl
        adc a, (hl)
        ex de, hl
        ld (de), a
        ld a, c

        inc de

        djnz integer_mul_a_loop

    ld a, h
    ret nc
    inc a
    ret

#endif
