#ifndef inc_mem_inc
#define inc_mem_inc

; Increments "big integer" memory. Goes on until no carry,
; so potential for buffer overflow if intended memory is maxed.
; hl: pointer to mem
inc_mem:
    inc (hl)
    inc hl
    jp c, inc_mem
    ret

#endif
