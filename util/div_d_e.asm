#ifndef div_d_e_inc
#define div_d_e_inc

; from https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Division

; d / e -> d, a
; destroys:
; b
div_d_e:
    xor a
    ld b, 8

    div_d_e_loop:
        sla d
        rla
        cp e
        jr c, $+4
        sub e
        inc d

        djnz div_d_e_loop

    ret


#endif
