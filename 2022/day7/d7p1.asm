#include "../../header.asm"

title:
    .db "2022 d7p1",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)



    bcall(_getkey) ; Pause
    ret

#include "parse_filesystem.asm"

input:
    #incbin "ex1"
    .db 0
