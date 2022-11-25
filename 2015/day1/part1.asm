#include "../../header.asm"

title:
   .db "2015 d1p1",0

main:
    bcall(_clrscrf)
    bcall(_homeup)

    ld bc,$input
    ld d,0
    ld e,40

    loop1:
        ld a,(bc) ; Move next char into a
        cp d ; a == 0
        jp z,$loop1_exit
        sub e ; a -= 40
        sla a ; a *= 2
        dec a ; a -= 1
        neg a ; a = -a
        ; ans += a

        jp $loop1
    loop1_exit:

    bcall(_getkey) ; Pause
    ret

#include "../../util/println.asm"

; #include "input.asm"

input:
    .db "))(((((",0
