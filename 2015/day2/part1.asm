#include "../../header.asm"

title:
   .db "2015 d2p1",0

; #include "../../util/parse_u8.asm"
#include "../../util/print_str_len.asm"
#include "../../util/u32/hex_dehl.asm"

main:
    bcall(_clrscrf)
    bcall(_homeup)

    ld de, 31a7h
    ld hl, 82bfh
    call hex_dehl

    ld hl, saferam1
    ld b, 8
    call print_str_len

    bcall(_getkey) ; Pause
    ret

input:
    .db "9x253"
