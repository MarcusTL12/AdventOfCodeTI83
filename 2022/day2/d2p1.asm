#include "../../header.asm"

title:
    .db "2022 d2p1",0

#include "../../util/add_a_hl.asm"

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
        ; ans += (a + 1) + (a - b + 4) % 3 * 3

        push af

        ld c, a ; a = a - b + 4
        ld a, b
        neg
        add a, c
        add a, 4

        ld d, a ; a = a % 3
        ld e, 3
        call div_d_e

        ld b, a ; a = a * 3
        add a, a
        add a, b

        ld b, a ; a = a + orig_a + 1
        pop af
        add a, b
        inc a

        add_a_hl

        pop de
        ex de, hl
        jp loop1
    loop1_break:

    ex de, hl
    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

#include "../../util/div_d_e.asm"

; #include "../../util/integer/cmp.asm"
; #include "../../util/integer/add.asm"
; #include "../../util/integer/parse.asm"

; #include "../../util/mem/set.asm"
; #include "../../util/mem/copy.asm"

; #include "../../util/bcd/make.asm"
; #include "../../util/bcd/print.asm"

input:
    #incbin "input"
    .db 0
