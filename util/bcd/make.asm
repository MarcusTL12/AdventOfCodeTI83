#ifndef bcd_make_inc
#define bcd_make_inc

#include "../mem/set.asm"
#include "../mem/lshft.asm"

bcd_outlen:
    .db 0
bcd_inplen:
    .db 0

; inputs:
;   hl: pointer to input
;   de: pointer to bcd output
;   b: number of bytes in input, max 16 (Mabey 32)
;   c: number of bytes in bcd output
; destroys:
;   zeroes input memory
bcd_make:
    ld (bcd_outlen), bc ; Save away lengths
    ex de, hl       ; zero out bcd buffer (and swap pointers)
    push hl
    ld a, (bcd_outlen)
    ld b, a
    xor a
    call mem_set
    pop hl

    and a ; b = 8 * saferam1[0]
    ld a, (bcd_inplen)
    rla
    rla
    rla
    ld b, a
    bcd_make_loop1:
        ld c, b ; Store away outer loop index

        and a ; clear carry flag
        ex de, hl ; Left shift input
        push hl
        ld a, (bcd_inplen)
        ld b, a
        call mem_lshft
        pop hl
        ex de, hl

        push hl
        ld a, (bcd_outlen)
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
