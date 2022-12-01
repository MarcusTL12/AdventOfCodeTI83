#include "../../header.asm"

title:
   .db "2022 d1p2",0

; #include "../../util/add_a_hl.asm"

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, input
    ld de, saferam1
    ld b, 4
    call integer_parse

    ld hl, saferam1
    ld b, 4
    call print_hex

    bcall(_getkey) ; Pause
    ret

#include "../../util/integer/parse.asm"

#include "../../util/print_hex.asm"

input:
    .db "314159565",10
    .db 0
