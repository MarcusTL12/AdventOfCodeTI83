#include "../../header.asm"

title:
    .db "2022 d5p2",0

#include "../../util/add_hl_a.asm"

; Need 56 * 9 = 504 bytes of stack ram
; saferam2 has 531 bytes
#define stacks saferam2
#define stack_cap 56

#define nstacks saferam1
#define move_amt saferam1 + 1
#define move_from saferam1 + 2
#define move_to saferam1 + 3
#define stack_sizes saferam1 + 4

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, input
    ld b, 0
    loop_find_nstacks:
        inc b
        ld a, (hl)
        inc hl
        cp '\n'
        jp nz, loop_find_nstacks ; count until end of line

    ; b is now length of line (including newline), must div by 4
    sra b
    sra b
    ld a, b
    ld (nstacks), a ; save nstacks

    ld hl, stack_sizes
    xor a
    call mem_set ; Set init stack sizes to zero

    ld ix, stack_sizes
    ld hl, input
    inc hl
    loop_init_stacks:
        ld a, (hl)
        cp '1'
        jp z, loop_init_stacks_break

        ld a, (nstacks)
        ld b, a
        ld c, 0 ; stack index
        loop_parse_stack_line:
            ld a, (hl)
            cp ' '
            jp z, parse_stack_line_skip ; check if empty

            ; push to stack
            ex de, hl

            ld h, stack_cap
            ld l, c
            push de
            push bc
            bcall(_htimesl)
            ld de, stacks
            add hl, de
            pop bc
            pop de
            ; hl now points to bottom of stack

            ld a, c
            ld (parse_stack_line_ix_offset1 + 2), a
            ld (parse_stack_line_ix_offset2 + 2), a
            parse_stack_line_ix_offset1:
            ld a, (ix) ; placeholder. offset set above at runtime
            parse_stack_line_ix_offset2:
            inc (ix) ; placeholder. offset set above at runtime

            ; a is now current stack size, and stacksize increased

            add_hl_a ; hl now points to empty slot on top of stack
            ld a, (de)
            ld (hl), a ; load element into stack

            ex de, hl

            parse_stack_line_skip:
            ld a, 4
            add_hl_a
            inc c
            djnz loop_parse_stack_line
        jp loop_init_stacks
    loop_init_stacks_break:

    ld a, (nstacks)
    add a, a
    add a, a
    add_hl_a
    ; now hl points to beginning of move section in input

    ; but first we have to reverse the stacks
    push hl ; keep next input section for later

    ld a, (nstacks)
    ld b, a
    ld c, 0
    loop_reverse_stacks:
        ld h, stack_cap
        ld l, c
        push de
        push bc
        bcall(_htimesl)
        ld de, stacks
        add hl, de
        pop bc
        pop de
        ; hl now points to bottom of stack

        push bc
        ld a, c
        ld (reverse_stacks_ix_offset1 + 2), a
        reverse_stacks_ix_offset1:
        ld b, (ix) ; offset set at runtime above
        ; now b is length of current stack

        call mem_reverse
        pop bc

        inc c
        djnz loop_reverse_stacks

    pop hl ; get next input section

    ; now stacks should be right order

    loop_crane:
        ld a, (hl)
        cp 0
        jp z, loop_crane_break

        ld a, 5
        add_hl_a
        call parse_u8
        ld (move_amt), a

        ld a, 6
        add_hl_a
        call parse_u8
        dec a
        ld (move_from), a

        ld a, 4
        add_hl_a
        call parse_u8
        dec a
        ld (move_to), a

        inc hl
        push hl ; save start of next line

        ld l, a
        ld h, stack_cap
        bcall(_htimesl)
        ld de, stacks
        add hl, de
        ; hl now points to bottom of destination stack

        ld a, (move_to)
        ld (crane_ix_offset1 + 2), a
        ld (crane_ix_offset4 + 2), a
        ld (crane_ix_offset4 + 5), a
        crane_ix_offset1:
        ld a, (ix) ; offset set above
        add_hl_a
        ; hl now points to empty element on top of destination stack

        push hl ; save destination stack location

        ld a, (move_from)
        ld l, a
        ld h, stack_cap
        bcall(_htimesl)
        ld de, stacks
        add hl, de
        ; hl now points to bottom of source stack

        ld a, (move_from)
        ld (crane_ix_offset2 + 2), a
        ld (crane_ix_offset3 + 2), a
        ld (crane_ix_offset3 + 5), a
        crane_ix_offset2:
        ld a, (ix) ; offset set above
        add_hl_a
        ; hl now points to empty element on top of source stack

        pop de ; get destination stack location

        ; hl now has source, and de destination

        ld a, (move_amt)
        ld b, a ; so don't have to load from mem twice
        neg
        crane_ix_offset3: ; subtract from source stack
        add a, (ix)
        ld (ix), a

        ld a, b
        crane_ix_offset4: ; add to dest stack
        add a, (ix) ; offset set above
        ld (ix), a

        ; now stack sizes have been updated

        ; move stack elements
        ld a, (move_amt)
        ld c, a
        ld b, 0
        or a ; clear carry flag
        sbc hl, bc ; hl now points to bottom of to-be-moved stack
        ldir

        pop hl ; get start of next line
        jp loop_crane
    loop_crane_break:

    ; now stacks have been moved around

    ld hl, stacks
    ld de, stack_sizes
    ld a, (nstacks)
    ld b, a
    loop_print_ans:
        push hl

        ld a, (de)
        dec a
        add_hl_a
        ld a, (hl)
        push_all
        bcall(_putc)
        pop_all

        pop hl
        ld a, stack_cap
        add_hl_a
        inc de
        djnz loop_print_ans

    bcall(_getkey) ; Pause
    ret

#include "../../util/mem/set.asm"
#include "../../util/mem/reverse.asm"

#include "../../util/parse_u8.asm"

input:
    #incbin "input"
    .db 0
