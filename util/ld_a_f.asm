#ifndef ld_a_f_inc
#define ld_a_f_inc

; Loads f into a
; time: 11 + 10 + 2 * 6 = 33
#define ld_a_f
#defcont    push af ; 11
#defcont  \ dec sp  ; 6
#defcont  \ pop af  ; 10
#defcont  \ inc sp  ; 6

; Loads a into f
; time: 11 + 10 + 2 * 6 = 33
#define ld_f_a
#defcont    dec sp  ; 6
#defcont  \ push af ; 11
#defcont  \ inc sp  ; 6
#defcont  \ pop af  ; 10

#endif
