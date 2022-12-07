#ifndef integer_add_inc
#define integer_add_inc

; x = x + y
; input:
; hl: pointer to x
; de: pointer to y
; b: length of integers
integer_add:
    xor a ; clear carry flag
; Then jumps directly to adc under

; x = x + y + CY
; input:
; hl: pointer to x
; de: pointer to y
; b: length of integers
; time: (7 * 3 + 2 * 6 + 13) * b + ... = 50 * b + ...
integer_adc:
    ld a, (de)
    adc a, (hl)
    ld (hl), a
    inc hl
    inc de
    djnz integer_adc
    ret

#endif
