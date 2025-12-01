#ifndef cp_hlde_inc
#define cp_hlde_inc

; From:
; https://wikiti.brandonw.net/index.php?title=Z80_Routines:Optimized:CpHLDE
; time: 4 * 6 = 24
#define cp_hlde
#defcont    or a
#defcont  \ sbc hl,de
#defcont  \ add hl,de
#defcont  \ ret

#endif
