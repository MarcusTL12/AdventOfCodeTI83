#include "../header.asm"

title:
    .db "test",0

#define x saferam1

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, main
    bcall(_disphl)
    bcall(_newline)
    bcall(_getkey) ; Pause

    ld hl, 0
    ld (x + 1), hl
    ld a, 8
    ld (x), a

    ld hl, x
    ld de, 5
    ld b, 3
    call integer_sub_de

    bcall(_getkey) ; Pause
    ret

#include "../util/integer/sub_de.asm"
