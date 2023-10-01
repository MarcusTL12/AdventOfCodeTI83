#ifndef mem_invert_inc
#define mem_invert_inc

; inverts a segment in memory
; input:
;   hl: pointer to start of memory
;   b: number of bytes (0 => 256)
; destroys:
;   hl: points to first byte after section
;   a
mem_invert:
    ld a, (hl)
    cpl
    ld (hl), a
    inc hl
    djnz mem_invert
    ret

#endif
