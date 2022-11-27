#include "../../header.asm"

title:
   .db "2015 d2p1",0

main:
    bcall(_clrscrf)
    bcall(_homeup)

    ld hl, input
    ld b, 4
    call print_bcd

    bcall(_getkey) ; Pause
    ret

; #include "../../util/parse_u8.asm"
; #include "../../util/print_str_len.asm"
#include "../../util/print_bcd.asm"
; #include "../../util/u32/hex_dehl.asm"

input:
    .db 38,89,65,49
