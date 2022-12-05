#include "../header.asm"

title:
    .db "test2",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld h, -1
    ld l, 14
    bcall(_htimesl)
    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret
