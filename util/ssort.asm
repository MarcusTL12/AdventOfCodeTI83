#ifndef ssort_inc
#define ssort_inc

ssort_elsize:
    .db 0
ssort_rem_len:
    .dw 0

#include "add_hl_a.asm"

#include "mem/swap.asm"

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
;           expected to destroy all registers
; destroys all registers
ssort:
    ld (ssort_elsize), a
    ld (ssort_compare_call + 1), bc

    ld (ssort_rem_len), de
    ld bc, (ssort_rem_len)

    inc b ; for looping correctly
    ssort_loop1:
        ld a, b ; for looping correctly
        ld b, c
        ld c, a
        ssort_loop2:
            push bc
            push hl

            ; find min remaining element

            push hl
            pop de ; de points to current min

            ld bc, (ssort_rem_len)
            inc b
            ssort_loop3:
                ld a, b
                ld b, c
                ld c, a
                ssort_loop4:
                    push bc
                    push hl
                    push de
                    ssort_compare_call:
                    call 0 ; address of compare function will be set above
                    pop de
                    pop hl
                    pop bc

                    jp nc, ssort_not_update_min

                    push hl
                    pop de ; update min to current element

                    ssort_not_update_min:

                    ld a, (ssort_elsize)
                    add_hl_a
                    djnz ssort_loop4
                ld a, b
                ld b, c
                ld c, a
                djnz ssort_loop3

            pop hl

            push hl
            push de
            ld a, (ssort_elsize)
            ld b, a
            call mem_swap ; do swap
            pop de
            pop hl

            ld a, (ssort_elsize)
            add_hl_a            ; make hl point to next unsorted element

            push hl
            ld hl, (ssort_rem_len)
            dec hl              ; and decrement remaining length
            ld (ssort_rem_len), hl
            pop hl

            pop bc
            djnz ssort_loop2

        ld a, b ; for looping correctly
        ld b, c
        ld c, a
        djnz ssort_loop1

    ret

#endif
