#include "../header.asm"

title:
    .db "test psst",0

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

    #define x saferam1

    ld a, 2
    ld hl, test_psst_mem
    ld de, test_cmp
    call psst_init

    ld hl, 752
    ld (x), hl
    ld de, x
    ld hl, test_psst_mem
    call psst_insert

    ld hl, 1000
    ld (x), hl
    ld de, x
    ld hl, test_psst_mem
    call psst_insert

    ld hl, 500
    ld (x), hl
    ld de, x
    ld hl, test_psst_mem
    call psst_insert

    ld hl, 685
    ld (x), hl
    ld de, x
    ld hl, test_psst_mem
    call psst_insert

    ; TODO: Figure out why this messes up memory during binary search
    ld hl, 8
    ld (x), hl
    ld de, x
    ld hl, test_psst_mem
    call psst_insert

    ld hl, 3
    ld (x), hl
    ld de, x
    ld hl, test_psst_mem
    call psst_insert

    ld hl, 752
    ld (x), hl
    ld de, x
    ld hl, test_psst_mem
    call psst_insert

    ; TODO: Figure out why this is duplicated
    ld hl, 8
    ld (x), hl
    ld de, x
    ld hl, test_psst_mem
    call psst_insert

    bcall(_newline)

    ld hl, test_psst_mem
    call psst_len
    ld b, l

    ld hl, test_psst_mem + 7

    loop1:
        push bc

        ld e, (hl)
        inc hl
        ld d, (hl)
        inc hl

        push hl
        ex de, hl
        bcall(_disphl)
        pop hl
        pop bc
        djnz loop1

    bcall(_getkey) ; Pause
    ret

; input:
;     hl: pointer to element a
;     de: pointer to element b
;     compares a - b
;     output: zero flag set if equal, carry flag set if b > a
;     expected to destroy all registers
test_cmp:
    ld c, (hl)
    inc hl
    ld b, (hl)
    ex de, hl
    ld e, (hl)
    inc hl
    ld d, (hl)
    push bc
    pop hl
    bjump(_cphlde)

#include "../util/psst.asm"

test_psst_mem:
    .fill 50
