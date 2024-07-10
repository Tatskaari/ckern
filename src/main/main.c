#include <kernel/kernel.h>
#include <stdio.h>
#include <stdlib.h>

#include "src/serial/serial.h"

int main(void)
{
    /* Initialize terminal interface */
    terminal_initialize();

    /* Newline support is left as an exercise. */
    printf("Hello, main!\n");
    printf("If you're using qemu, to get your mouse back, press ctr-alt or ctr-alt-g\n");

    serial_init(COM1);
    serial_write(COM1, "test");
    while(1) {
        char c;
        serial_read(COM1, &c, 1);
        if (c == '\r') {
            printf("\n");
        } else {
            printf("%c", c);
        }
    }
}
