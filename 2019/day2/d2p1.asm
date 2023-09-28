#include "../../header.asm"

title:
   .db "2019 d2p1",0

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ; constants
    #define N 3
    #define BCD_N 4

    ; variables
    ld hl, 12345
    div_hl_2
    ; or a
    ; rr h
    ; rr l

    bcall(_disphl)

    bcall(_getkey) ; Pause
    ret


; #include "../../util/integer/parse.asm"
; #include "../../util/integer/divrem_a.asm"
; #include "../../util/integer/sub_a.asm"
; #include "../../util/integer/add.asm"

; #include "../../util/bcd/make.asm"
; #include "../../util/bcd/print.asm"

; #include "../../util/mem/set.asm"

input:
    ; #incbin "input.txt"
    .db 0
