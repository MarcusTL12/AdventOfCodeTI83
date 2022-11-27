#ifndef div32_16_inc
#define div32_16_inc

; from https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Division

div32_16:
; IN:	ACIX=dividend, DE=divisor
; OUT:	ACIX=quotient, DE=divisor, HL=remainder, B=0
	ld	hl,0
	ld	b,32
Div32By16_Loop:
	add	ix,ix
	rl	c
	rla
	adc	hl,hl
	jr	c,Div32By16_Overflow
	sbc	hl,de
	jr	nc,Div32By16_SetBit
	add	hl,de
	djnz	Div32By16_Loop
	ret
Div32By16_Overflow:
	or	a
	sbc	hl,de
Div32By16_SetBit:
	.db	$DD,$2C		; inc ixl, change to inc ix to avoid undocumented
	djnz	Div32By16_Loop
	ret


#endif
