#ifndef neg_hl_inc
#define neg_hl_inc

; ; destroys a
; ; time: 4 * 6 + 6 = 30
; #define neg_hl
; #defcont    ld a, h
; #defcont  \ cpl
; #defcont  \ ld h, a
; #defcont  \ ld a, l
; #defcont  \ cpl
; #defcont  \ ld l, a
; #defcont  \ inc hl

; From:
; https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Signed_Math
; destroys a
; time: 4 * 6 = 24
#define neg_hl
#defcont    xor a
#defcont  \ sub l
#defcont  \ ld l,a
#defcont  \ sbc a,a
#defcont  \ sub h
#defcont  \ ld h,a

#endif
