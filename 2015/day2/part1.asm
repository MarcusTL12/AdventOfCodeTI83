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
    call bcd_mem

    ld hl, output
    ld b, 5
    call print_bcd

    bcall(_getkey) ; Pause
    ret

; #include "../../util/parse_u8.asm"
; #include "../../util/print_str_len.asm"
#include "../../util/print_bcd.asm"
#include "../../util/bcd_mem.asm"

input:
    .dw bb40h,e64dh

output:
    .db 0,0,0,0,0
