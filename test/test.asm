#include "../header.asm"

title:
    .db "test",0

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

    ld hl, 78
    ld bc, 56
    add hl, bc
    bcall(_disphl)
    bcall(_newline)

    ld hl, test_data
    bcall(_puts)

    bcall(_getkey) ; Pause
    ret

test_data:
    .db "AB$C",0
