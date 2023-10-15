#include "../header.asm"

title:
    .db "test",0

#define x saferam1
#define bcdbuf x + 5

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

    ld hl, x
    ld (hl), 4eh
    inc hl
    ld (hl), 28h
    inc hl
    ld (hl), 28h
    inc hl
    ld (hl), bfh

    ld hl, x
    ld a, 209
    ld b, 4
    call integer_mul_a
    ld (x + 4), a

    ld hl, x
    ld de, bcdbuf
    ld b, 5
    ld c, 13
    call bcd_make

    ld hl, bcdbuf
    ld b, 13
    call bcd_print

    bcall(_getkey) ; Pause
    ret

#include "../util/bcd/make.asm"
#include "../util/bcd/print.asm"
#include "../util/integer/mul_a.asm"

#include "../util/mem/set.asm"
