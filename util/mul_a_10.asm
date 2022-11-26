#ifndef mul_a_10_inc
#define mul_a_10_inc

; multiplies a by 10
; destroys
;   d
; Time: 20 clk (+ call/ret)
; Space: 5 (+ call/ret)
mul_a_10:
    add a, a
    ld d, a
    add a, a
    add a, a
    add a, d
    ret

#endif
