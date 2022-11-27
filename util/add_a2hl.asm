#ifndef add_a2hl_inc
#define add_a2hl_inc

; time: 29/30 + call (= 46/47)
add_a2hl:
    add a,l
    ld l,a
    jr nc, $+3
    inc h
    ret

#endif
