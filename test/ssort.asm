#include "../header.asm"

title:
    .db "test ssort",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, test_data
    bcall(_puts)
    bcall(_newline)

    ld a, 2
    ld hl, test_data
    ld de, 5
    ld bc, test_cmp
    call ssort

    ld hl, test_data
    bcall(_puts)
    bcall(_newline)

    bcall(_getkey) ; Pause
    ret

test_cmp:
    ex de, hl
    inc de
    inc hl
    ld a, (de)
    ; ld b, (hl)
    ; cp b
    cp (hl)
    ret

#include "../util/ssort.asm"

test_data:
    .db "yrokpstylc",0
