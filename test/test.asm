#include "../header.asm"

title:
    .db "test",0

#include "../util/neg_hl.asm"

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld de, 1000
    call rand_hl

    push hl
    bcall(_disphl)
    bcall(_newline)
    pop hl

    neg_hl
    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

#include "../util/rand_hl.asm"
