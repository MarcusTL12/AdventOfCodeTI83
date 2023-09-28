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
    call mul_h_l
    bcall(_newline)
    bcall(_getkey) ; Pause

    ld h, 78
    ld l, 56
    call mul_h_l
    call mul_h_l
    bcall(_newline)

    bcall(_getkey) ; Pause
    ret

#include "../util/mul_h_l.asm"
