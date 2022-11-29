#include "../../header.asm"

title:
   .db "2015 d2p2",0

main:
    bcall(_clrscrf)
    bcall(_homeup)

    ld hl, input
    ld b, 11
    call max_u8

    push de
    ld l, d
    ld h, 0
    bcall(_disphl)
    bcall(_newline)
    pop de

    ld l, e
    ld h, 0
    bcall(_disphl)
    bcall(_newline)

    bcall(_getkey) ; Pause
    ret

#include "../../util/max_u8.asm"

input:
    .db 3,5,2,6,4,7,1,8,9,28,17
