#ifndef mul_a_10_inc
#define mul_a_10_inc

; multiplies a by 10
; destroys
;   d
; Time: 20 clk (+ call/ret)
; Space: 5 (+ call/ret)
#define mul_a_10
#defcont    add a, a
#defcont  \ ld d, a
#defcont  \ add a, a
#defcont  \ add a, a
#defcont  \ add a, d

#endif
