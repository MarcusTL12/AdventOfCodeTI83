#include "../../header.asm"

title:
   .db "2025 d1p2",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ; For debugging:
    ld hl, actual_beginning
    bcall(_disphl)
    bcall(_newline)
    bcall(_getkey) ; Pause

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

        pop af ; restore equal to 'L'
        push hl

        ; bc = de to keep loop variable in bc
        ld b, d
        ld c, e

        jr nz, turn_cw ; if 'R', skip negation

        turn_ccw:
        ld a, (dial)
        or a
        jr nz, turn_ccw_not0
        ld a, 100
        turn_ccw_not0:
        dec a
        ld (dial), a
        jr nz, turn_ccw_not0_2
        ld hl, (ans)
        inc hl
        ld (ans), hl
        turn_ccw_not0_2:

        ; ==== loop logic ====
        xor a
        dec bc
        or b
        or c
        jr nz, turn_cw
        ; ==== loop logic ====
        jp loop_end

        turn_cw:
        ld a, (dial)
        inc a
        cp 100
        jr nz, turn_cw_not100
        ld hl, (ans)
        inc hl
        ld (ans), hl
        xor a
        turn_cw_not100:
        ld (dial), a

        ; ==== loop logic ====
        xor a
        dec bc
        or b
        or c
        jr nz, turn_cw
        ; ==== loop logic ====

        loop_end:
        pop hl
        xor a
        cp (hl)
        jp nz, line_loop

    ld hl, (ans)
    bcall(_disphl) ; print(hl)

    bcall(_getkey) ; Pause
    ret

#include "../../util/parse_u16.asm"

input:
    #incbin "aoc-input/2025/day1/ex1"
    .db 0
