#include "../../header.asm"

title:
   .db "2015 d2p1",0

#include "../../util/parse_u8.asm"

main:
    bcall(_clrscrf)
    bcall(_homeup)

    ld hl, input
    call parse_u8
    ld h, 0
    ld l, a

    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

input:
    .db "123x58",0
