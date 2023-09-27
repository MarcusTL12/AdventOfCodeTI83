#ifndef add_hl_a_inc
#define add_hl_a_inc

; Adds a to hl
; time: 19/20
; destroys:
;   a
#define add_hl_a
#defcont    add a,l
#defcont  \ ld l,a
#defcont  \ jr nc, $+3
#defcont  \ inc h

#endif
