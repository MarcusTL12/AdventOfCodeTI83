#include "../../header.asm"

title:
   .db "2015 d2p2",0

#include "../../util/add_a_hl.asm"

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    

    bcall(_getkey) ; Pause
    ret


input:
    #incbin "input.txt"
    .db 0
