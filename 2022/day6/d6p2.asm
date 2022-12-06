#include "../../header.asm"

title:
    .db "2022 d6p2",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, input
    ld a, 14
    call solve
    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

#include "solve.asm"

input:
    #incbin "input"
    .db 0
