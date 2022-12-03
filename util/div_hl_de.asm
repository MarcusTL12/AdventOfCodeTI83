#ifndef div_hl_de_inc
#define div_hl_de_inc

; https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Division

; hl/de -> hl,de
div_hl_de:
   ld a, h
   ld c, l
   ld	hl, 0
   ld	b, 16

div_hl_de_loop:
   sll	c
   rla
   adc	hl, hl
   sbc	hl, de
   jr	nc, $+4
   add	hl, de
   dec	c
   
   djnz	div_hl_de_loop
   
   ex de, hl
   ld h, a
   ld l, c

   ret
 

#endif
