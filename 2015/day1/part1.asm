#include "../../header.asm"

title:
   .db "2015 d1p1",0

main:
    bcall(_clrscrf)
    bcall(_homeup)

    ld bc,input
    ld d, 0
    ld e, 40
    ld hl, 0

    loop1:
        ld a, (bc) ; Move next char into a
        inc bc ; bc += 1
        cp d ; a == 0
        jp z, loop1_exit
        sub e ; a -= 40
        jp z, inc_ans
            dec hl
            jp loop1
        inc_ans:
            inc hl
            jp loop1
    loop1_exit:

    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret

#include "input.asm"
