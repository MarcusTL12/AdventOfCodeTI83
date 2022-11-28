#ifndef bcd_make_inc
#define bcd_make_inc

#include "../mem/zero.asm"
#include "../mem/lshft.asm"

; inputs:
;   hl: pointer to input
;   de: pointer to bcd output
;   saferam1[0]: number of bytes in input, max 16 (Mabey 32)
;   saferam1[1]: number of bytes in bcd output
; destroys:
;   zeroes input memory
bcd_make:
    ex de, hl       ; zero out bcd buffer (and swap pointers)
    push hl
    ld a, (saferam1 + 1)
    ld b, a
    call mem_zero
    pop hl

    and a ; b = 8 * saferam1[0]
    ld a, (saferam1)
    rla
    rla
    rla
    ld b, a
    bcd_make_loop1:
        ld c, b ; Store away outer loop index

        and a ; clear carry flag
        ex de, hl ; Left shift input
        push hl
        ld a, (saferam1)
        ld b, a
        call mem_lshft
        pop hl
        ex de, hl

        push hl
        ld a, (saferam1 + 1)
        ld b, a
        bcd_make_loop2:
            ld a, (hl)
            adc a, a
            daa
            ld (hl), a

            inc hl
            djnz bcd_make_loop2
        pop hl

        ld b, c
        djnz bcd_make_loop1

    ret

#endif