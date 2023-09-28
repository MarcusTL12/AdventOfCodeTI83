#ifndef mul_h_l_inc
#define mul_h_l_inc

#include "mul_hl_2.asm"

; Alternative to _htimesl which can deal with h = 0 and is hopefully faster
; input:
;   h: x
;   l: y
; output:
;   hl: x * y
; destroys:
;   af, de
; time:
;   const: 4 * 4 + 7 + 10 = 33
;   loop: 73 / 87
;       const: 4 * 2 + 11 + 20 + 10 + 12 = 61
;       bit:   7 + 4 + 11 + 4 = 26
;       nobit: 12
;   worst case:
;       33 + 8 * 87 - (12 - 7) = 724 => 120.67 µs
;   best case:
;       33 + 73 - (12 - 7) = 16.83 µs
mul_h_l:
    ; a = x, hl = y, de = 0
    ld a, h ; 4
    ld h, 0 ; 7
    ld d, h ; 4
    ld e, h ; 4

    mul_h_l_loop:
        or a                        ; 4
        rra                         ; 4
        push af                     ; 11
        jr nc, mul_h_l_not_add      ; 12 / 7
        ; if bit then add to acc
        ex de, hl                   ; 4
        add hl, de                  ; 11
        ex de, hl                   ; 4
        mul_h_l_not_add:
        mul_hl_2                    ; 20
        pop af                      ; 10
        jr nz, mul_h_l_loop         ; 12 / 7

    ex de, hl   ; 4
    ret         ; 10

#endif
