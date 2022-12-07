#include "../header.asm"

title:
    .db "test2",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, test_data
    bcall(_puts)

    bcall(_getkey) ; Pause
    ret

test_data:
    .db "AB$C",0
