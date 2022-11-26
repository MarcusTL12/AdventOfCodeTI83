#include "../../header.asm"

title:
   .db "2015 d2p1",0

main:
    bcall(_clrscrf)
    bcall(_homeup)

    

    bcall(_getkey) ; Pause
    ret

#include "input.asm"
