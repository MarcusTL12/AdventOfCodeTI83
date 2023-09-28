#ifndef integer_divrem_a_inc
#define integer_divrem_a_inc

; #include "../debug/push_all.asm"

; Divide integer x by 8 bit integer
; input:
; hl: pointer to x
; a:  divisor
; b:  length of integer
;
; returns remainder in a
; leaves quotient in x
integer_divrem_a:
    ld e, b
    ld d, 0
    add hl, de
    dec hl
    ; Now hl points to most significant byte

    ld d, 0

    ; do recursion r_i = (r_i+1 % a, x_i)
    integer_divrem_a_loop:
        ; On entry to loop:
        ; hl: points to next byte of integer
        ; b:  remaining bytes of integer
        ; d:  remainder of previous division

        push bc

        ld e, (hl)
        ; Now de contains the next r_i

        push af ; save divisor a

        push hl ; save pointer to x_i

        ex de, hl

        ; push_all
        ; call mul_h_l
        ; bcall(_newline)
        ; pop_all

        bcall(_divhlbya)
        ld d, a
        ld a, l

        pop hl ; load pointer to x_i

        ld (hl), a

        pop af ; load divisor a

        dec hl ; decrement pointer to x_i-1

        pop bc
        ; b--
        djnz integer_divrem_a_loop

    ld a, d

    ret

#endif
