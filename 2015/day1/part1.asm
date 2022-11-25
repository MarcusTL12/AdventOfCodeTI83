#include "../../header.asm"

title:
   .db "2015 d1p1",0

#include "../../util/println.asm"

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl,Hello
    call println
    bcall(_getkey)
    ret

Hello:
    .db "Hei Day1, Part 1",0
