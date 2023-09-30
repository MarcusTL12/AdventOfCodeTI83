#include "../header.asm"

title:
    .db "test qsort",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, main
    bcall(_disphl)
    bcall(_newline)
    bcall(_getkey) ; Pause

    ld hl, test_data
    bcall(_puts)
    bcall(_newline)

    ld a, 2
    ld hl, test_data
    ld de, 5
    ld bc, test_cmp
    call qsort

    ld hl, test_data
    bcall(_puts)
    bcall(_newline)

    bcall(_getkey) ; Pause
    ret

; input:
;     hl: pointer to element a
;     de: pointer to element b
;     compares a - b
;     output: zero flag set if equal, carry flag set if b > a
;     expected to destroy all registers
test_cmp:
    ld c, (hl)
    inc hl
    ld b, (hl)
    ex de, hl
    ld e, (hl)
    inc hl
    ld d, (hl)
    push bc
    pop hl
    bjump(_cphlde)

.fill 16

test_data:
    .db "yrokpstylc",0

.fill 16

#include "../util/qsort.asm"
