//
// Created by jpoole on 7/7/24.
//

#include <stdint.h>

extern char kernel_end;
void* kernel_brk = &kernel_end;

void * sbrk( intptr_t increment ) {
    void* last_brk = kernel_brk;
    kernel_brk = kernel_brk + increment;
    return last_brk;
}