#include "../../header.asm"

title:
   .db "2025 d1p1",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ; For debugging:
    ; ld hl, actual_beginning
    ; bcall(_disphl)
    ; bcall(_newline)
    ; bcall(_getkey) ; Pause

    #define ans saferam1
    #define dial saferam1 + 2

    actual_beginning:

    ; ans = 0
    xor a
    ld (ans), a
    ld (ans+1), a

    ; dial = 50
    ld a, 50
    ld (dial), a

    ld hl, input
    line_loop:
        ld a, (hl)
        inc hl
        cp 'L'
        push af ; save equal to 'L' flag

        call parse_u16 ; de now contains number
        inc hl ; point to next line (or null terminator)

        ex de, hl
        ld c, 100
        call div_hl_c ; a now contains modulated number
        ex de, hl

        ld b, a
        pop af ; restore equal to 'L'
        ld a, b
        jr nz, turn_dial ; if 'R', skip negation

        ; a = 100 - a
        ld b, a
        ld a, 100
        sub b

        turn_dial:
        ld b, a
        ld a, (dial)
        add a, b
        ld d, a
        ld e, 100
        call div_d_e
        ld (dial), a

        ; set zero flag if a == 0
        cp 0

        jr nz, skip_tally ; if a != 0, do not increment ans
        ex de, hl
        ld hl, (ans)
        inc hl
        ld (ans), hl
        ex de, hl
        skip_tally:

        xor a
        cp (hl)
        jp nz, line_loop

    ld hl, (ans)
    bcall(_disphl) ; print(hl)

    bcall(_getkey) ; Pause
    ret

#include "../../util/parse_u16.asm"
#include "../../util/div_hl_c.asm"
#include "../../util/div_d_e.asm"

input:
    #incbin "aoc-input/2025/day1/input"
    .db 0
