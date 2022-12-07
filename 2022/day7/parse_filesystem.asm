
#include "../../util/add_a_hl.asm"

#include "../../util/integer/parse.asm"
#include "../../util/integer/add.asm"

; Here the "heap" is the chunck of memory all the directory data will
; be stored. It behaves like a vec. It will add the next element to
; the end. The elements know the addresses of other elements in the heap:
; A dir contains a pointer to the next dir in its dir
; and a boolean for whether it has subdirs. Its first subdir is next
; on the heap

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
; 1 if has subdirs, 0 if not
#define dir_subd 6

; Total size of directory struct
#define sizeof_dir_struct 4 + 2 + 1

; input:
;   hl: pointer to beginning of input
parse_filesystem:
    ld (saferam1 + 100), iy
    ld de, heap
    ld (heap_pointer), de ; set heap pointer to start of heap

    ; skip cd /
    parse_skip_cd:
        ld a, (hl)
        inc hl
        cp '\n'
        jp nz, parse_skip_cd ; look for newline character

    ; implicit jump to recursive routine under

; input:
;   hl: pointer to beginning of next input line
; output:
;   hl: pointer to beginning of next input line after the parsed directory
;   de: pointer to root directory node of the parsed diretory
parse_filesystem_rec:
    ld ix, (heap_pointer) ; Have as base pointer for new dir node

    push_allx
    ld iy, (saferam1 + 100)
    ld a, 'P'
    bcall(_putc)
    bcall(_newline)
    push ix
    pop hl
    bcall(_disphl)
    bcall(_newline)
    bcall(_getkey)
    pop_allx

    push hl
    ld hl, (heap_pointer)
    ld a, sizeof_dir_struct
    add_a_hl
    ld (heap_pointer), hl ; Increment heap pointer to point to next free space
    pop hl

    ld (ix + dir_size), 0 ; size = zero
    ld (ix + dir_size + 1), 0
    ld (ix + dir_size + 2), 0
    ld (ix + dir_size + 3), 0

    ld (ix + dir_next), 0 ; next = null
    ld (ix + dir_next + 1), 0

    ld (ix + dir_subd), 0 ; start with no subdir

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
            jp nz, parse_loop1_find_next_line ; look for newline character

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

        push_allx
        push de
        ld iy, (saferam1 + 100)
        ld a, 'Q'
        bcall(_putc)
        bcall(_newline)
        pop hl
        bcall(_disphl)
        bcall(_newline)
        bcall(_getkey)
        pop_allx

        ; Now hl points to next line after that subdirector
        ; and de points to dir node of that subdirectory

        pop bc ; pop prevous subdir

        xor a
        cp b
        jp nz, parse_prev_not_null
        cp c
        jp z, parse_prev_is_null

        parse_prev_not_null:

        push bc
        pop ix ; use ix for prev dir

        ld (ix + dir_next), e
        ld (ix + dir_next + 1), d   ; save pointer to next subdir as
                                    ; the next pointer in the previous subdir

        parse_prev_is_null:

        push de
        pop bc ; set prev dir

        pop ix ; then retrieve current dir

        push de
        pop bc ; Set the new directory as the previous subdirectory

        xor a
        cp (ix + dir_subd)
        jp nz, parse_subd_not_null ; if not first, continue loop
        cp (ix + dir_subd + 1)
        jp nz, parse_subd_not_null

        push_allx
        push de
        ld iy, (saferam1 + 100)
        ld a, 'q'
        bcall(_putc)
        bcall(_newline)
        pop hl
        bcall(_disphl)
        bcall(_newline)
        bcall(_getkey)
        pop_allx

        ld (ix + dir_subd), 1

        push_allx
        push ix
        ld iy, (saferam1 + 100)
        ld a, 'r'
        bcall(_putc)
        bcall(_newline)
        pop hl
        push hl
        bcall(_disphl)
        bcall(_newline)
        pop hl
        ld b, 7
        call print_hex
        bcall(_newline)
        bcall(_getkey)
        pop_allx

        parse_subd_not_null:

        push hl
        push ix
        pop hl
        call integer_add
        pop hl
        jp parse_loop1

        parse_no_cd:

        ld a, (iy) ; check if first is numeric
        sub '0'
        cp 10
        jp nc, parse_loop1 ; Was not numeric, continue to next line

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

        jp parse_loop1
    parse_loop1_break:
    pop iy

    push ix
    pop de ; Put pointer to dir into de as return value

    push_allx
    push de
    ld iy, (saferam1 + 100)
    ld a, 'p'
    bcall(_putc)
    bcall(_newline)
    pop hl
    push hl
    bcall(_disphl)
    bcall(_newline)
    pop hl
    ld b, 8
    call print_hex
    bcall(_newline)
    bcall(_getkey)
    pop_allx

    ret

heap:
    .block 1024 * 2
