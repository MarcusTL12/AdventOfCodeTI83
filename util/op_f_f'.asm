#ifndef op_f_f'_inc
#define op_f_f'_inc

#include "ld_a_f.asm"

; performs OP on f and f'. Result stored in f
; time: (11 + 10) * 3 + 4 * 3 + 33 = 108
; destroys a
#define op_f_f'(OP)
#defcont    push hl     ; 11
#defcont    push af     ; 11
#defcont    pop hl      ; 10
#defcont    ex af, af'  ; 4
#defcont    push af     ; 11
#defcont    ld a, l     ; 4
#defcont    pop hl      ; 10
#defcont    OP a, l     ; 4
#defcont    ld_f_a      ; 33
#defcont    pop hl      ; 10

#endif
