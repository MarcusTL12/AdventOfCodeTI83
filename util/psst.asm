#ifndef psst_inc
#define psst_inc

#include "add_a_hl.asm"
#include "mul_a_hl.asm"
#include "div_hl_2.asm"

; Temporarily using selection sort until quicksort works
#include "ssort.asm"

; Partially Sorted Search Table (psst)

; Internal structure offsets
#define psst_elsize 0
#define psst_num_sorted 1
#define psst_num_unsorted 3
#define psst_max_unsorted 4
#define psst_cmp_fn_ptr 5
#define psst_data 7

#define psst_init_unsorted_cap 4

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

    ld (ix + psst_max_unsorted), psst_init_unsorted_cap

    ld (ix + psst_cmp_fn_ptr), e
    ld (ix + psst_cmp_fn_ptr + 1), d

    ret

; input:
;   hl: pointer to psst
;   de: pointer to reference element
; output:
;   hl: pointer to element if it's found
;   carry flag set if not found
psst_binary_search:
    push iy ; {0} Dont brake OS
    push de ; {1} save pointer to reference element

    push hl
    pop ix ; set to have easy access to struct parameters

    ; Set call pointer
    ld e, (ix + psst_cmp_fn_ptr)
    ld d, (ix + psst_cmp_fn_ptr + 1)
    ld (psst_binary_search_cmp_call + 1), de

    ld a, psst_data
    add_a_hl ; hl now points to start of data
    push hl
    pop iy ; iy now points to start of data

    ld e, (ix + psst_num_sorted)
    ld d, (ix + psst_num_sorted + 1)
    dec de ; de now contains index of last sorted element

    ld hl, 0 ; index of first sorted element

    pop bc ; {1} get pointer to reference element

    ; Register recap:
    ; hl: index to low element  (i_lo)
    ; de: index to high element (i_hi)
    ; bc: pointer to reference element (p_ref)
    ; ix: pointer to psst
    ; iy: pointer to start of data (p_dat)

    psst_binary_search_loop:
        push bc ; {1} p_ref

        ld b, h
        ld c, l

        ; Find middle index
        push hl ; {2} i_lo
        push de ; {3} i_hi

        ex de, hl
        or a
        sbc hl, de ; hl = i_hi - i_lo
        div_hl_2 ; hl = (i_hi - i_lo) / 2

        add hl, bc ; hl = i_lo + (i_hi - i_lo) / 2 = i_mid

        pop de ; {3} i_hi
        pop bc ; {2} i_lo

        ; Register recap:
        ; hl: i_mid
        ; de: i_hi
        ; bc: i_lo

        ; Hack to use space in linear search routine as
        ; tmp memory here
        ld (psst_linear_search_cmp_call), de
        ld (psst_binary_search_tmp_storage), hl

        ; Now use i_mid to find pointer to middle element
        ld a, (ix + psst_elsize)
        call mul_a_hl
        push iy
        pop de
        add hl, de

        pop de ; {1} p_ref

        ; Register recap:
        ; hl: p_mid
        ; bc: i_lo
        ; de: p_ref

        push bc ; {1} i_lo
        push de ; {2} p_ref

        ; Compare with reference
        ; hl: a = p_mid
        ; de: b = p_ref
        psst_binary_search_cmp_call:
        call 0

        pop bc ; {2} p_ref
        pop hl ; {1} i_lo

        ; Now use compare information:
        ; If mid == ref (z flag set): return with position of found item
        ; If mid > ref (c flag not set): i_hi = i_mid
        ; If mid < ref (c flag set): i_lo = i_mid

        jp z, psst_binary_search_found
        jp c, psst_binary_search_less

        ; This is run if mid > ref
        ; hl = i_lo
        ; de = i_mid
        ld de, (psst_binary_search_tmp_storage)

        jp psst_binary_search_post_shrink
        psst_binary_search_less:

        ; This is run if mid < ref
        ; de = i_hi
        ld de, (psst_linear_search_cmp_call)
        ; hl = i_mid
        ld hl, (psst_binary_search_tmp_storage)

        psst_binary_search_post_shrink:

        ; Register recap:
        ; hl: i_lo (new)
        ; de: i_hi (new)
        ; bc: p_ref

        ; Check if i_lo == i_hi; if so, return not found
        bcall(_cphlde)
        jp z, psst_binary_search_not_found

        ; If we are here, i_lo < i_hi and we have not found
        ; the element, so jump back up and do another iteration

        jp psst_binary_search_loop

    psst_binary_search_found:
    ld hl, (psst_binary_search_tmp_storage)
    or a

    pop iy ; {0}
    ret

    psst_binary_search_not_found:
    scf
    pop iy ; {0}
    ret

psst_binary_search_tmp_storage:
    .dw 0

; input:
;   hl: pointer to psst
;   de: pointer to reference element
; output:
;   hl: pointer to element if it's found,
;       or to the next free space if not
;   carry flag set if not found
psst_linear_search:
    push de ; {1} save pointer to reference element

    push hl
    pop ix ; set to have easy access to struct parameters

    ; Set call pointer
    ld e, (ix + psst_cmp_fn_ptr)
    ld d, (ix + psst_cmp_fn_ptr + 1)
    ld (psst_linear_search_cmp_call + 1), de

    ld a, psst_data
    add_a_hl ; hl now points to start of data
    push hl ; {2} save start of data

    ld a, (ix + psst_elsize)
    ld e, (ix + psst_num_sorted)
    ld d, (ix + psst_num_sorted + 1)
    ex de, hl
    call mul_a_hl ; scale num sorted with elsize

    pop de ; {2} get start of data
    add hl, de ; hl now points to start of unsorted data

    pop de ; {1} get pointer to reference element

    ; load num unsorted into b, and loop til found element.
    ld b, (ix + psst_num_unsorted)
    ld a, (ix + psst_elsize)

    psst_linear_search_loop:
        push hl
        push de
        psst_linear_search_cmp_call:
        call 0
        pop de
        pop hl
        jp z, psst_linear_search_found

        add_a_hl ; make hl point to next element
        djnz psst_linear_search_loop

    scf ; did not find, set carry flag
    ret
;

    psst_linear_search_found:
    or a
    ret

; input:
;   hl: pointer to psst
;   de: pointer to reference element
; output:
;   hl: pointer to element if it's found,
;       or to the next free space if not
;   carry flag set if not found
psst_search:
    push hl
    push de
    call psst_binary_search
    jp nc, psst_search_binary_search_found
    pop de
    pop hl

    jp psst_linear_search ; tail call

    psst_search_binary_search_found:
    pop de
    pop de
    ret

; input:
;   hl: pointer to psst
psst_sort:
    push hl
    pop ix

    ld de, psst_data
    add hl, de ; make hl point to data

    ex de, hl

    ld l, (ix + psst_num_sorted)
    ld h, (ix + psst_num_sorted + 1)
    ld a, (ix + psst_num_unsorted)
    add_a_hl
    ex de, hl ; de is now total length and hl is data

    ld a, (ix + psst_elsize)

    jp ssort ; tail call (change to qsort)

; input:
;   hl: pointer to psst
;   de: pointer to element to insert
; Will look for element in psst.
; If it is found it is overwritten with the new element.
; If it is not found, a the new element is added to the end of the
; unsorted section. If the size of the unsorted section then becomes too
; large, the psst is sorted.
psst_insert:
    push hl ; {0} p_psst
    push de ; {1} p_el
    call psst_search

    ; Save carry flag for return
    push af
    pop de
    ld (psst_binary_search_tmp_storage), de

    pop de ; {1} p_el
    pop ix ; {0} p_psst

    ; Copy to hl
    ex de, hl
    ld b, 0
    ld c, (ix)
    ldir

    ; Load carry flag
    ld de, (psst_binary_search_tmp_storage)
    push de
    pop af

    ret nc ; return if not inserted

    ; If inserted, increase count
    inc (ix + psst_num_unsorted)
    jp z, psst_sort ; tail call sort if overflow

    ; Check for soft overflow
    or a ; clear carry
    ld a, (ix + psst_max_unsorted)
    sbc a, (ix + psst_num_unsorted)
    jp z, psst_sort ; tail call sort if overflow

    ret

#endif
