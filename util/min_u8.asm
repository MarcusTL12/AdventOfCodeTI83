#ifndef min_u8_inc
#define min_u8_inc

; Find minimum byte in array
; input:
; hl: pointer to start of array
; b: length of array
; output:
; d: index of minimum entry
; e: value of minimum entry
; destroys: af, bc, de, hl
min_u8:
    xor a
    ld c, a     ; to keep current index
    ld d, a     ; to save index of min
    ld e, (hl)  ; to keep minimum element
    dec b
    ret z ; return early if array contained only one entry

    min_u8_loop:
        inc c
        inc hl
        ld a, (hl)
        cp e
        jp nc, min_u8_skip_update
        ld d, c
        ld e, a
        min_u8_skip_update:
        djnz min_u8_loop

    ret

#endif
