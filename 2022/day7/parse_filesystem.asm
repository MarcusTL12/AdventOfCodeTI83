
; Here the "heap" is the chunck of memory all the directory data will
; be stored. It behaves like a vec. It will add the next element to
; the end. The elements know the addresses of other elements in the heap:
; A dir contains a pointer to the next dir in its dir
; and a pointer to its first subdir

; Might not be enough space here
#define heap saferam2

; Pointer to next free space on the heap
#define heap_pointer saferam1

; Directory struct offsets:
; size of directory
#define dir_size 0
; pointer to next dir in same directory as this dir. Is 0 if last.
#define dir_next 4
; pointer to first subdirectory (it will have a pointer to the next one)
#define dir_subd 6

; input:
;   hl: pointer to beginning of input
parse_filesystem:
    ld de, heap
    ld (heap_pointer), de ; set heap pointer to start of heap
    ; implicit jump to recursive routine under

; input:
;   hl: pointer to beginning of next input line
parse_filesystem_rec:
    ret
