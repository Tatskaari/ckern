#include <stdio.h>

#include "../serial/serial.h"
#include "../terminal/terminal.h"
#include "../files/files.h"

int write_to_com0(const char *buf, int count) {
    return serial_write(COM1, buf, count);
}

int main(void) {
    /* Initialize terminal interface */
    terminal_initialize();
    serial_init(COM1);


    // Posix expects these registered at these file handles.
    register_file_handle(0, "/dev/stdin", NULL, NULL);
    register_file_handle(1, "/dev/stdout", NULL, terminal_write);
    register_file_handle(2, "/dec/stderr", NULL, NULL);

    printf("This should print to the vga term\n");

    FILE* com0 = fopen("/dev/com1", "w");
    fprintf(com0, "This should print to com0\n");
}
