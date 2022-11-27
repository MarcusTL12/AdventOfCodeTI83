#ifndef div_32_8_inc
#define div_32_8_inc

div_dehl_c:
   xor a
   ld b, 32

div_dehl_c_loop:
   add hl, hl
   rl e
   rl d
   rla
   jr c, $+5
   cp c
   jr c, $+4

   sub c
   inc l
   
   djnz div_dehl_c_loop
   
   ret

#endif
