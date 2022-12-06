#ifndef bitset_u8_inc
#define bitset_u8_inc

#include "add_a_hl.asm"

; Bit set with 8-bit indexing, meaning max 256 bits

; Break index into byte index and sub-bit index
; input: a = index to bit
; output:
;   a = index % 8
;   b = index / 8
; destroys nothing
bitset_u8_break_index:
    ld b, a ; b = a
    and 7 ; a = a % 8
    sra b
    sra b
    sra b ; b = b / 8
    ret

; input:
;   hl: pointer to bitset
;   a: index to bit
; destoroys:
;   af, bc, de, hl
bitset_u8_internal:
    call bitset_u8_break_index ; get byte/bit indices

    add a, a ; a = a * 8, for aligning to instruction mask
    add a, a
    add a, a

    ld hl, bitset_u8_internal_bit_instruction + 1
    or (hl)
    ld (hl), a ; Set bit number to instruction
    ex de, hl

    ld c, a
    ld a, b
    add_a_hl ; Make pointer point to byte

    bitset_u8_internal_bit_instruction:
    bit 0, a ; Specific instruction will be set before call

    ret

; Specific entry points:

; Set the 2 most significant bits of 2nd byte of bit instruction
; and the 3 least significant bits to 111 to work on register a

; Tests bit
bitset_u8_bit:
    ex de, hl
    ld hl, bitset_u8_internal_bit_instruction + 1
    ld (hl), 46h
    jp bitset_u8_internal

; Set bit to 0
bitset_u8_res:
    ex de, hl
    ld hl, bitset_u8_internal_bit_instruction + 1
    ld (hl), 86h
    jp bitset_u8_internal

; Set bit to 1
bitset_u8_set:
    ex de, hl
    ld hl, bitset_u8_internal_bit_instruction + 1
    ld (hl), C6h
    jp bitset_u8_internal

#endif
