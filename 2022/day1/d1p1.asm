#include "../../header.asm"

title:
   .db "2022 d1p1",0

#include "../../util/debug/push_all.asm"

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    #define snack saferam1
    #define elf saferam1 + 4
    #define max_elf saferam1 + 8
    #define bcd_buf saferam1 + 12

    xor a ; max_elf = 0
    ld b, 4
    ld hl, max_elf
    call mem_set

    ld hl, input

    main_loop:
        push hl
        xor a ; elf = 0
        ld b, 4
        ld hl, elf
        call mem_set
        pop hl

        elf_acc_loop:
            ld de, snack
            ld b, 4
            call integer_parse ; elf += parse(line)
            inc hl
            push hl
            ld hl, elf
            ld de, snack
            ld b, 4
            call integer_add
            pop hl

            ld a, (hl) ; if next character is not numeric, break
            sub 48
            cp 10
            jp c, elf_acc_loop

        push hl
        ld hl, max_elf
        ld de, elf
        ld b, 4
        call integer_cmp ; check if elf > max_elf

        ld hl, elf
        ld de, max_elf
        ld b, 4
        call c, mem_copy
        pop hl

        ld a, (hl)
        cp 0
        jp nz, main_loop

    ; print ans
    ld hl, max_elf
    ld de, bcd_buf
    ld b, 4
    ld c, 5
    call bcd_make

    ld hl, bcd_buf
    ld b, 5
    call bcd_print

    bcall(_getkey) ; Pause
    ret

#include "../../util/print_hex.asm"

#include "../../util/integer/cmp.asm"
#include "../../util/integer/add.asm"
#include "../../util/integer/parse.asm"

#include "../../util/mem/set.asm"
#include "../../util/mem/copy.asm"

#include "../../util/bcd/make.asm"
#include "../../util/bcd/print.asm"

input:
    #incbin "input"
    .db 0
