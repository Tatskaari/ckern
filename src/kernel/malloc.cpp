//
// Created by jpoole on 7/7/24.
//

#include <kernel/malloc.h>

extern char kernel_end;

void* get_kernel_end() {
    return &kernel_end;
}

