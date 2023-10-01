#include "../../header.asm"

title:
   .db "2019 d3p1",0

; constants
#define N 3
#define BCD_N 4

; variables
#define x saferam1
#define y x + N
#define buf y + N
#define dist buf + N
#define mindist dist + N

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

    ld hl, map_dict
    ld a, 2 * N
    ld de, icmp
    call psst_init

    ld hl, input

    loop1:
        call parse_dir
        inc hl

        push hl ; {0}

        ld hl, integer_inc
        jr nc, pos_dir
        ld hl, integer_dec
        pos_dir:
        ld (inc_call + 1), hl

        pop hl ; {0}

        push de ; {0} x/y

        ld de, buf
        ld b, N
        call integer_parse

        pop de ; {0} x/y

        push hl ; {0}

        loop2:
            push de ; {1} x/y

            ex de, hl
            ld b, N
            inc_call:
            call 0

            ld hl, map_dict
            ld de, x
            call psst_insert

            ; djnz:
            ld hl, buf
            ld b, N
            call integer_dec

            ld hl, buf
            ld b, N
            xor a
            call integer_cmp_a

            pop de ; {1} x/y

            jp nz, loop2

        pop hl ; {0}
        ld a, '\n'
        cp (hl)
        inc hl
        jp nz, loop1

    push hl ; {0}

    ld hl, map_dict
    call psst_len
    bcall(_disphl)
    bcall(_newline)

    ; Set coords to 0
    ld hl, x
    xor a
    ld b, 2 * N
    call mem_set

    ; Set mindist to max
    ld hl, mindist
    ld a, ffh
    ld b, N
    call mem_set

    pop hl ; {0}

    loop3:
        call parse_dir
        inc hl

        push hl ; {0}

        ld hl, integer_inc
        jr nc, pos_dir2
        ld hl, integer_dec
        pos_dir2:
        ld (inc_call2 + 1), hl

        pop hl ; {0}

        push de ; {0} x/y

        ld de, buf
        ld b, N
        call integer_parse

        pop de ; {0} x/y

        push hl ; {0}

        loop4:
            push de ; {1} x/y

            ex de, hl
            ld b, N
            inc_call2:
            call 0

            ld hl, map_dict
            ld de, x
            call psst_search

            jr c, did_not_find

            ld de, dist
            ld hl, x
            ld bc, N
            ldir

            ld hl, dist
            ld de, y
            ld b, N
            call integer_add

            ld hl, dist
            ld de, mindist
            ld b, N
            call integer_cmp

            jr nc, not_less

            ld de, mindist
            ld hl, dist
            ld bc, N
            ldir

            not_less:
            did_not_find:

            ; djnz:
            ld hl, buf
            ld b, N
            call integer_dec

            ld hl, buf
            ld b, N
            xor a
            call integer_cmp_a

            pop de ; {1} x/y

            jp nz, loop4

        pop hl ; {0}
        ld a, '\n'
        cp (hl)
        inc hl
        jp nz, loop3

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
;   carryflag set if negative dir
parse_dir:
    ld a, (hl)
    ld de, x

    cp 'L'
    scf
    ret z

    cp 'R'
    scf
    ccf
    ret z

    ld de, y

    cp 'D'
    scf
    ret z

    ; Assume that it is 'U' at this point

    ccf
    ret


icmp:
    ld b, 2 * N
    jp integer_cmp

#include "../../util/integer/parse.asm"
#include "../../util/integer/cmp.asm"
#include "../../util/integer/cmp_a.asm"
#include "../../util/integer/inc.asm"
#include "../../util/integer/dec.asm"

#include "../../util/bcd/make.asm"
#include "../../util/bcd/print.asm"

#include "../../util/mem/set.asm"

#include "../../util/psst.asm"

map_dict:
    .fill 1024 * 4

input:
    #incbin "ex2.txt"
    .db 0
