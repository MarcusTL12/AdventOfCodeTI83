#ifndef max_u8_inc
#define max_u8_inc

; Find maximum byte in array
; input:
; hl: pointer to start of array
; b: length of array
; output:
; d: index of maximum entry
; e: value of maximum entry
; destroys: af, bc, de, hl, saferam1[0]
max_u8:
    xor a
    ld c, a     ; to keep current index
    ld d, a     ; to save index of max
    ld e, (hl)  ; to keep maximum element
    dec b
    ret z ; return early if array contained only one entry

    max_u8_loop:
        inc c
        inc hl
        ld a, (hl)
        cp e
        jp c, max_u8_skip_update
        ld d, c
        ld e, a
        max_u8_skip_update:
        djnz max_u8_loop

    ret

#endif
