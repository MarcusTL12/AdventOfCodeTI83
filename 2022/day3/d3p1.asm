#include "../../header.asm"

title:
    .db "2022 d3p1",0

#include "../../util/add_a_hl.asm"

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ; For 2 * 26 = 52 bits long. Takes 7 bytes
    #define charset saferam1

    ld hl, input
    ld de, 0 ; ans

    loop1:
        push hl
        xor a
        ld b, 7
        ld hl, charset
        call mem_set ; Zero out charset
        pop hl

        ld a, (hl)
        cp 0
        jp z, loop1_break ; Check if reached end of input
        push de ; Save ans
        push hl ; Save start of line

        ld b, 0
        inc hl
        loop_get_line_len: ; Search for end of line
            ld a, (hl)
            inc b
            inc hl
            cp '\n'
            jp nz, loop_get_line_len

        ; b now contains the line length

        ex de, hl
        pop hl ; Retrieve start of line
        push de ; and save start of next line

        push hl ; Save start of line

        srl b ; b = b / 2

        ld a, b
        add_a_hl ; point to compartment 2

        push bc ; save length of compartment

        loop_fill_set:
            push bc
            ld a, (hl) ; load next char
            call get_priority ; and turn into priority (0-51)
            inc hl
            push hl

            ; Insert into set
            ld hl, charset
            call bitset_u8_set

            pop hl
            pop bc
            djnz loop_fill_set

        pop bc ; Retrieve length of compartment
        pop hl ; Retrieve start of line

        loop_check_set:
            ld a, (hl) ; load next char
            call get_priority ; and turn into priority (0-51)
            inc hl

            ld c, a
            push bc ; Keep prio
            push hl

            ; Check if is in set
            ld hl, charset
            call bitset_u8_bit

            pop hl
            pop bc ; Get prio
            ld a, c
            jp nz, loop_check_set_break

            jp loop_check_set
        loop_check_set_break:

        pop hl ; Retrieve start of next line
        pop de ; Retrieve ans

        ex de, hl
        inc a
        add_a_hl
        ex de, hl

        jp loop1
    loop1_break:

    ex de, hl
    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

#include "priority.asm"

#include "../../util/mem/set.asm"

#include "../../util/bitset_u8.asm"

input:
    #incbin "input"
    .db 0
