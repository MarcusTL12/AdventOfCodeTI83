#ifndef psst_inc
#define psst_inc

#include "add_hl_a.asm"
#include "mul_h_l.asm"
#include "mul_a_hl.asm"
#include "div_hl_2.asm"

#include "qsort.asm"

; Partially Sorted Search Table (psst)

; Internal structure offsets
#define psst_elsize 0
#define psst_num_sorted 1
#define psst_num_unsorted 3
#define psst_max_unsorted 4
#define psst_cmp_fn_ptr 5
#define psst_data 7

; TODO: test that it works properly when cap is 255
#define psst_init_unsorted_cap 8

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
;           expected to destroy all registers
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

; Hack to use space in linear search routine as
; tmp memory here
#define psst_binary_search_tmp_storage2 psst_linear_search_cmp_call + 1

; input:
;   hl: pointer to psst
;   de: pointer to reference element
; output:
;   hl: pointer to element if it's found
;   carry flag set if not found
psst_binary_search:
    push iy ; {0} Don't break OS

    push hl
    pop ix ; set to have easy access to struct parameters

    ; Chech if there are any elements
    push hl ; {1} psst
    push de ; {2} ref
    ld hl, 0
    ld e, (ix + psst_num_sorted)
    ld d, (ix + psst_num_sorted + 1)
    bcall(_cphlde)
    pop de ; {2} ref
    pop hl ; {1} psst

    jp z, psst_binary_search_not_found

    push de ; {1} save pointer to reference element

    ; Set call pointer
    ld e, (ix + psst_cmp_fn_ptr)
    ld d, (ix + psst_cmp_fn_ptr + 1)
    ld (psst_binary_search_cmp_call + 1), de

    ld a, psst_data
    add_hl_a ; hl now points to start of data
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

        ld (psst_binary_search_tmp_storage2), de
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
        ; de = i_mid - 1
        ld de, (psst_binary_search_tmp_storage)
        dec de

        ; Need to check if de overflowed. If so, return not found
        push hl
        ld hl, ffffh
        bcall(_cphlde)
        pop hl
        jp z, psst_binary_search_not_found

        jp psst_binary_search_post_shrink
        psst_binary_search_less:

        ; This is run if mid < ref
        ; de = i_hi
        ld de, (psst_binary_search_tmp_storage2)
        ; hl = i_mid + 1
        ld hl, (psst_binary_search_tmp_storage)
        inc hl

        psst_binary_search_post_shrink:

        ; Register recap:
        ; hl: i_lo (new)
        ; de: i_hi (new)
        ; bc: p_ref

        ; Check if i_lo >= i_hi; if not, return to top of loop
        ex de, hl
        bcall(_cphlde)
        ex de, hl
        jp nc, psst_binary_search_loop

    psst_binary_search_not_found:
    scf
    pop iy ; {0}
    ret

    psst_binary_search_found:
    ld hl, (psst_binary_search_tmp_storage)
    or a

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
    add_hl_a ; hl now points to start of data
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
    xor a
    cp b
    jp z, psst_linear_search_empty
    ld a, (ix + psst_elsize)

    psst_linear_search_loop:
        push bc
        push hl
        push de
        psst_linear_search_cmp_call:
        call 0
        pop de
        pop hl
        pop bc
        jp z, psst_linear_search_found

        ld a, (ix + psst_elsize)
        add_hl_a ; make hl point to next element
        djnz psst_linear_search_loop

    psst_linear_search_empty:
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
    add_hl_a
    ex de, hl ; de is now total length and hl is data

    ; Update length of sorted and unsorted block
    xor a
    ld (ix + psst_num_unsorted), a
    ld (ix + psst_num_sorted), e
    ld (ix + psst_num_sorted + 1), d

    ; update cap
    ex de, hl
    call psst_get_opt_cap
    ld (ix + psst_max_unsorted), a
    ex de, hl

    ld a, (ix + psst_elsize)

    ld c, (ix + psst_cmp_fn_ptr)
    ld b, (ix + psst_cmp_fn_ptr + 1)

    jp qsort ; tail call

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
    ld c, (ix + psst_elsize)
    ldir

    ; Load carry flag
    ld de, (psst_binary_search_tmp_storage)
    push de
    pop af

    ret nc ; return if not inserted

    push ix
    pop hl

    ; If inserted, increase count
    inc (ix + psst_num_unsorted)
    ; TODO: fix this. Need to add 256 to num sorted
    jp z, psst_sort ; tail call sort if overflow

    ; Check for soft overflow
    or a ; clear carry
    ld a, (ix + psst_max_unsorted)
    sbc a, (ix + psst_num_unsorted)
    jp z, psst_sort ; tail call sort if overflow

    ret

; input:
;   hl: pointer to psst
; output:
;   hl: number of elements in psst
; time: 7 * 4 + 6 * 3 + 4 + 20 = 70
; destroys:
;   de, af
psst_len:
    inc hl                  ; 6
    ld e, (hl)              ; 7
    inc hl                  ; 6
    ld d, (hl)              ; 7
    inc hl                  ; 6
    ld a, (hl)              ; 7
    ex de, hl               ; 4
    add_hl_a                ; 20
    ret

; input:
;   hl: length of psst
; output:
;   a: new unsorted cap
; destroys:
;   nothing
psst_get_opt_cap:
    ; if h != 0; return max 255
    xor a
    cp h
    ld a, 255
    ret nz

    ld a, 16
    cp l
    ld a, 8
    ret nc

    ld a, 32
    cp l
    ld a, 16
    ret nc

    ld a, 128
    cp l
    ld a, 64
    ret nc

    ld a, 128
    ret


#endif
