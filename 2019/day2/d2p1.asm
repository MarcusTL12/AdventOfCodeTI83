#include "../../header.asm"

title:
   .db "2019 d2p1",0

#include "../../util/add_hl_a.asm"

; constants
#define N 3
#define BCD_N 4

#define intcode_pc  saferam1
#define mul_buf     intcode_pc  + 2
#define mul_ans     mul_buf     + N

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, input
    ld de, intcode

    loop_parse:
        ld b, N
        call integer_parse

        ex de, hl

        ld a, N
        add_hl_a

        ex de, hl

        ld a, '\n'
        cp (hl)
        jr nz, loop_parse

    ld hl, 0
    ld (intcode_pc), hl

    jp halt

    loop_run:
        ; Get pointer to next instruction
        ld hl, (intcode_pc)
        ld a, N
        call mul_a_hl
        ld de, intcode
        add hl, de

        ld a, 99
        cp (hl)
        jr z, halt

        ld a, 1
        cp (hl)
        jr z, not_add

        ld de, add_instruction
        not_add:
        ld de, mul_instruction
        ld (instruction_call + 1), de

        ld a, N
        add_hl_a
        push hl
        ld a, N
        call mul_a_hl
        pop de
        push hl
        ex de, hl

        ld a, N
        add_hl_a
        push hl
        ld a, N
        call mul_a_hl
        pop de
        push hl
        ex de, hl

        ld a, N
        add_hl_a
        push hl
        ld a, N
        call mul_a_hl
        pop de
        push hl
        ex de, hl

        pop bc
        pop de
        pop hl

        instruction_call:
        call 0

        ld hl, (intcode_pc)
        inc hl \ inc hl \ inc hl \ inc hl
        ld (intcode_pc), hl

        jr loop_run
    halt:

    bcall(_getkey) ; Pause
    ret

; Input:
;   hl: input a
;   de: input b
;   bc: ans location
add_instruction:
    push de ; {0}
    push bc ; {1}

    ; Copy a to ans
    ld d, b
    ld e, c
    ld bc, N
    ldir

    pop hl ; {1}
    pop de ; {0}
    ld b, N

    jp integer_add

mul_instruction:
    push bc ; {0}

    ld b, N
    ld c, b
    ld ix, mul_ans
    push iy
    ld iy, mul_buf
    call integer_mul
    pop iy

    pop de ; {0}
    ld hl, mul_ans
    ld bc, N
    ldir

    ret


#include "../../util/integer/parse.asm"
#include "../../util/integer/add.asm"
#include "../../util/integer/mul.asm"

; #include "../../util/bcd/make.asm"
; #include "../../util/bcd/print.asm"

; #include "../../util/mem/set.asm"

#include "../../util/mul_a_hl.asm"

intcode:
    .fill 120 * N

input:
    #incbin "ex1.txt"
    .db 0
