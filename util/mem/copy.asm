#ifndef mem_copy_inc
#define mem_copy_inc

; input:
; hl: pointer to source memory
; de: pointer to destination memory
; b: number of bytes to copy
; output:
; hl = hl + b
; de = de + b
; destroys:
; a, b
mem_copy:
    ld a, (hl)
    ld (de), a
    inc hl
    inc de
    djnz mem_copy
    ret

#endif
