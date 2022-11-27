#ifndef hex_dehl_inc
#define hex_dehl_inc

#include "../add_a2hl.asm"

; Convert u32 in dehl to hex string located in saferam1[0:7]
; Destroys af, bc, de, hl, saferam1[8:11]
hex_dehl:
    ld (saferam1 + 8), de
    ld (saferam1 + 10), hl

    ld b, 4
    ld c, 0

    hex_dehl_loop:
        ld a, c                 ; d = saferam1[8 + c]
        ld hl, saferam1 + 8
        call add_a2hl
        ld d, (hl)

        ld a, d                 ; e = hex_char(d >> 4)
        rrca
        rrca
        rrca
        rrca
        and ffh
        ld hl, hex_dehl_data
        call add_a2hl
        ld e, (hl)

        ld a, c                 ; saferam1[2c] = e
        add a, a
        ld hl, saferam1
        call add_a2hl
        ld (hl), e

        ld a, d                 ; e = hex_char(d & 0xff)
        and ffh
        ld hl, hex_dehl_data
        call add_a2hl
        ld e, (hl)

        ld a, c                 ; saferam1[2c + 1] = e
        add a, a
        inc a
        ld hl, saferam1
        call add_a2hl
        ld (hl), e

        djnz hex_dehl_loop

    ret

hex_dehl_data:
    .db "0123456789ABCDEF"

#endif
