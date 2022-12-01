#include "../../header.asm"

title:
   .db "2022 d1p2",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    #define snack saferam1
    #define elf saferam1 + 3
    #define max_elves saferam1 + 6
    #define bcd_buf saferam1 + 6 + 3 * 3

    xor a ; max_elf = 0
    ld b, 3 * 3
    ld hl, max_elves
    call mem_set

    ld hl, input

    main_loop:
        push hl
        xor a ; elf = 0
        ld b, 3
        ld hl, elf
        call mem_set
        pop hl

        elf_acc_loop:
            ld de, snack
            ld b, 3
            call integer_parse ; elf += parse(line)
            inc hl ; skip newline
            push hl
            ld hl, elf
            ld de, snack
            ld b, 3
            call integer_add
            pop hl

            ld a, (hl) ; if next character is not numeric, break
            sub 48
            cp 10
            jp c, elf_acc_loop

        inc hl ; skip extra newline
        push hl ; keep input-pointer

        ld b, 3 ; number of max elves
        ld hl, max_elves

        elf_sort_loop:
            push bc

            push hl
            ld de, elf
            ld b, 3
            call integer_cmp ; check if elf > max_elf

            ld hl, elf ; Swap if larger
            pop de
            push de
            ld b, 3
            call c, mem_swap
            pop hl

            inc hl ; Increment to next elf
            inc hl
            inc hl

            pop bc
            djnz elf_sort_loop

        pop hl ; retrieve input pointer

        ld a, (hl)
        cp 0
        jp nz, main_loop

    ; sum max elves
    ld hl, max_elves
    ld de, max_elves + 3
    ld b, 3
    call integer_add

    ld hl, max_elves
    ld de, max_elves + 6
    ld b, 3
    call integer_add

    ; print ans
    ld hl, max_elves
    ld de, bcd_buf
    ld b, 3
    ld c, 4
    call bcd_make

    ld hl, bcd_buf
    ld b, 3
    call bcd_print

    bcall(_getkey) ; Pause
    ret

#include "../../util/print_hex.asm"

#include "../../util/integer/cmp.asm"
#include "../../util/integer/add.asm"
#include "../../util/integer/parse.asm"

#include "../../util/mem/set.asm"
#include "../../util/mem/swap.asm"

#include "../../util/bcd/make.asm"
#include "../../util/bcd/print.asm"

input:
    #incbin "input"
    .db 0
