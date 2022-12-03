#include "../header.asm"

title:
    .db "test",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, bitfield
    xor a
    ld b, 4
    call mem_set

    ld a, 18
    ld hl, bitfield
    call bitset_u8_set

    ld hl, bitfield
    ld b, 4
    call print_hex

    bcall(_getkey) ; Pause
    ret

#include "../util/bitset_u8.asm"

#include "../util/mem/set.asm"

#include "../util/print_hex.asm"

bitfield:
    .db 0,0,0,0
