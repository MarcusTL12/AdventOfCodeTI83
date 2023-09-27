#include "../../header.asm"

title:
    .db "2022 d4p2",0

#include "../../util/add_hl_a.asm"

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
        push hl ; save start of next line

        push iy ; must be saved to not brick calculator
        ld ix, cmp_indices
        ld iy, r0
        ld b, 4
        loop_check_intersect:
            ld a, (ix)
            ld (ld_c_iy_p_a1 + 2), a ; set index of next load
            ld_c_iy_p_a1:
            ld c, (iy)

            ld a, (ix+1)
            ld (cp_iy_p_a1 + 2), a

            ld a, c
            cp_iy_p_a1:
            cp (iy)
            jp c, loop_check_intersect_continue

            ld a, (ix+2)
            ld (ld_c_iy_p_a2 + 2), a
            ld_c_iy_p_a2:
            ld c, (iy)

            ld a, (ix)
            ld (cp_iy_p_a2 + 2), a

            ld a, c
            cp_iy_p_a2:
            cp (iy)
            jp c, loop_check_intersect_continue

            inc de
            jp loop_check_intersect_break

            loop_check_intersect_continue:
            inc ix
            inc ix
            inc ix
            djnz loop_check_intersect
        loop_check_intersect_break:
        pop iy ; must be saved to not brick calculator

        pop hl ; get start of next line
        jp loop1
    loop1_break:

    ex de, hl
    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

#include "../../util/parse_u8.asm"

cmp_indices:
    .db 0,2,3 ; is 0 between 2 and 3
    .db 1,2,3 ; ...
    .db 2,0,1
    .db 3,0,1

input:
    #incbin "input"
    .db 0
