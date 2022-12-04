#include "../../header.asm"

title:
    .db "2022 d4p1",0

#include "../../util/debug/push_all.asm"

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    #define r0 saferam1
    #define r1 saferam1 + 1
    #define r2 saferam1 + 2
    #define r3 saferam1 + 3

    ld hl, input
    ld de, 0 ; ans

    loop1:
        ld a, (hl)
        cp 0
        jp z, loop1_break

        push de ; save ans

        ld de, r0
        ld b, 4
        loop_parse_line:
            push bc ; save loop index
            push de ; save mem loc
            call parse_u8
            inc hl
            pop de ; get mem loc
            ld (de), a
            inc de
            pop bc ; get loop index
            djnz loop_parse_line

        ; r1 - r4 are now set to the 4 numbers

        pop de ; get ans
        ex de, hl

        ld ix, r0

        ld a, (r2)
        cp (ix)
        jp c, two_not_in_one ; Go to other cmp if r0 > r2

        ld a, (r1)
        cp (ix + 3)
        jp c, two_not_in_one ; Go to other cmp if r3 > r1

        inc hl ; add to ans since range 2 is inside range 1

        jp loop1_continue

        two_not_in_one:

        ld a, (r0)
        cp (ix + 2)
        jp c, loop1_continue ; continue if r0 < r2

        ld a, (r3)
        cp (ix + 1)
        jp c, loop1_continue ; continue if r3 < r1

        inc hl ; add to ans since range 1 is inside range 2

        loop1_continue:
        ex de, hl
        jp loop1
    loop1_break:

    ex de, hl
    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

#include "../../util/parse_u8.asm"

input:
    #incbin "input"
    .db 0
