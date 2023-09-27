
#include "../../util/add_hl_a.asm"

#include "../../util/mem/set.asm"

#define n_diff saferam1
#define cur_n_diff saferam1 + 1
#define n_processed saferam1 + 2
#define counts saferam1 + 4

; input:
;   hl: pointer to start of input
;   a: number of different characters
; output:
;   hl: answer
solve:
    ld (n_diff), a
    push hl
    xor a
    ld (cur_n_diff), a
    ld hl, counts
    ld b, 26
    call mem_set ; start all counts at zero
    pop hl

    ld ix, counts

    push hl
    ld a, (n_diff)
    ld b, a
    loop_init:
        ld a, (hl)
        inc hl
        sub 'a'

        ld (init_ix_offset1 + 2), a
        ld (init_ix_offset1 + 5), a

        init_ix_offset1:
        ld c, (ix) ; offsets set at runtime
        inc (ix)

        xor a
        cp c
        jp nz, init_not_inc ; already have this character,
                            ; do not increase count

        ex de, hl
        ld hl, cur_n_diff
        inc (hl)
        ex de, hl

        init_not_inc:

        djnz loop_init
    pop hl

    ; Now we have the counts for the first n_diff characters
    ; Can start sliding window at input + 1

    push hl
    ld a, (n_diff)
    ld l, a
    ld h, 0
    ld (n_processed), hl ; start with n_diff processed chars
    pop hl

    push hl
    ld a, (n_diff)
    add_hl_a
    ex de, hl ; de now points to next char to be processed
    pop hl ; and hl points to char to be dropped from sliding window
    loop_solve:
        ld a, (hl)
        push hl
        sub 'a'

        ld (solve_ix_offset1 + 2), a
        ld (solve_ix_offset1 + 5), a

        solve_ix_offset1:
        dec (ix) ; decrease count of dropped char
        ld c, (ix)

        xor a
        cp c
        jp nz, solve_not_dec    ; and decrease number of different
                                ; if that was the last one of that type

        
        ld hl, cur_n_diff
        dec (hl)

        solve_not_dec:

        ld a, (de)
        sub 'a'

        ld (solve_ix_offset2 + 2), a
        ld (solve_ix_offset2 + 5), a

        solve_ix_offset2:
        ld c, (ix)
        inc (ix) ; increase count of new char

        xor a
        cp c
        jp nz, solve_not_inc    ; and increase number of different
                                ; if did not have that one before

        ld hl, cur_n_diff
        inc (hl)

        solve_not_inc:

        ld hl, (n_processed)
        inc hl
        ld (n_processed), hl

        ld a, (n_diff)
        ld hl, cur_n_diff
        cp (hl)

        pop hl

        jp z, loop_solve_break ; number of different ones is correct!

        inc hl
        inc de
        jp loop_solve
    loop_solve_break:

    ld hl, (n_processed)

    ret
