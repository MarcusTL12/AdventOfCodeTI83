#include "../../header.asm"

title:
   .db "2015 d2p1",0

main:
    bcall(_clrscrf)
    bcall(_homeup)

    ; Init ans = 0
    xor a
    ld (saferam1 + 4), a
    ld (saferam1 + 5), a
    ld (saferam1 + 6), a
    ld (saferam1 + 7), a

    ld hl, input
    ld de, saferam1
    ld b, 3
    call parse_line

    ; saferam1[3] = x * y
    ld hl, (saferam1)
    bcall(_htimesl)
    ld a, l
    ld (saferam1 + 3), a

    ; l = x + y
    ld hl, (saferam1)
    ld a, h
    add a, l
    ld l, a

    ; l = l * z
    ld a, (saferam1 + 2)
    ld h, a
    bcall(_htimesl)

    ; a = (saferam1[3] + l) * 2
    ld a, (saferam1 + 3)
    add a, l
    sla a

    ld hl, saferam1 + 4
    call integer_add_a


    ; print ans
    ld hl, saferam1 + 4
    ld de, saferam1 + 8
    ld a, 4
    ld (saferam1), a
    inc a
    ld (saferam1 + 1), a
    call bcd_make

    ld hl, saferam1 + 8
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

#include "../../util/integer/add_a.asm"

#include "../../util/bcd/make.asm"
#include "../../util/bcd/print.asm"

min_two_dims_map:
    .db 1,2
    .db 0,2
    .db 0,1

; input:
;     .db "2x3x4",10,"1x1x10",10

input:
    .db "1x1x10",10
