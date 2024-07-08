#include <kernel/kernel.h>
#include<stdio.h>

void kernel_main(void)
{

    /* Initialize terminal interface */
    terminal_initialize();

    /* Newline support is left as an exercise. */
    printf("Hello, main!\n");
    printf("If you're using qemu, to get your mouse back, press ctr-alt or ctr-alt-g\n");

}
