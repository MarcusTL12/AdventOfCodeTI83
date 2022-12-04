#include "../header.asm"

title:
    .db "test",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, test_data
    bcall(_puts)
    bcall(_newline)

    ld a, 2
    ld hl, test_data
    ld de, 9
    ld bc, test_cmp
    call qsort

    ld hl, test_data
    bcall(_puts)
    bcall(_newline)

    bcall(_getkey) ; Pause
    ret

test_cmp:
    ex de, hl
    ld a, (de)
    ld b, (hl)
    cp b
    ret

#include "../util/qsort.asm"

test_data:
    .db "3141592636",0
