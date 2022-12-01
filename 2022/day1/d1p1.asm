#include "../../header.asm"

title:
   .db "2022 d1p1",0

; #include "../../util/add_a_hl.asm"

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, input
    call parse_u16
    ex de, hl
    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

#include "../../util/parse_u16.asm"

input:
    #incbin "ex1"
    .db 0
