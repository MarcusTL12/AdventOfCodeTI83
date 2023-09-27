#include "../../header.asm"

title:
   .db "2015 d2p2",0

#include "../../util/add_hl_a.asm"

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ; defining variables
    #define xyz     saferam1
    #define buf     saferam1 + 3
    #define ans     saferam1 + 5
    #define bcd_buf saferam1 + 9

    ; Init ans = 0
    ld hl, 0
    ld (ans), hl
    ld (ans + 2), hl

    ld hl, input

    loop1:
        ; parse next line
        ld de, xyz
        ld b, 3
        call parse_line
        push hl

        ; hl = x * y
        ld hl, (xyz)
        bcall(_htimesl)

        ; buf = hl * z ; Hope that x * y * z always fits in 16-bit
        ld a, (xyz + 2)
        call mul_a_hl
        ld (buf), hl

        ; find index of largest side length
        ld hl, xyz
        ld b, 3
        call max_u8

        ; find indices of two smallest sides
        ld a, d
        add a, a
        ld hl, min_two_dims_map
        add_hl_a
        ld d, (hl)
        inc hl
        ld e, (hl)

        ; d = xyz[d]
        ld hl, xyz
        ld a, d
        add_hl_a
        ld a, (hl)
        ld d, a

        ; e = xyz[e]
        ld hl, xyz
        ld a, e
        add_hl_a
        ld a, (hl)
        ld e, a

        ; hl = buf + 2 * (d + e)
        ld a, d
        add a, e
        add a, a
        ld hl, (buf)
        add_hl_a

        ; ans += hl
        ex de, hl
        ld hl, ans
        call integer_add_de

        pop hl
        xor a
        cp (hl)
        jp nz, loop1

    ; print ans
    ld hl, ans
    ld de, bcd_buf
    ld b, 4
    ld c, 5
    call bcd_make

    ld hl, bcd_buf
    ld b, 5
    call bcd_print

    bcall(_getkey) ; Pause
    ret


; input:
; hl: pointer to beginning of line
; de: pointer to where numbers should be stored
; b: number of numbers
; output:
; hl: points to beginning of next line
; de: points to next byte after numbers
; b: 0
parse_line:
    push bc
    push de
    call parse_u8
    pop de
    pop bc
    ld (de), a
    inc de
    inc hl
    djnz parse_line
    ret

#include "../../util/parse_u8.asm"
#include "../../util/max_u8.asm"
#include "../../util/mul_a_hl.asm"

#include "../../util/integer/add_de.asm"

#include "../../util/bcd/make.asm"
#include "../../util/bcd/print.asm"

min_two_dims_map:
    .db 1,2
    .db 0,2
    .db 0,1

input:
    #incbin "input.txt"
    .db 0
