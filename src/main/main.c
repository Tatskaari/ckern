#include <kernel/kernel.h>
#include <stdio.h>
#include <stdlib.h>

void kernel_main(void)
{

    /* Initialize terminal interface */
    terminal_initialize();

    /* Newline support is left as an exercise. */
    printf("Hello, main!\n");
    printf("If you're using qemu, to get your mouse back, press ctr-alt or ctr-alt-g\n");

    // These should be allocated sequentially i.e. headchar2 should be 100 bytes after heapchars1
    char* heap_chars1 = malloc(100 * sizeof(char));
    char* heap_chars2 = malloc(100 * sizeof(char));
    free(heap_chars1);
    // This should be able to re-use the same memory from heapchars1
    char* heap_chars3 = malloc(100 * sizeof(char));
    printf("heap chars: %lu %lu %lu\n", (unsigned long)heap_chars1, (unsigned long)heap_chars2, (unsigned long)heap_chars3);
}
