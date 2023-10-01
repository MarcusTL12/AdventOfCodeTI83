#include "../../header.asm"

title:
   .db "2019 d3p1",0

#include "add_hl_a.asm"

; constants
#define N 3
#define BCD_N 4

; variables
#define x saferam1
#define y x + N
#define buf y + N
#define dist buf + N
#define mindist dist + N
#define xy_ptr mindist + N
#define hv_ptr xy_ptr + 2

#define bcd_buf saferam3

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, main
    bcall(_disphl)
    bcall(_newline)
    bcall(_getkey) ; Pause

    ; Set coords to 0
    ld hl, x
    xor a
    ld b, 2 * N
    call mem_set

    ; init hv lines
    ld hl, 0
    ld (h_lines), hl
    ld (v_lines), hl
    ld hl, h_lines + 4
    ld (h_lines + 2), hl
    ld hl, v_lines + 4
    ld (v_lines + 2), hl

    ld hl, input

    loop1:
        call parse_dir
        inc hl

        ld (xy_ptr), de
        ld (hv_ptr), bc

        push af ; {0}
        push hl ; {1}

        ; write current coord to first component
        ld h, b
        ld l, c
        inc hl
        inc hl
        ld e, (hl)
        inc hl
        ld d, (hl)
        ; Now de points to next free space in hv lines

        ; copy from xy coord to hv lines
        ld hl, (xy_ptr)
        ld bc, N
        ldir

        ld hl, integer_add_de
        jr nc, pos_dir
        ld hl, integer_sub_de
        pos_dir:
        ld (add_call + 1), hl

        pop hl ; {1}

        call parse_u16 ; de is now number from inp

        push hl ; {1}

        ld hl, (xy_ptr)
        ld b, N
        add_call:
        call 0

        ; write next coord to second component
        ld hl, (hv_ptr)
        inc hl
        inc hl
        ld e, (hl)
        inc hl
        ld d, (hl)
        ld a, N
        ex de, hl
        add_hl_a
        ex de, hl
        ; Now de points to next free space in hv lines

        ; copy from xy coord to hv lines
        ld hl, (xy_ptr)
        ld bc, N
        ldir

        pop hl ; {1}
        pop af ; {0}

        ; If carry flag (negative), swap first and second component
        jr nc, not_neg
        push hl ; {1}

        ld hl, (hv_ptr)
        inc hl
        inc hl
        ld e, (hl)
        inc hl
        ld d, (hl)
        ld a, N
        ex de, hl
        add_hl_a
        ex de, hl

        ld h, d
        ld l, e
        inc hl
        inc hl

        ld b, N
        call mem_swap

        pop hl ; {1}
        not_neg:

        ; Increment segment count
        ld hl, (hv_ptr)
        ld e, (hl)
        inc hl
        ld d, (hl)
        inc de
        ld (hl), d
        dec hl
        ld (hl), e

        pop hl ; {0}
        ld a, '\n'
        cp (hl)
        inc hl
        jp nz, loop1

    bcall(_getkey) ; Pause
    ret

; input:
;   hl: pointer to input string
; output:
;   de: pointer to x or y
;   bc: pointer to h_lines or v_lines
;   carryflag set if negative dir
parse_dir:
    ld a, (hl)
    ld de, x
    ld bc, h_lines

    cp 'L'
    scf
    ret z

    cp 'R'
    scf
    ccf
    ret z

    ld de, y
    ld bc, v_lines

    cp 'D'
    scf
    ret z

    ; Assume that it is 'U' at this point

    ccf
    ret

#include "../../util/integer/parse.asm"
#include "../../util/integer/cmp.asm"
#include "../../util/integer/cmp_a.asm"
#include "../../util/integer/inc.asm"
#include "../../util/integer/dec.asm"
#include "../../util/integer/add_de.asm"
#include "../../util/integer/sub_de.asm"

#include "../../util/bcd/make.asm"
#include "../../util/bcd/print.asm"

#include "../../util/mem/set.asm"
#include "../../util/mem/swap.asm"

#include "../../util/parse_u16.asm"

; Memory to store the line segments. Number of segments given by first two
; bytes. Pointer to next free spot given in the next two bytes.
; Each line segment is given by the starting coord then the ending coord
; as N byte integers.
h_lines:
    .fill 2 * 2 + 5 * N * 2
v_lines:
    .fill 2 * 2 + 5 * N * 2

input:
    #incbin "ex1.txt"
    .db 0
