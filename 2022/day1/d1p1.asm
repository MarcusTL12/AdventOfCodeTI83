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

    ld hl, int_a
    ld de, int_b
    ld b, 4
    call integer_cmp

    push af
    pop hl
    ld h, 0
    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

; #include "../../util/parse_u16.asm"
#include "../../util/integer/cmp.asm"

int_a:
    .db 4dh, e7h, 40h, bbh

int_b:
    .db 4dh, e6h, 41h, bbh

; input:
;     #incbin "ex1"
;     .db 0
