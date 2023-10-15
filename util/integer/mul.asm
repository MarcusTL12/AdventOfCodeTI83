#ifndef integer_mul_inc
#define integer_mul_inc

#include "add.asm"
#include "adc_a.asm"
#include "mul_a.asm"

; Multiplies integers a and b
; hl: pointer to integer a
; de: pointer to integer b
; b: number of bytes in a
; c: number of bytes in b
; ix: pointer to answer location (a + b bytes)
; iy: pointer to buffer (b bytes)
;
; Will add to instead of overwriting ans
integer_mul:
    push hl ; {0}
    push de ; {1}
    push bc ; {2}

    ; Copy integer b into buffer
    push iy
    pop hl
    ex de, hl
    ld b, 0
    ldir

    pop bc ; {2}
    pop de ; {1}
    pop hl ; {0}

    push hl ; {0}
    push de ; {1}
    push bc ; {2}

    ; Multiply buffer with least "digit" byte of integer a
    ld a, (hl)
    push iy
    pop hl
    ld b, c
    call integer_mul_a

    pop bc ; {2}
    pop de ; {1}
    pop hl ; {0}

    push hl ; {0}
    push de ; {1}
    push bc ; {2}

    push af ; {3} overflow

    ; Add multiplication result to ans
    push ix
    pop hl
    push iy
    pop de
    ld b, c
    call integer_add

    pop de ; {3} overflow
    pop bc ; {2}
    push bc ; {2}

    ; Add overflow byte to ans
    ld a, d
    call integer_adc_a

    pop bc ; {2}
    pop de ; {1}
    pop hl ; {0}

    ; Push pointers up and multiply next "digit"
    inc hl
    inc ix
    djnz integer_mul

    ret

#endif
