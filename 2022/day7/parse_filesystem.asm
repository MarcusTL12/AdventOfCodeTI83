
#include "../../util/add_a_hl.asm"

#include "../../util/integer/parse.asm"
#include "../../util/integer/add.asm"

; Here the "heap" is the chunck of memory all the directory data will
; be stored. It behaves like a vec. It will add the next element to
; the end. The elements know the addresses of other elements in the heap:
; A dir contains a pointer to the next dir in its dir
; and a pointer to its first subdir

; Might not be enough space here
; #define heap saferam2

; Pointer to next free space on the heap
#define heap_pointer saferam1

; 4 byte buffer for dealing with 32 bit math/parsing
#define int_buf saferam1 + 2

; Directory struct offsets:
; size of directory
#define dir_size 0
; pointer to next dir in same directory as this dir. Is 0 if last.
#define dir_next 4
; pointer to first subdirectory (it will have a pointer to the next one)
#define dir_subd 6

; Total size of directory struct
#define sizeof_dir_struct 4 + 2 + 2

; input:
;   hl: pointer to beginning of input
parse_filesystem:
    ld de, heap
    ld (heap_pointer), de ; set heap pointer to start of heap
    ; implicit jump to recursive routine under

; input:
;   hl: pointer to beginning of next input line
; output:
;   hl: pointer to beginning of next input line after the parsed directory
;   de: pointer to root directory node of the parsed diretory
parse_filesystem_rec:
    ld ix, (heap_pointer) ; Have as base pointer for new dir node

    push hl
    ld hl, (heap_pointer)
    ld a, sizeof_dir_struct
    add_a_hl
    ld (heap_pointer), hl ; Increment heap pointer to point to next free space
    pop hl

    ld (ix), 0
    ld (ix + 1), 0
    ld (ix + 2), 0
    ld (ix + 3), 0

    ld (ix + 4), 0
    ld (ix + 5), 0

    ld (ix + 6), 0
    ld (ix + 7), 0

    ld bc, 0 ; pointer to previous subdir, or 0 if none have been parsed yet.

    push iy ; because getkey needs it
    parse_loop1:
        ld a, (hl)
        cp 0
        jp z, parse_loop1_break ; break if end of input

        push hl
        pop iy ; Have iy as base pointer for current line

        parse_loop1_find_next_line: ; set hl to start of next line
            ld a, (hl)
            inc hl
            cp '\n'
            jp z, parse_loop1_find_next_line_break ; look for newline character
        parse_loop1_find_next_line_break:

        ; check if cd command
        ld a, '$'
        cp (iy)
        jp nz, parse_no_cd

        ld a, 'c'
        cp (iy + 2)
        jp nz, parse_no_cd

        ld a, '.'
        cp (iy + 5)
        jp z, parse_loop1_break ; break if cd ..

        ; We are cd-ing down a directory

        push ix ; save pointer to current dir
        push bc ; save pointer to previous subdir
        call parse_filesystem_rec ; recursively call to parse subdirectory

        ; Now hl points to next line after that subdirector
        ; and de points to dir node of that subdirectory

        pop bc ; pop prevous subdir

        xor a
        cp b
        jp nz, parse_prev_not_null
        cp c
        jp nz, parse_prev_not_null

        inc a ; set a to 1. a = 1 => null, a = 0 => not null

        jp parse_prev_is_null

        parse_prev_not_null:

        push bc
        pop ix ; use ix for prev dir

        ld (ix + dir_next), e
        ld (ix + dir_next + 1), d ; save pointer to next subdir as the next pointer in the previous subdir

        parse_prev_is_null:

        pop ix ; then retrieve current dir

        push de
        pop bc ; Set the new directory as the previous subdirectory

        cp 0
        jp z, parse_loop1_continue ; if not first, continue loop

        ld (ix + dir_subd), e
        ld (ix + dir_subd + 1), d ; save pointer to first subdir, if this is the first

        parse_no_cd:

        ld a, (iy) ; check if first is numeric
        sub '0'
        cp '9'
        jp c, parse_loop1_continue ; Was not numeric, continue to next line

        push hl ; save pointer to next line
        push bc ; save pointer to previous subdir

        push iy
        pop hl ; load start of line to hl

        ld de, int_buf
        ld b, 4 ; 32 bit
        call integer_parse ; now int_buf is parsed to the number

        push ix
        pop hl ; load current dir location into hl

        ld de, int_buf
        ld b, 4
        call integer_add ; now current size is updated

        pop bc ; retrieve pointer to previous subdir
        pop hl ; retrieve pointer to next line

        parse_loop1_continue:
        jp parse_loop1
    parse_loop1_break:
    pop iy

    push ix
    pop de ; Put pointer to dir into de as return value

    ret

heap:
    .block 1024 * 2
