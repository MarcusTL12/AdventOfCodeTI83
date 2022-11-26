#include "../../header.asm"

title:
   .db "2015 d1p1",0

main:
    bcall(_clrscrf)
    bcall(_homeup)

    ld bc, input ; bc = &input
    ld d, 0      ; d = 0
    ld e, 40     ; e = 40
    ld hl, 0     ; hl = 0

    loop1:
        ld a, (bc)       ; a = *bc
        inc bc           ; bc += 1
        cp d             ; if a == 0
        jp z, loop1_exit ; break loop1
        cp e             ; if a != 40
        jp z, inc_ans    ; {
            dec hl       ;    hl -= 1
            jp loop1     ; }
        inc_ans:         ; else {
            inc hl       ;    hl += 1
            jp loop1     ; }
    loop1_exit:

    bcall(_disphl) ; print(hl)

    bcall(_getkey) ; Pause
    ret

#include "input.asm"
