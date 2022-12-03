#include "../../header.asm"

title:
    .db "2022 d3p2",0

#include "../../util/add_a_hl.asm"

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ; For 2 * 26 = 52 bits long. Takes 7 bytes
    #define charset_a saferam1
    #define charset_b saferam1 + 7

    ld hl, input
    ld de, 0 ; ans

    loop1:
        push hl
        ld a, ffh
        ld b, 7
        ld hl, charset_a
        call mem_set ; fill charset a
        pop hl

        ld a, (hl)
        cp 0
        jp z, loop1_break ; Check if reached end of input
        push de

        ld b, 3
        loop2:
            push bc
            push hl
            xor a
            ld b, 7
            ld hl, charset_b
            call mem_set ; zero charset b
            pop hl

            loop3:
                ld a, (hl)
                inc hl
                cp '\n'
                jp z, loop3_break

                push hl
                ld hl, charset_b
                call get_priority
                call bitset_u8_set
                pop hl

                jp loop3
            loop3_break:

            push hl
            ld hl, charset_a
            ld de, charset_b
            ld b, 7
            call mem_and
            pop hl

            pop bc
            djnz loop2

        push hl
        xor a
        ld b, 0
        ld hl, charset_a
        loop4:
            cp (hl)
            jp nz, loop4_break
            inc b
            inc hl
            jp loop4
        loop4_break:

        ld a, b
        add a, a
        add a, a
        add a, a
        ld b, a ; b = 8 * b

        ld a, (hl)

        loop5:
            bit 0, a
            jp nz, loop5_break
            inc b
            rrca
            jp loop5
        loop5_break:

        ld a, b

        pop hl

        pop de

        ex de, hl
        inc a
        add_a_hl
        ex de, hl

        jp loop1
    loop1_break:

    ex de, hl
    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

#include "priority.asm"

#include "../../util/mem/set.asm"
#include "../../util/mem/and.asm"

#include "../../util/bitset_u8.asm"
#include "../../util/print_hex.asm"

input:
    #incbin "input"
    .db 0