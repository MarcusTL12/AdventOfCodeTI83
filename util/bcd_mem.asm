#ifndef bcd_mem_inc
#define bcd_mem_inc

#include "zero_mem.asm"
#include "lshft_mem.asm"

; inputs:
;   hl: pointer to input
;   de: pointer to bcd output
;   saferam1[0]: number of bytes in input, max 16 (Mabey 32)
;   saferam1[1]: number of bytes in bcd output
; destroys:
;   zeroes integer memory
bcd_mem:
    ex de, hl       ; zero out bcd buffer
    push hl
    ld a, (saferam1 + 1)
    ld b, a
    call zero_mem
    pop hl

    and a ; b = 8 * saferam[0]
    ld a, (saferam1)
    rla
    rla
    rla
    ld b, a
    bcd_mem_loop1:
        ld c, b ; Store away outer loop index

        and a ; clear carry flag
        ex de, hl ; Left shift integer
        push hl
        ld a, (saferam1)
        ld b, a
        call lshft_mem
        pop hl
        ex de, hl

        push hl ; Left shift bcd
        ld a, (saferam1 + 1)
        ld b, a
        call lshft_mem
        pop hl

        ld a, (saferam1 + 1)
        ld b, a
        bcd_mem_loop2:
            and a ; clear carry
            ld a, (hl)
            daa
            ld (hl), a

            inc hl
            jp nc, bcd_mem_carry
            inc (hl) ; Increment next one if current carried

            bcd_mem_carry:
            djnz bcd_mem_loop2

        ld b, c
        djnz bcd_mem_loop1

    ret

#endif
