#include "../../header.asm"

title:
   .db "2015 d2p2",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld a, 187
    ld hl, 60346
    call mul_a_hl

    push af
    bcall(_disphl)
    bcall(_newline)
    pop af

    ld l, a
    ld h, 0
    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

#include "../../util/mul_a_hl.asm"
