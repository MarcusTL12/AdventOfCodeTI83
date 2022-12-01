#ifndef integer_parse_inc
#define integer_parse_inc

#include "../mem/set.asm"
#include "../mem/copy.asm"
#include "../mem/lshft.asm"

#include "add.asm"
#include "add_a.asm"

#include "../print_hex.asm"
#include "../debug/push_all.asm"

; Memory for temporary variable
#define integer_parse_buffer saferam3

; input:
; hl: pointer to string. Stops at first non-numerical digit. Will point to this at return.
; de: pointer to integer location.
; b: length of integer (max 128 (1024 bit int))
; destroys: saferam3[0:b]
integer_parse:
    ex de, hl
    ld c, b ; save away length of integer

    push hl
    xor a
    call mem_set ; initialize ans to 0
    pop hl

    integer_parse_loop:
        ld a, (de)

        sub 48
        cp 10
        jp nc, integer_parse_loop_break ; check char is numeric

        inc de
        push de
        push af ; save a

        ; Multiply int by 10:

        push hl
        xor a ; clear carry flag
        ld b, c ; retrieve length
        call mem_lshft ; multiply int by 2
        pop hl

        push hl
        ld de, integer_parse_buffer
        ld b, c
        call mem_copy ; copy int to buf
        pop hl

        push hl
        xor a ; clear carry flag
        ld b, c ; retrieve length
        call mem_lshft ; multiply int by 2
        pop hl

        push hl
        xor a ; clear carry flag
        ld b, c ; retrieve length
        call mem_lshft ; multiply int by 2
        pop hl

        push hl
        ld de, integer_parse_buffer
        ld b, c
        call integer_add ; int = int + buf (10 = 8 + 2)
        pop hl

        pop af ; retrieve a

        push hl
        call integer_add_a ; add a to ans
        pop hl

        pop de
        jp integer_parse_loop
    integer_parse_loop_break:

    ex de, hl
    ret

#endif
