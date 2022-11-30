#include "../../header.asm"

title:
   .db "2015 d2p2",0

main:
    bcall(_clrscrf)
    bcall(_homeup)

    #define int_a saferam1 + 2
    #define bcd_buf saferam1 + 6

    ld hl, input
    ld de, int_a

    ld b, 4
    loop1:
    ld a, (hl)
    ld (de), a
    inc hl
    inc de
    djnz loop1

    ld hl, int_a
    ld b, 4
    call print_hex
    bcall(_newline)

    ld hl, int_a
    ld de, bcd_buf
    ld b, 4
    ld c, 5
    call bcd_make

    ld hl, bcd_buf
    ld b, 5
    call print_hex

    bcall(_getkey) ; Pause
    ret

#include "../../util/bcd/make.asm"
; #include "../../util/bcd/print.asm"

#include "../../util/print_hex.asm"

input:
    .dw e64dh, bb40h

; input:
;     .db 0,0,0,0
