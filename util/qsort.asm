#ifndef qsort_inc
#define qsort_inc

; quicksort (unstable, random)
; input
; hl: pointer to array
; de: length of array
; b: size of element
; saferam[0:1]: function pointer to comparison function:
;   input:
;   hl: pointer to element a
;   de: pointer to element b
;   compares a - b
;   output: zero flag set if equal, sign flag set if b > a
qsort:
    ret

; input
;   hl: pointer to beginning of array
;   de: pointer to end of array
; output
;   hl: pointer to pivot
qsort_partition:
    ret

#endif
