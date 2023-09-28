#include "../../header.asm"

title:
    .db "2022 d8p1",0

#include "../../util/debug/push_all.asm"

#include "../../util/add_hl_a.asm"

; 16 bit number:
#define inplen saferam1

; 8 bit numbers:
#define width saferam1 + 2
#define height saferam1 + 3

; 16 bit number:
#define ans saferam1 + 4

; 8 bit number:
#define curtree saferam1 + 6

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, input
    ld de, 0
    ld c, 0
    loop_find_length:
        ld a, (hl)
        cp 0
        jp z, loop_find_length_break
        inc hl
        inc de
        cp '\n'
        jp nz, loop_find_length
        inc c
        jp loop_find_length
    loop_find_length_break:
    ld (inplen), de
    ld a, c
    ld (height), a

    ld hl, input
    ld c, 0
    loop_find_width:
        ld a, (hl)
        cp '\n'
        jp z, loop_find_width_break
        inc hl
        inc c
        jp loop_find_width
    loop_find_width_break:
    ld a, c
    ld (width), a

    ; inplen, width and height now set

    ld hl, 0
    ld (ans), hl

    ld d, 0 ; vertical index
    ld a, (width)
    ld b, a
    loop_w:
        ld e, 0 ; horizontal index
        ld c, b
        ld a, (height)
        ld b, a
        loop_h:
            push bc ; save iteration variables

            push de
            call get_tree ; load current tree, and trust it is inbound
            pop de

            ld (curtree), a

            push de ; save indices
            ld ix, dirs
            ld b, 4
            ld c, 0 ; bool for if visibile by any
            loop_dirs:
                push bc

                ld c, 1 ; bool for if all trees are lower
                loop_dir:
                    ld a, (ix)
                    add a, e
                    ld e, a ; get new horizontal index

                    ld a, (ix + 1)
                    add a, d
                    ld d, a ; get new vertical index

                    push de
                    call get_tree
                    pop de

                    jp c, loop_dir_break ; reached out of bounds

                    ld hl, curtree
                    cp (hl) ; carry if curtree > newtree
                            ; c => potentially visible
                            ; nc => not visible, break

                    jp c, loop_dir

                ld c, 0 ; broke out because of no visibility
                loop_dir_break:

                ld a, c ; Move c to a

                pop bc ; so that we can pop other c

                or c
                ld a, c ; set c if a was set

                inc ix
                inc ix
                djnz loop_dirs
            pop de

            ld a, c
            ld hl, (ans)
            add_hl_a
            ld (ans), hl

            inc e
            pop bc
            djnz loop_h
        inc d
        ld b, c
        djnz loop_w

    ld hl, (ans)
    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

; input:
;   d: vertical index
;   e: horizontal index
; output:
;   a: height of tree (if inbounds)
;   carry flag set if out of bounds
; destroys:
;   hl
get_tree:
    ld a, d
    ld hl, height
    cp (hl)
    ret c ; out of vertical bounds

    ld a, e
    ld hl, width
    cp (hl)
    ret c ; out of horizontal bounds

    ; load correct address

    ld l, d
    ld a, (width)
    inc a
    ld h, a
    push de
    bcall(_htimesl)
    pop de

    ld a, e
    add_hl_a

    ld a, (hl)

    or a ; clear carry flag
    ret

dirs:
    .db 1,0
    .db -1,0
    .db 0,1
    .db 0,-1

input:
    #incbin "ex1"
    .db 0
