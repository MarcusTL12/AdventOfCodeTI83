; #define TI83P   ; If you want to compile for TI-83+ family calcs
#define TI83   ; If you want to compile for TI-83, don't uncomment both!

#include "ion/ion.inc"

; ====
; Start of Ion header

#ifdef TI83P
    .binarymode TI8X   ; only required if you use Brass
    .org progstart-2
    .db $BB,$6D
#else
    .binarymode TI83   ; only required if you use Brass
    .org progstart
#endif
    ret
    jr nc,main

; End of Ion header
; ====