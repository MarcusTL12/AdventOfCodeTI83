#include "../header.asm"

title:
    .db "test psst",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld a, 2
    ld hl, test_psst_mem

    bcall(_getkey) ; Pause
    ret

#include "../util/psst.asm"

test_psst_mem:
    .fill 50

test_data:
    .db "yrokpstylc",0
