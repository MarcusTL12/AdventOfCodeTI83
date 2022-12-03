#ifndef mem_and_inc
#define mem_and_inc

; input:
;   hl: pointer to a
;   de: pointer to b
;   b: number of bytes to copy
mem_and:
    ld a, (de)
    and (hl)
    ld (hl), a
    inc hl
    inc de
    djnz mem_and
    ret

#endif
