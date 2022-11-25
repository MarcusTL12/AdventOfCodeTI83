#ifndef println_inc
#define println_inc

println:
    bcall(_puts)
    bcall(_newline)
    ret

#endif
