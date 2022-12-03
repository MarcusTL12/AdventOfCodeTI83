
; input: a: character
; output: a: a-z in 0-25, A-Z 26-51
get_priority:
    cp 95
    jp p, get_priority_lower_case
    sub 'A' - 26 ; 'A' is 26
    ret
    get_priority_lower_case:
    sub 'a' ; 'a' is 0
    ret
