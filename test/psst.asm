#include "../header.asm"

title:
    .db "test psst",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    #define x saferam1

    ld a, 2
    ld hl, test_psst_mem
    call psst_init

    ld hl, 500
    ld (x), hl
    ld de, x
    ld hl, test_psst_mem
    call psst_insert

    ld hl, test_psst_mem
    call psst_len

    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

#include "../util/psst.asm"

test_psst_mem:
    .fill 50
