//
// Created by jpoole on 7/7/24.
//

#include <stdint.h>

extern char kernel_end;
static void* kernel_brk = &kernel_end + 1000000;

void * sbrk( intptr_t increment ) {
    void* last_brk = kernel_brk;
    kernel_brk = kernel_brk + increment;
    return last_brk;
}