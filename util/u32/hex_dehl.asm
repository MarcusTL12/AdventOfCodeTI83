#ifndef hex_dehl_inc
#define hex_dehl_inc

#include "../add_a2hl.asm"

; Convert u32 in dehl to hex string located in saferam1[0:7]
; Destroys af, bc, de, hl, saferam1[8:11]
; Time =
; 16 + 20 + 7 * 2 +                         #1
; 4 * (
;       4 + 10 + 46/47 + 7 +                #2
;       4 + 4 * 4 + 7 + 10 + 46/47 + 7 +    #3
;       4 + 4 + 10 + 46/47 + 7 +            #4
;       4 + 7 + 10 + 46/47 + 7 +            #5
;       4 + 4 + 4 + 10 + 46/47 + 7 +        #6
;       4 + 4 + 4 + 7                       #7
; ) + 10 * 3 + 1 +
; 10
; = 1675 - 1695 ~ 0.28 ms @ 6MHz
hex_dehl:
    ld (saferam1 + 8), hl   ; saveram[8:11] = [l, h, e, d] #1
    ld (saferam1 + 10), de

    ld b, 3
    ld c, 0

    hex_dehl_loop:
        ld a, b                 ; d = saferam1[8 + b] #2
        ld hl, saferam1 + 8
        call add_a2hl
        ld d, (hl)

        ld a, d                 ; e = hex_char(d >> 4) #3
        rrca
        rrca
        rrca
        rrca
        and 0fh
        ld hl, hex_dehl_data
        call add_a2hl
        ld e, (hl)

        ld a, c                 ; saferam1[2c] = e #4
        add a, a
        ld hl, saferam1
        call add_a2hl
        ld (hl), e

        ld a, d                 ; e = hex_char(d & 0xff) #5
        and 0fh
        ld hl, hex_dehl_data
        call add_a2hl
        ld e, (hl)

        ld a, c                 ; saferam1[2c + 1] = e #6
        add a, a
        inc a
        ld hl, saferam1
        call add_a2hl
        ld (hl), e

        inc c                   ; c++, b--, if c != 4 jmp loop #7
        dec b
        ld a, c
        cp 4
        jp nz, hex_dehl_loop

    ret

hex_dehl_data:
    .db "0123456789ABCDEF"

#endif
