#include "../../header.asm"

title:
   .db "2019 d1p1",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ; constants
    #define N 3
    #define M 4

    ; variables
    #define x           saferam1
    #define ans         x           + N
    #define bcd_buf     ans         + N

    ld hl, ans
    ld b, N
    xor a
    call mem_set

    ld hl, input
    loop1:
        ld de, x
        ld b, N
        call integer_parse
        inc hl ; hl now points to next line

        push hl ; save line pointer

        ld hl, x
        ld a, 3
        ld b, N
        call integer_divrem_a

        ld hl, x
        ld a, 2
        ld b, N
        call integer_sub_a

        ld hl, ans
        ld de, x
        ld b, N
        call integer_add

        pop hl; get line pointer

        ld a, (hl)
        or a
        jp nz, loop1

    ld hl, ans
    ld de, bcd_buf
    ld b, N
    ld c, M
    call bcd_make

    ld hl, bcd_buf
    ld b, M
    call bcd_print
    bcall(_newline)

    bcall(_getkey) ; Pause
    ret


#include "../../util/integer/parse.asm"
#include "../../util/integer/divrem_a.asm"
#include "../../util/integer/sub_a.asm"
#include "../../util/integer/add.asm"

#include "../../util/bcd/make.asm"
#include "../../util/bcd/print.asm"

#include "../../util/mem/set.asm"

input:
    #incbin "input.txt"
    .db 0
