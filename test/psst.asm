#include "../header.asm"

title:
    .db "test psst",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    

    bcall(_getkey) ; Pause
    ret

#include "../util/psst.asm"

test_data:
    .db "yrokpstylc",0
