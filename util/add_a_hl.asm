#ifndef add_a_hl_inc
#define add_a_hl_inc

; Adds a to hl
; time: 19/20
; destroys:
;   a
#define add_a_hl
#defcont    add a,l
#defcont  \ ld l,a
#defcont  \ jr nc, $+3
#defcont  \ inc h

#endif
