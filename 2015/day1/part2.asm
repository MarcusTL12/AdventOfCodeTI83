#include "../../header.asm"

title:
   .db "2015 d1p2",0

main:
    bcall(_clrscrf)
    bcall(_homeup)

    ld bc, input         ; bc = &input
    ld de, -1            ; de = -1
    ld hl, 0             ; hl = 0

    loop1:
        bcall(_cphlde)
        jp z, loop1_exit
        ld a, (bc)       ; a = *bc
        inc bc           ; bc += 1
        cp 40            ; if a != 40
        jp z, inc_ans    ; {
            dec hl       ;    hl -= 1
            jp loop1     ; }
        inc_ans:         ; else {
            inc hl       ;    hl += 1
            jp loop1     ; }
    loop1_exit:

    ; hl = bc - input
    push bc
    pop hl
    ld bc, -input
    add hl, bc

    bcall(_disphl) ; print(hl)

    bcall(_getkey) ; Pause
    ret

#include "input.asm"
