#include "../../header.asm"

title:
   .db "2019 d3p1",0

#include "../../util/add_hl_a.asm"
#include "../../util/xor_hl_de.asm"

; constants
#define N 3
#define BCD_N 4

; variables
#define x           saferam1
#define y           x           + N
#define buf1        y           + N
#define buf2        buf1        + N
#define buf3        buf2        + N
#define dist        buf3        + N
#define mindist     dist        + N
#define xy_ptr      mindist     + N
#define hv_ptr      xy_ptr      + 2

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

        push de ; {2}

        ; copy from xy coord to hv lines
        ld hl, (xy_ptr)
        ld bc, N
        ldir

        ; Do xor magic to get the other coord
        ; (x_ptr ^ y_ptr) ^ xy_ptr = yx_ptr
        ld hl, x
        ld de, y
        xor_hl_de
        ld de, (xy_ptr)
        xor_hl_de
        ; hl is now the other coord

        pop de ; {2}

        ld a, N
        ex de, hl
        add_hl_a
        ex de, hl
        ; Now de points to next free space in hv lines (const coord)

        ; copy const coord
        ld bc, N
        ldir

        pop hl ; {1}
        pop af ; {0}

        ; If carry flag (negative), swap first and second component
        jr nc, not_neg
        push hl ; {0}

        ld hl, (hv_ptr)
        inc hl
        inc hl
        ld e, (hl)
        inc hl
        ld d, (hl)

        ld h, d
        ld l, e

        ld a, N
        add_hl_a

        ld b, N
        call mem_swap

        pop hl ; {0}
        not_neg:

        push hl ; {0}

        ; Increment segment count
        ld hl, (hv_ptr)
        ld e, (hl)
        inc hl
        ld d, (hl)
        inc de
        ld (hl), d
        dec hl
        ld (hl), e

        ; Increment pointer to next free
        inc hl
        inc hl
        ld e, (hl)
        inc hl
        ld d, (hl)
        ex de, hl
        ld a, 3 * N
        add_hl_a
        ex de, hl
        ld (hl), d
        dec hl
        ld (hl), e

        pop hl ; {0}
        ld a, '\n'
        cp (hl)
        inc hl
        jp nz, loop1

    ; Lines from wire 1 are now stored. Now loop over lines in wire 1
    ; and check which it crosses.

    push hl ; {0}

    ; Set coords to 0
    ld hl, x
    xor a
    ld b, 2 * N
    call mem_set

    pop hl ; {0}

    loop2:
        call parse_dir
        inc hl

        ld (xy_ptr), de
        ld (hv_ptr), bc

        push af ; {0}
        push hl ; {1}

        ld hl, integer_add_de
        jr nc, pos_dir2
        ld hl, integer_sub_de
        pos_dir2:
        ld (add_call2 + 1), hl

        ; Copy starting coord
        ld hl, buf1
        ex de, hl
        ld bc, N
        ldir

        pop hl ; {1}

        call parse_u16 ; de is now number from inp

        push hl ; {1}

        ld hl, (xy_ptr)
        ld b, N
        add_call2:
        call 0

        ; copy ending coord
        ld hl, (xy_ptr)
        ld de, buf2
        ld bc, N
        ldir

        pop hl ; {1}
        pop af ; {0}
        push hl ; {0}

        ; If negative, swap start and end
        jr nc, not_neg2
        ld hl, buf1
        ld de, buf2
        ld b, N
        call mem_swap
        not_neg2:

        ; Xor magic to swap hv_ptr since we want the opposite direction
        ; lines to cross.
        ld hl, h_lines
        ld de, v_lines
        xor_hl_de
        ld de, (hv_ptr)
        xor_hl_de
        ld (hv_ptr), hl

        ; Xor magic to swap xy_ptr to have axes to constant coord.
        ld hl, x
        ld de, y
        xor_hl_de
        ld de, (xy_ptr)
        xor_hl_de
        ld (xy_ptr), hl

        ; Now buf1 containst start, buf2 end, and constant coord in xy_ptr

        ; Set mindist to int max
        push hl ; {1}
        ld hl, mindist
        ld a, -1
        ld b, N
        call mem_set
        pop hl ; {1}

        ; Now loop over all the first lines perpendicular to this new line

        ld hl, (hv_ptr)
        ld c, (hl)
        inc hl
        ld b, (hl)
        inc hl \ inc hl \ inc hl
        ; bc: loop count
        ; hl: pointer to line segment data
        loop3:
            push bc ; {1}
            push hl ; {2}

            ; Check if segments cross and return distance if they do.
            call check_cross

            jr nc, no_cross_loop

            ; If cross find replace mindist if less
            ld hl, dist
            ld de, mindist
            ld b, N
            call integer_cmp

            jr nc, no_cross_loop

            ld hl, dist
            ld de, mindist
            ld bc, N
            ldir

            no_cross_loop:

            pop hl ; {2}

            ; Inc hl to next segment
            ld a, 3 * N
            add_hl_a

            pop bc ; {1}
            ; djnz
            xor a
            dec bc
            or b
            or c
            jr nz, loop3

        pop hl ; {0}
        ld a, '\n'
        cp (hl)
        inc hl
        jp nz, loop2

    ; print ans
    ld hl, mindist
    ld de, bcd_buf
    ld b, N
    ld c, BCD_N
    call bcd_make

    ld hl, bcd_buf
    ld b, BCD_N
    call bcd_print

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

; input:
;   hl: Pointer to entry in hv_lines (start, stop, const)
;   other line in (buf1: start, buf2: stop, (xy_ptr): const)
; returns:
;   carry flag set if cross
;   dist in (dist)
check_cross:
    ; A cross occurs if the const of one line lies between the
    ; start and end of the other and vice versa

    ; Checking start <= xy_ptr
        push hl
        ex de, hl

        ld hl, (xy_ptr)
        ld a, (hl)
        inc hl
        ld h, (hl)
        ld l, a

        ld b, N
        call integer_cmp_signed
        pop hl
        jp c, no_cross

    ; Checking xy_ptr <= stop
        push hl
        ex de, hl

        ld hl, (xy_ptr)
        ld a, (hl)
        inc hl
        ld h, (hl)
        ld l, a
        ex de, hl

        ld a, N
        add_hl_a

        ld b, N
        call integer_cmp_signed
        pop hl
        jp c, no_cross

    ld a, 2 * N
    add_hl_a

    ; Checking buf1 <= const
        push hl
        ld de, buf1
        ld b, N
        call integer_cmp_signed
        pop hl
        jp c, no_cross

    ; Checking const <= buf2
        push hl
        ex de, hl
        ld hl, buf2
        ld b, N
        call integer_cmp_signed
        pop hl
        jp c, no_cross

    ; They cross, find distance

    ld de, dist
    ld bc, N
    ldir

    ld hl, dist
    ld b, N
    call integer_abs

    ld hl, (xy_ptr)
    ld a, (hl)
    inc hl
    ld h, (hl)
    ld l, a

    ld de, buf3
    ld bc, N
    ldir

    ld hl, buf3
    ld b, N
    call integer_abs

    ld hl, dist
    ld de, buf3
    ld b, N
    call integer_add

    scf
    ret

    no_cross:
    or a
    ret

#include "../../util/integer/cmp.asm"
#include "../../util/integer/cmp_signed.asm"
#include "../../util/integer/abs.asm"
#include "../../util/integer/add.asm"
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
; as N byte integers, then the constant coord.
h_lines:
    .fill 2 * 2 + 10 * N * 3
v_lines:
    .fill 2 * 2 + 10 * N * 3

input:
    #incbin "ex1.txt"
    .db 0
