#ifndef push_all_inc
#define push_all_inc

#define push_all push af \ push bc \ push de \ push hl

#define pop_all pop hl \ pop de \ pop bc \ pop af

#define push_allx push af \ push bc \ push de \ push hl \ push ix \ push iy

#define pop_allx pop iy \ pop ix \ pop hl \ pop de \ pop bc \ pop af

#endif
