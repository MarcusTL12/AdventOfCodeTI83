#include "../../header.asm"

title:
   .db "2019 d2p1",0

#include "../../util/add_hl_a.asm"

; constants
#define N 3
#define BCD_N 4

#define intcode_pc saferam1

main:
    bcall(_clrscrf)
    bcall(_homeup)
    ld hl, title
    bcall(_puts)
    bcall(_newline)

    ld hl, input
    ld de, intcode

    loop_parse:
        ld b, N
        call integer_parse

        ex de, hl

        ld a, N
        add_hl_a

        ex de, hl

        ld a, '\n'
        cp (hl)
        jr nz, loop_parse

    ld hl, 0
    ld (intcode_pc), hl

    loop_run:
        ld a, 99
        ld de, intcode

        jr loop_run

    bcall(_getkey) ; Pause
    ret


#include "../../util/integer/parse.asm"
; #include "../../util/integer/divrem_a.asm"
; #include "../../util/integer/sub_a.asm"
; #include "../../util/integer/add.asm"

; #include "../../util/bcd/make.asm"
; #include "../../util/bcd/print.asm"

; #include "../../util/mem/set.asm"

intcode:
    .fill 120 * N

input:
    #incbin "ex1.txt"
    .db 0
