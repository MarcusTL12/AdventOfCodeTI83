#ifndef div_hl_c_inc
#define div_hl_c_inc

; https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Division

; output: hl/c -> hl, a
; destroys: b
div_hl_c:
   xor	a
   ld	b, 16

div_hl_c_loop:
   add	hl, hl
   rla
   jr	c, $+5
   cp	c
   jr	c, $+4

   sub	c
   inc	l
   
   djnz	div_hl_c_loop
   
   ret

#endif
