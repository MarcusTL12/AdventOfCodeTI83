
loop_16_bit_double:
    ld bc, 1000
    inc b
    loop_16_bit_double_loop1:
        ld a, b ; 4, 1
        ld b, c ; 4, 1
        ld c, a ; 4, 1
        loop_16_bit_double_loop2:
            push bc
            dec c
            ld l, b
            ld h, c
            call mul_h_l
            bcall(_newline)
            pop bc

            djnz loop_16_bit_double_loop2 ; 13, 2
        ld a, b ; 4, 1
        ld b, c ; 4, 1
        ld c, a ; 4, 1
        djnz loop_16_bit_double_loop1 ; 13, 2

    ; time: 4 * 6 * (n / 256) + 13 * n ~ 13 * n
    ; size: 6 + 4 = 10

loop_16_bit_single:
    ld bc, 1000
    loop_16_bit_single_loop3:
        push bc
        ld l, c
        ld h, b
        call mul_h_l
        bcall(_newline)
        pop bc

        dec bc ; 6, 1
        push hl ; 11, 1
        push de ; 11, 1
        push bc ; 11, 1
        pop hl ; 10, 1
        ld de, 0 ; 10, 3
        bcall(_cphlde) ; 17 + 10 + cp_logic, 4
        pop de ; 10, 1
        pop hl ; 10, 1
        jp nz, loop_16_bit_single_loop3 ; 10, 3
    
    ; time: (11 * 3 + 10 * 4 + 6 + 17 + 10 + cp_logic) * n
    ; = (185 + cp_logic) * n
    ; size: 7 + 3 * 2 + 4 = 17
