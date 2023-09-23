#include "../../header.asm"

title:
   .db "2019 d1p2",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ; constants
    #define N 3
    #define BCD_N 4

    ; variables
    #define x           saferam1
    #define ans         x           + N
    #define bcd_buf     ans         + N
    #define buf         bcd_buf     + BCD_N

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

        jp loop2_start

        loop2:
            ld hl, ans
            ld de, x
            ld b, N
            call integer_add

        loop2_start:
            ld hl, x
            ld a, 3
            ld b, N
            call integer_divrem_a

            ld hl, x
            ld a, 2
            ld b, N
            call integer_sub_a

            ld hl, x
            ld b, N
            call integer_is_neg
            jp p, loop2

        pop hl ; get line pointer

        ld a, (hl)
        or a
        jp nz, loop1

    ld hl, ans
    ld de, bcd_buf
    ld b, N
    ld c, BCD_N
    call bcd_make

    ld hl, bcd_buf
    ld b, BCD_N
    call bcd_print
    bcall(_newline)

    bcall(_getkey) ; Pause
    ret


#include "../../util/integer/parse.asm"
#include "../../util/integer/divrem_a.asm"
#include "../../util/integer/sub_a.asm"
#include "../../util/integer/add.asm"
#include "../../util/integer/is_neg.asm"

#include "../../util/bcd/make.asm"
#include "../../util/bcd/print.asm"

#include "../../util/mem/set.asm"

input:
    #incbin "input.txt"
    .db 0
