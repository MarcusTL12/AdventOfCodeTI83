#ifndef qsort_inc
#define qsort_inc

#include "debug/push_all.asm"

#include "add_a_hl.asm"
#include "mul_a_hl.asm"
#include "div_hl_c.asm"
#include "neg_hl.asm"
#include "rand_hl.asm"

#include "mem/swap.asm"

#define array_base      saferam1
#define elsize          saferam1 + 2
#define part_length     saferam1 + 3
#define pivot_address   saferam1 + 5

; quicksort (unstable, random)
; input
; a: size of element
; hl: pointer to start of array
; de: length of array (n elements)
; bc: function pointer to comparison function:
;   input:
;   hl: pointer to element a
;   de: pointer to element b
;   compares a - b
;   output: zero flag set if equal, carry flag set if b > a
;   expected to destroy all registers, but not saferam[0:6]
; destroys all registers
; and saferam[0:6]
qsort:
    ld (elsize), a ; save elsize
    ld (array_base), hl ; save array_base
    ld (qsort_partition_compare_call + 1), bc ; Set call instruction
    ld hl, 0 ; hl is now index to first element
    dec de ; de is now index to last element
    ; implicit jump to qsort_req

; quicksort internal recursive routine
; input
; hl: low index
; de: high index
qsort_rec:
    bcall(_cphlde)
    ret nc

    push_all
    ld hl, (array_base)
    bcall(_puts)
    bcall(_newline)
    bcall(_getkey)
    pop_all

    push hl
    push de
    call qsort_partition ; do partition
    pop de
    pop hl

    ld bc, (pivot_address)
    ; bc is now address of the pivot element

    push hl
    ld hl, (array_base)
    neg_hl
    add hl, bc ; hl is now index of pivot * elsize
    ld a, (elsize)
    ld c, a
    call div_hl_c
    push hl
    pop bc
    pop hl
    ; bc is now index of pivot

    push bc ; save pivot for upper half
    push de ; and upper index

    push bc
    pop de
    dec de ; de = p - 1
    call qsort_rec ; sort lower half

    pop de
    pop hl
    inc hl ; hl = p + 1
    jp qsort_rec ; tail call sort upper half

; input
;   hl: low index
;   de: high index
; output
;   hl: pointer to pivot
qsort_partition:
    jp qsort_partition_skip_rand

    push hl
    push de

    neg_hl
    add hl, de
    inc hl ; hl = de - hl, length of array
    ld (part_length), hl ; save length
    ex de, hl
    call rand_hl ; chose pivot randomly
    push hl
    pop bc

    pop de
    pop hl

    ; bc is now index of pivot

    push hl
    push de

    push bc
    pop hl
    call qsort_swap ; swap pivot with last element

    pop de
    pop hl

    qsort_partition_skip_rand: ; for debugging

    ; Now pivot is the last element

    push hl
    push de
    ld a, (elsize)
    ex de, hl
    call mul_a_hl
    ld bc, (array_base)
    add hl, bc
    ld (pivot_address), hl ; Save pivot address
    ex de, hl
    pop de
    pop hl

    ld a, (elsize)
    call mul_a_hl ; scale by elsize
    ld bc, (array_base)
    add hl, bc ; hl is now memory address of start

    push hl
    pop de ; tmp pivot = low index (as address)

    exx
    ld hl, 0 ; index of tmp pivot
    exx

    ld bc, (part_length)
    dec bc ; looping over length - 1
    inc b
    qsort_partition_loop1: ; double 16-bit loop
        ld a, b ; swap b and c
        ld b, c
        ld c, a
        qsort_partition_loop2:
            push bc ; save looping index

            push hl ; save cur element
            push de ; and tmp pivot

            ; do compare between cur element (hl) and pivot
            ex de, hl ; make cur element be (de)
            ld hl, (pivot_address)
            qsort_partition_compare_call:
            call 0 ; address of compare function will be set at runtime
            ; Now carry flag will be set if cur element > pivot

            pop de ; get tmp pivot
            pop hl ; and cur element

            ; if cur element <= pivot:
            ;   do swap between cur element (hl) and tmp pivot (de)
            ;   and increment tmp pivot (de)

            jp c, qsort_partition_not_swap

            push hl
            push de
            ld a, (elsize)
            ld b, a
            call mem_swap ; do the swap
            pop de
            pop hl

            ex de, hl
            ld a, (elsize)
            add_a_hl ; increment tmp pivot to next element
            ex de, hl

            exx
            inc hl ; increment index of tmp pivot
            exx

            qsort_partition_not_swap:

            ld a, (elsize)
            add_a_hl ; hl points to next element

            pop bc ; get looping index
            djnz qsort_partition_loop2
        ld a, b ; swap b and c, back
        ld b, c
        ld c, a
        djnz qsort_partition_loop1

    ld hl, (pivot_address)
    ld a, (elsize)
    ld b, a
    call mem_swap

    ret

; utility to swap elements
; input:
;   hl: index a
;   de: index b
qsort_swap:
    ld a, (elsize)
    push de
    call mul_a_hl ; scale a
    pop de

    ex de, hl
    ld a, (elsize)
    push de
    call mul_a_hl ; scale b
    pop de

    ; now indices are scaled with elsize (and swapped, does not matter)

    ld bc, (array_base)
    add hl, bc
    ex de, hl
    add hl, bc

    ; hl, de point to memory locations
    ld a, (elsize)
    ld b, a
    jp mem_swap ; tail call

#endif
