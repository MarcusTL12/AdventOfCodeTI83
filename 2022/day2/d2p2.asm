#include "../../header.asm"

title:
    .db "2022 d2p2",0

#include "../../util/add_hl_a.asm"

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld de, 0 ; ans = 0
    ld hl, input
    loop1:
        ld a, (hl)
        cp 0
        jp z, loop1_break

        inc hl
        inc hl

        ld c, (hl)

        inc hl
        inc hl
        ex de, hl
        push de

        sub 'A'
        ld b, a
        ld a, c
        sub 'X'

        ; now a = xyz, b = abc

        ; need to calculate:
        ; ans += a * 3 + (a + b + 2) % 3 + 1

        push af

        add a, b ; a = a + b + 2
        add a, 2

        ld d, a ; a = a % 3
        ld e, 3
        call div_d_e


        ld b, a ; a = a + 3 * orig_a + 1
        pop af
        ld c, a
        add a, a
        add a, c
        add a, b
        inc a

        add_hl_a

        pop de
        ex de, hl
        jp loop1
    loop1_break:

    ex de, hl
    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

#include "../../util/div_d_e.asm"

input:
    #incbin "input"
    .db 0
