#include "../header.asm"

title:
    .db "test",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld de, 1000
    call rand_hl

    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

#include "../util/rand_hl.asm"
