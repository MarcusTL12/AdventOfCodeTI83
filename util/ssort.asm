#ifndef ssort_inc
#define ssort_inc

#define elsize saferam1
#define rem_len saferam1 + 1

#include "add_a_hl.asm"

; selection sort
; input:
;   a: size of element
;   hl: pointer to start of array
;   de: length of array (n elements)
;   bc: function pointer to comparison function:
;       input:
;           hl: pointer to element a
;           de: pointer to element b
;           compares a - b
;           output: zero flag set if equal, carry flag set if b > a
;           expected to destroy all registers, but not saferam1[0:6]
; destroys all registers
ssort:
    ld (elsize), a
    ld (ssort_compare_call + 1), bc

    ld (rem_len), de
    ld bc, (rem_len)

    inc b ; for looping correctly
    ssort_loop1:
        ld a, b ; for looping correctly
        ld b, c
        ld c, a
        ssort_loop2:
            push bc
            push hl

            ; find max remaining element

            push hl
            pop de ; de points to current max

            ld bc, (rem_len)
            inc b
            ssort_loop3:
                ld a, b
                ld b, c
                ld c, a
                ssort_loop4:
                    ; todo: compare
                    djnz ssort_loop4
                ld a, b
                ld b, c
                ld c, a
                djnz ssort_loop3

            pop hl

            ; TODO: do swap

            ld a, (elsize)
            add_a_hl            ; make hl point to next unsorted element

            push hl
            ld hl, (rem_len)
            dec hl              ; and decrement remaining length
            ld (rem_len), hl
            pop hl

            pop bc
            djnz ssort_loop2

        ld a, b ; for looping correctly
        ld b, c
        ld c, a
        djnz ssort_loop1


    ret

#endif
