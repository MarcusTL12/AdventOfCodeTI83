#ifndef qsort_inc
#define qsort_inc

#include "debug/push_all.asm"

#include "add_hl_a.asm"
#include "mul_a_hl.asm"
#include "mul_h_l.asm"
#include "div_hl_c.asm"
#include "neg_hl.asm"
#include "rand_hl.asm"

#include "mem/swap.asm"

qsort_array_base:
    .dw 0
qsort_elsize:
    .db 0
qsort_part_length:
    .dw 0
qsort_pivot_address:
    .dw 0
qsort_tmp_pivot_index:
    .dw 0

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
;   expected to destroy all registers
; destroys all registers
qsort:
    ld (qsort_elsize), a ; save elsize
    ld (qsort_array_base), hl ; save array_base
    ld (qsort_partition_compare_call + 1), bc ; Set call instruction
    ld hl, 0 ; hl is now index to first element
    dec de ; de is now index to last element
    ; implicit jump to qsort_req

; quicksort internal recursive routine
; input
; hl: low index
; de: high index
qsort_rec:
    ; Check if interval has length <= 0
    ; Add one to avoid dealing with underflow
    push hl ; {0}
    push de ; {1}
    inc hl
    inc de
    bcall(_cphlde)
    pop de ; {1}
    pop hl ; {0}
    ret nc ; return if de <= hl

    push hl ; {0}
    push de ; {1}
    call qsort_partition ; do partition
    pop de ; {1}
    pop hl ; {0}

    push bc ; {0} save pivot for upper half
    push de ; {1} and upper index

    ld d, b
    ld e, c
    dec de ; de = p - 1
    call qsort_rec ; sort lower half

    pop de ; {1} get upper index
    pop hl ; {0} get pivot index
    inc hl ; hl = p + 1
    jp qsort_rec ; tail call sort upper half

; input
;   hl: low index
;   de: high index
; output
;   bc: Final index of pivot element
qsort_partition:
    push hl ; {0} i_l
    push de ; {1} i_h

    or a
    ex de, hl
    sbc hl, de
    inc hl ; hl = de - hl + 1, length of array part
    ld (qsort_part_length), hl ; save length

    ex de, hl ; de = length of part
    call rand_hl ; chose pivot randomly

    ; bc = hl
    ld b, h
    ld c, l

    pop de ; {1} i_h
    pop hl ; {0} i_l

    push hl ; {0} i_l
    push de ; {1} i_h

    ; Get address of pivot element
    add hl, bc
    ld a, (qsort_elsize)
    call mul_a_hl
    ld bc, (qsort_array_base)
    add hl, bc
    ld (qsort_pivot_address), hl

    pop de ; {1} i_h
    pop hl ; {0} i_l

    ; (pivot_address) is now set

    push hl ; {0} i_l
    push de ; {1} i_h

    ; Swap pivot element with last element
    ex de, hl
    ld a, (qsort_elsize)
    call mul_a_hl
    ld bc, (qsort_array_base)
    add hl, bc
    ld de, (qsort_pivot_address)
    ld (qsort_pivot_address), hl
    ld a, (qsort_elsize)
    ld b, a
    call mem_swap

    pop de ; {1} i_h
    pop hl ; {0} i_l

    push hl ; {0} i_l

    ; Now pivot is the last element

    ld a, (qsort_elsize)
    call mul_a_hl ; scale by elsize
    ld bc, (qsort_array_base)
    add hl, bc ; hl is now memory address of start

    ld d, h
    ld e, l ; tmp pivot = low index (as address)

    ; Register recap:
    ; hl: p_start
    ; de: p_tmp_pivot

    exx
    pop hl ; {0} i_l
    ld (qsort_tmp_pivot_index), hl
    exx

    ld bc, (qsort_part_length)
    dec bc ; looping over length - 1
    inc b
    qsort_partition_loop1: ; double 16-bit loop
        ld a, b ; swap b and c
        ld b, c
        ld c, a
        qsort_partition_loop2:
            push bc ; {0} looping index

            push hl ; {1} cur element
            push de ; {2} tmp pivot

            ; do compare between cur element (hl) and pivot
            ex de, hl ; make cur element be (de)
            ld hl, (qsort_pivot_address)
            qsort_partition_compare_call:
            call 0 ; address of compare function will be set at runtime
            ; Now carry flag will be set if cur element > pivot

            pop de ; {2} tmp pivot
            pop hl ; {1} cur element

            ; if cur element <= pivot:
            ;   do swap between cur element (hl) and tmp pivot (de)
            ;   and increment tmp pivot (de)

            jp c, qsort_partition_not_swap

            push hl ; {1}
            push de ; {2}
            ld a, (qsort_elsize)
            ld b, a
            call mem_swap ; do the swap
            pop de ; {2}
            pop hl ; {1}

            ex de, hl
            ld a, (qsort_elsize)
            add_hl_a ; increment tmp pivot to next element
            ex de, hl

            ; increment index of tmp pivot
            exx
            ld hl, (qsort_tmp_pivot_index)
            inc hl
            ld (qsort_tmp_pivot_index), hl
            exx

            qsort_partition_not_swap:

            ld a, (qsort_elsize)
            add_hl_a ; hl points to next element

            pop bc ; {0} looping index
            djnz qsort_partition_loop2
        ld a, b ; swap b and c, back
        ld b, c
        ld c, a
        djnz qsort_partition_loop1

    ld hl, (qsort_pivot_address)
    ld a, (qsort_elsize)
    ld b, a
    call mem_swap

    ; get index of pivot into bc
    ld bc, (qsort_tmp_pivot_index)

    ret

#endif
