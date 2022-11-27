#include "../../header.asm"

title:
   .db "2015 d2p1",0

main:
    bcall(_clrscrf)
    bcall(_homeup)

    ld a, 44
    daa
    ld l, a
    ld h, 0
    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

; #include "../../util/parse_u8.asm"
; #include "../../util/print_str_len.asm"
#include "../../util/print_bcd.asm"
#include "../../util/u32/bcd_u32.asm"

input:
    .dw 12609
    .db 89
