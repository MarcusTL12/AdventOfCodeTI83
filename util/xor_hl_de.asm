#ifndef xor_hl_de_inc
#define xor_hl_de_inc

; Destroys:
;   a
; Time:
;   4 * 6 = 24
#define xor_hl_de
#defcont    ld a, l
#defcont  \ xor e
#defcont  \ ld l, a
#defcont  \ ld a, h
#defcont  \ xor d
#defcont  \ ld h, a

#endif
