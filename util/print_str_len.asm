#ifndef print_str_len_inc
#define print_str_len_inc

; print string of given length
; hl: pointer to string
; b: length of string
; destroys a, b, hl
print_str_len:
    ld a, (hl)
    bcall(_putc)
    inc hl
    djnz print_str_len
    ret

#endif
