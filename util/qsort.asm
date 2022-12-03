#ifndef qsort_inc
#define qsort_inc

#include "neg_hl.asm"
#include "rand_hl.asm"
#include "mul_a_hl.asm"
#include "mem/swap.asm"

#define cmp_func saferam1
#define array_base saferam1 + 2
#define elsize saferam1 + 4

; quicksort (unstable, random)
; input
; hl: pointer to start of array
; de: length of array (n elements)
; b: size of element
; saferam[0:1]: function pointer to comparison function:
;   input:
;   hl: pointer to element a
;   de: pointer to element b
;   compares a - b
;   output: zero flag set if equal, sign flag set if b > a
; destroys all registers
; and saferam[2] for size of element
qsort:
    ld (elsize), b
    ld (array_base), hl
    ld hl, 0
    dec de
    ; implicit jump to qsort_req

; quicksort internal recursive routine
; input
; hl: low index
; de: high index
qsort_rec:
    bcall(_cphlde)
    ret nc

    push hl
    push de

    call qsort_partition ; do partition
    push hl
    pop bc ; bc = p

    pop de
    pop hl

    ; bc is now index of the pivot element

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
    push hl
    push de

    neg hl
    add hl, de
    inc hl ; hl = de - hl, length of array
    ex de, hl
    call rand_hl ; chose pivot randomly
    push hl
    pop bc

    pop de
    pop hl

    ; bc is now index of pivot

    ; swap pivot with last element

    ret

; utility to swap elements
; input:
;   hl: index a
;   de: index b
qsort_swap:
    ld a, (elsize)
    call mul_a_hl
    ex de, hl
    ld a, (elsize)
    call mul_a_hl

    ; now indices are scaled with elsize

    ld bc, (array_base)
    add hl, bc
    ex de, hl
    add hl, bc

    ; hl, de point to memory locations
    ld b, (elsize)
    jp mem_swap ; tail call

#endif
