#include "../../header.asm"

title:
   .db "2015 d2p1",0

main:
    bcall(_clrscrf)
    bcall(_homeup)

    ld hl, input
    ld de, output
    ld a, 4
    ld (saferam1), a
    inc a
    ld (saferam1 + 1), a
    call bcd_make

    ld hl, output
    ld b, 5
    call bcd_print
    bcall(_newline)

    bcall(_getkey) ; Pause
    ret

; #include "../../util/parse_u8.asm"
#include "../../util/bcd/print.asm"
#include "../../util/bcd/make.asm"

input:
    .dw 58957, 47936

output:
    .db 0,0,0,0,0
