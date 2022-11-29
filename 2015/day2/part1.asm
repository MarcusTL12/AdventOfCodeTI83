#include "../../header.asm"

title:
   .db "2015 d2p1",0

main:
    bcall(_clrscrf)
    bcall(_homeup)

    ; defining variables
    #define xyz saferam1
    #define buf saferam1 + 3
    #define ans saferam1 + 4
    #define bcd_buf saferam1 + 8

    ; Init ans = 0
    ld hl, 0
    ld (ans), hl
    ld (ans + 2), hl

    ld hl, input
    ld de, xyz
    ld b, 3
    call parse_line

    ; buf = x * y
    ld hl, (xyz)
    bcall(_htimesl)
    ld a, l
    ld (buf), a

    ; l = x + y
    ld hl, (xyz)
    ld a, h
    add a, l
    ld l, a

    ; l = l * z
    ld a, (xyz + 2)
    ld h, a
    bcall(_htimesl)

    ; buf = (buf + l) * 2
    ld a, (buf)
    add a, l
    sla a
    ld (buf), a

    ; ans += buf
    ld a, (buf)
    ld hl, ans
    call integer_add_a

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

#include "../../util/integer/add_a.asm"

#include "../../util/bcd/make.asm"
#include "../../util/bcd/print.asm"

min_two_dims_map:
    .db 1,2
    .db 0,2
    .db 0,1

input:
    .db "2x3x4",10,"1x1x10",10

; input:
;     .db "1x1x10",10
