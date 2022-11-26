#ifndef add_a2hl_inc
#define add_a2hl_inc

add_a2hl:
    add a,l
    ld l,a
    jr nc, $+3
    inc h
    ret

#endif
