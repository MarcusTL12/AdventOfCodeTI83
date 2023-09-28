#include "../../header.asm"

title:
    .db "2022 d7p1",0

; 5 byte bcd buffer for printing
#define int_buf saferam1 + 2
#define bcd_buf saferam1 + 6

#include "../../util/add_hl_a.asm"

#include "../../util/debug/push_all.asm"
; #include "../../util/print_str_len.asm"

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ; ld (saferam1 + 150), ix

    ld hl, heap
    call mul_h_l
    bcall(_newline)

    ld hl, input
    call parse_filesystem

    ex de, hl ; hl now points to root node

    ld de, 0
    ld (int_buf), de
    ld (int_buf + 2), de ; zero int_buf

    call sum_sub_n ; sum up all

    ld hl, int_buf
    ld de, bcd_buf
    ld b, 4
    ld c, 5
    call bcd_make

    ld hl, bcd_buf
    ld b, 5
    call bcd_print

    bcall(_getkey) ; Pause
    ret

#include "parse_filesystem.asm"

cmp_buf:
    ; 100000 in hex is 0001_86a0
    .dw 86a0h, 0001h

; recursively adds to 32 bit integer in int_buf
; input:
;   hl: pointer to dir node
;   cmp_buf: points to 32 bit integer to be less than or equal to
sum_sub_n:
    push_all
    push hl
    ld a, 'A'
    bcall(_putc)
    bcall(_newline)
    pop hl
    push hl
    call mul_h_l
    bcall(_newline)
    pop hl
    ld b, 8
    call print_hex
    bcall(_newline)
    bcall(_getkey)
    pop_all

    push hl
    ld de, cmp_buf
    call integer_cmp
    pop hl

    jp c, sum_sub_n_too_large ; skip this directory's size if too large

    push hl
    ld de, int_buf
    ld b, 4
    call integer_add ; add contribution from current dir
    pop hl

    sum_sub_n_too_large:

    push_all
    ld a, 'B'
    bcall(_putc)
    bcall(_newline)
    call mul_h_l
    bcall(_newline)
    bcall(_getkey)
    pop_all

    ; now loop through linked list of subdirs and call this routine recusively

    ld a, dir_subd
    add_hl_a ; hl now points to memory address of pointer to first subdirectory

    push_all
    ld a, 'b'
    bcall(_putc)
    bcall(_newline)
    ld b, 8
    call mul_h_l
    bcall(_newline)
    bcall(_getkey)
    pop_all

    ld e, (hl)
    inc hl
    ld d, (hl)
    ex de, hl ; hl now holds address of first subdirectory

    sum_sub_n_loop:
        push_all
        ld a, 'C'
        bcall(_putc)
        bcall(_newline)
        call mul_h_l
        bcall(_newline)
        bcall(_getkey)
        pop_all

        ; check if hl is null
        xor a
        cp h
        jp nz, sum_sub_n_not_null
        cp l
        jp z, sum_sub_n_loop_break ; is null, break loop

        sum_sub_n_not_null:

        push_all
        ld a, 'D'
        bcall(_putc)
        bcall(_newline)
        ld b, 8
        call print_hex
        bcall(_newline)
        bcall(_getkey)
        pop_all

        push hl
        call sum_sub_n ; recursive call
        pop hl

        ld a, dir_next
        add_hl_a
        ld e, (hl)
        inc hl
        ld d, (hl)
        ex de, hl

        jp sum_sub_n_loop
    sum_sub_n_loop_break:

    push_all
    ld a, 'R'
    bcall(_putc)
    bcall(_newline)
    bcall(_getkey)
    pop_all

    ret

#include "../../util/integer/add.asm"
#include "../../util/integer/cmp.asm"

#include "../../util/bcd/make.asm"
#include "../../util/bcd/print.asm"

#include "../../util/print_hex.asm"

input:
    #incbin "ex1"
    .db 0
