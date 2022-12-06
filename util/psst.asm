#ifndef psst_inc
#define psst_inc

#include "add_a_hl.asm"
#include "mul_a_hl.asm"

; Partially Sorted Search Table (psst)

; Internal structure offsets
#define psst_elsize 0
#define psst_num_sorted 1
#define psst_num_unsorted 3
#define psst_max_unsorted 5
#define psst_cmp_fn_ptr 7
#define psst_data 9

#define psst_init_unsorted_cap 16

; Initializes the a psst. This is pretty inoptimal to be flexible,
; but it's only run once per psst, so it's fine.
; input:
;   a: element size
;   hl: pointer to psst
;   de: function pointer to comparison function:
;       input:
;           hl: pointer to element a
;           de: pointer to element b
;           compares a - b
;           output: zero flag set if equal, carry flag set if b > a
;           expected to destroy all registers, but not saferam1[0:6]
psst_init:
    push hl
    pop ix

    ld (ix + psst_elsize), a

    ld (ix + psst_num_sorted), 0
    ld (ix + psst_num_sorted + 1), 0

    ld (ix + psst_num_unsorted), 0
    ld (ix + psst_num_unsorted + 1), 0

    ld (ix + psst_max_unsorted), psst_init_unsorted_cap
    ld (ix + psst_max_unsorted + 1), 0

    ld (ix + psst_cmp_fn_ptr), e
    ld (ix + psst_cmp_fn_ptr + 1), d

    ret

psst_binary_search:
    ret

; input:
;   hl: pointer to psst
; output:
;   hl: pointer to element if it's found
psst_linear_search:
    push hl
    pop ix ; set to have easy access to struct parameters

    ld a, psst_data
    add_a_hl ; hl now points to start of data

    ld a, (ix + psst_elsize)
    ld e, (ix + psst_num_sorted)
    ld d, (ix + psst_num_sorted + 1)
    ex de, hl
    call mul_a_hl ; scale num sorted with elsize

    add hl, de ; hl now points to start of unsorted data

    ; TODO: load num unsorted into bc, and loop til found element.

    ret

psst_search:
    ret

psst_insert:
    ret

#endif
