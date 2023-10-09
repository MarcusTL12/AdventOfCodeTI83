#ifndef ld_cf_nf_inc
#define ld_cf_nf_inc

; Copy sign flag to carry flag
; Time: positive: 4 + 11         = 15
;       negative: 4 + 5 + 4 + 10 = 23
ld_cf_sf:
    scf
    ret m
    ccf
    ret

#endif
