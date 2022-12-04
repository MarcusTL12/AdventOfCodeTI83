#include "../header.asm"

title:
    .db "test2",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, test_data1
    ld de, test_data2
    ld b, 9
    call mem_swap

    ld hl, test_data1
    bcall(_puts)
    bcall(_newline)

    ld hl, test_data2
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

#include "../util/mem/swap.asm"

test_data1:
    .db "314159263",0

test_data2:
    .db "271828182",0
