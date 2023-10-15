#include "../header.asm"

title:
    .db "test",0

#define x saferam1
#define y x + 4
#define ans y + 6
#define buf ans + 10
#define bcdbuf buf + 6

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

    ld hl, x_const
    ld de, x
    ld bc, 4
    ldir

    ld hl, y_const
    ld de, y
    ld bc, 6
    ldir

    ld hl, ans
    ld a, 0
    ld b, 10
    call mem_set

    push iy
    ld hl, y
    ld de, x
    ld b, 6
    ld c, 4
    ld ix, ans
    ld iy, buf
    call integer_mul
    pop iy

    ld hl, ans
    ld de, bcdbuf
    ld b, 10
    ld c, 13
    call bcd_make

    ld hl, bcdbuf
    ld b, 13
    call bcd_print

    bcall(_getkey) ; Pause
    ret

x_const:
    .dw 5e93h,e58ah

y_const:
    .dw 2879h,9ebah,f711h

#include "../util/bcd/make.asm"
#include "../util/bcd/print.asm"
#include "../util/integer/mul.asm"

#include "../util/mem/set.asm"
