#include "../../header.asm"

title:
    .db "2022 d7p1",0

; 5 byte bcd buffer for printing
#define bcd_buf saferam1 + 6

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, input
    call parse_filesystem

    ex de, hl
    ld b, 4
    call print_hex

    ; push de

    ; ex de, hl
    ; ld de, bcd_buf
    ; ld b, 4
    ; ld c, 5
    ; call bcd_make

    ; pop hl
    ; ld b, 5
    ; call bcd_print

    bcall(_getkey) ; Pause
    ret

#include "parse_filesystem.asm"

#include "../../util/bcd/make.asm"
#include "../../util/bcd/print.asm"

#include "../../util/print_hex.asm"

input:
    #incbin "ex1"
    .db 0
