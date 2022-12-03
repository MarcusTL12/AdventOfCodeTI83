#ifndef neg_hl_inc
#define neg_hl_inc

; destroys a
; time: 4 * 6 + 6 = 30
#define neg_hl
#defcont    ld a, h
#defcont    \ cpl
#defcont    \ ld h, a
#defcont    \ ld a, l
#defcont    \ cpl
#defcont    \ ld l, a
#defcont    \ inc hl

#endif
